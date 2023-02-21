//
//  PlaygroundView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI
import Soundable
import SwiftProgress
import AVFoundation

struct PlaygroundView: View {
    @EnvironmentObject var viewModel: LouisViewModel
    
    let nextword : SystemSoundID = 1113
    
    @State private var atStartup = true
    
    @FocusState private var nameInFocus: Bool
    
    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
        Form {
            scoreBoardView()
                .padding(20)
//            if (viewModel.conditional) { //<=
                typeOverView()
//                    .padding(20)
//            }
            activityView()
                .padding(20)
                .focused($nameInFocus)
//            Spacer()
        }
        .onTapGesture(count:2) {
            viewModel.doubleTap = true
            viewModel.Talk(value : viewModel.item.lowercased())
        }
        .onAppear() {
            self.nameInFocus = true
            
            if (atStartup || viewModel.updateViewData) {
                viewModel.Shuffle()
                atStartup = false
                viewModel.updateViewData = false
            }
            
            if (viewModel.typePositionReading == .before) {
                viewModel.Talk(value : viewModel.item.lowercased())
            }
            else //nextone
            {
                AudioServicesPlaySystemSound(nextword)
            }
        }
    }
    
}

struct typeOverView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    
    let monospacedFont = "Sono-Regular"
    
    var body: some View {
        Section {
            if (viewModel.typeIndexFont == .text) {
                Text("\(viewModel.showString())")
                    .font(.custom(monospacedFont, size: 32))
                    .frame(height:60)
            }
            else {
                Text("\(viewModel.showString())")
                    .font(Font.custom("bartimeus8dots", size: 32))
                    .frame(height:60)
            }
        }
    }
}


struct overviewSettingsView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    
    var body: some View {
        HStack {
//            Image(systemName: viewModel.conditional ? "checkmark.circle": "circle")
            Image(systemName: viewModel.isPlaying ? "speaker.wave.3" : "speaker")
                .frame(minWidth: 20, maxWidth: 20)
//            HStack {
//                Text(viewModel.showString())
//                Spacer()
//            }
//                .frame(minWidth: 200, maxWidth: 200)
            Spacer()
            if ((viewModel.syllable) && (viewModel.typeActivity == .word)) || (viewModel.typeActivity == .character) {
                Text("\(viewModel.typePronounce.stringValue().localized())")
                Spacer()
            }
            let imageSound1 = viewModel.typePositionReading == .before ? "square.lefthalf.filled" : "square.split.2x1"
            let imageSound2 = viewModel.typePositionReading == .after ? "square.righthalf.filled" : imageSound1
            Image(systemName: imageSound2)
            if (viewModel.talkWord && viewModel.syllable && viewModel.typeActivity == .word) {
                Image(systemName: "placeholdertext.fill")
            }
        }
    }
}

struct progressView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    
    var body: some View {
        HStack {
            Text("\(viewModel.count)")
            Spacer()
            LinearProgress(
                progress: CGFloat(100*viewModel.count/trys[viewModel.indexTrys]),
                foregroundColor: viewModel.myColor,
                backgroundColor:  Color.green.opacity(0.2),
                fillAxis: .horizontal
            )
            .frame(height: 5)
            Spacer()
            Text("\(trys[viewModel.indexTrys])")
        }
        .font(.footnote)
    }
}

struct scoreBoardView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    var body: some View {
        Section {
            VStack {
                methodLessonView()
                Spacer()
                progressView()
                Spacer()
                overviewSettingsView()
                    .font(.footnote)
            }
            .frame(height: 100)
        }
        .accessibilityHidden(true)
    }
}

struct methodLessonView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    
    var body: some View {
        HStack {
            Text("\(viewModel.getMethodeName())")
            Spacer()
            Text("\(viewModel.getLessonName())")
        }
        .font(.headline)
    }
}

struct activityView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    let monospacedFont = "Sono-Regular"
    
    @State private var input: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        if viewModel.conditional {
            VStack {
                TextField("", text:$input)
                    .font(.custom(monospacedFont, size: 32))
                    .foregroundColor(.bart_green)
                    .focused($isFocused)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .frame(height:60)
                    .onSubmit {
                        let result = viewModel.check(input: input)
                        if (result > -1) { viewModel.indexLesson = result }
                        input = ""
                        isFocused = true
                    }
                Spacer()
                Text("\(input)")
                    .frame(height: 60)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(viewModel.typeIndexFont == .text ? .custom(monospacedFont, size: 32): Font.custom("bartimeus8dots", size: 32))
                    .accessibilityHidden(true)
            }
        }
        else
        {
            Button(action: {
                let result = viewModel.check(input: input)
                if (result > -1) { viewModel.indexLesson = result }
            }) {
                Text("next".localized())
                //                Text(viewModel.showString())
                //                    .font(viewModel.typeIndexFont == .text ? .custom(monospacedFont, size: 32): Font.custom("bartimeus8dots", size: 32))
                
            }
            //            Button(action: {
            //                let result = viewModel.check(input: input)
            //                if (result > -1) { viewModel.indexLesson = result }
            //            }) {
            //                Text("\(viewModel.showString())")
            //                    .frame(maxWidth: .infinity, alignment: .leading)
            //                    .font(viewModel.typeIndexFont == .text ? .custom(monospacedFont, size: 32): Font.custom("bartimeus8dots", size: 32))
            //            }
            //            .disabled(viewModel.isPlaying)
            //            .modifier(Square(color: .bart_green, width: .infinity))
        }
    }
}



struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundView()
            .environmentObject(LouisViewModel())
    }
}


