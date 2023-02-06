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
        Form {
            scoreBoardView()
            typeOverView()
            activityView()
                .focused($nameInFocus)
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
            let syllableString = (viewModel.typePronounceNew == .child) ? viewModel.item.replacingOccurrences(of: "-", with: " ") : viewModel.addSpaces(value: viewModel.stripString(value: viewModel.item))
            let tempString1 = (viewModel.syllable) ? syllableString :  viewModel.stripString(value: viewModel.item)
            
            let prevSyllableString = (viewModel.typePronounceNew == .child) ? viewModel.previousItem.replacingOccurrences(of: "-", with: " ") : viewModel.addSpaces(value: viewModel.stripString(value: viewModel.previousItem))
            let prevtempString1 = (viewModel.syllable) ? prevSyllableString :  viewModel.stripString(value: viewModel.previousItem)
            
            let  tempString = (viewModel.isPlaying) && (!viewModel.doubleTap) && (viewModel.typePositionReading == .after) ? prevtempString1 : tempString1
            
            if (viewModel.typeIndexFont == .text) {
                Text("\(tempString)")
                    .font(.custom(monospacedFont, size: 32))
                    .frame(height:60)
            }
            else {
                Text("\(tempString)")
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
//            Image(systemName: viewModel.isPlaying ? "speaker.wave.3" : "speaker")
//            Spacer()
            if ((viewModel.syllable) && (viewModel.typeActivity == .word)) || (viewModel.typeActivity == .character) {
                Text("\(viewModel.typePronounceNew.stringValue().localized())")
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
            //                .foregroundColor(.bart_green)
            Spacer()
            Text("\(viewModel.getLessonName())")
            //                .foregroundColor(.bart_green)
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
                        //
                        //
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
            Button("next".localized()) {
                let result = viewModel.check(input: input)
                if (result > -1) { viewModel.indexLesson = result }
            }
            .disabled(viewModel.isPlaying)
        }
    }
}

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundView()
            .environmentObject(LouisViewModel())
    }
}


