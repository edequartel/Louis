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
    
    @State private var textFieldText = ""
    
    var body: some View {
        Form {
            scoreBoardView(textFieldText: $textFieldText)
            if (viewModel.conditional) { //<=
                typeOverView()
            }
            activityView(textFieldText: $textFieldText)
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
        .onAppear() {
            textFieldText = ""
        }
//        .ignoresSafeArea(.container)
    }
}

struct scoreBoardView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    @Binding var textFieldText: String
    
    var body: some View {
        Section {
            VStack {
                methodLessonView()
                Spacer()
                progressView()
                Spacer()
                overviewSettingsView()
                    .font(.footnote)
                if (viewModel.assist) {//&& (viewModel.conditional)) || ((viewModel.assist) && (!viewModel.conditional)) {
                    Spacer()
                    assistView(textFieldText: $textFieldText)
                        .font(.footnote)
                }
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

struct overviewSettingsView : View {
    @EnvironmentObject var viewModel: LouisViewModel

    var body: some View {
        HStack {
//            Image(systemName: viewModel.conditional ? "checkmark.circle": "circle")
            Image(systemName: viewModel.isPlaying ? "speaker.wave.3" : "speaker")
            Spacer()
            if ((viewModel.syllable) && (viewModel.typeActivity == .word)) || (viewModel.typeActivity == .character) {
                Text("\(viewModel.typePronounce.stringValue().localized())")
                Spacer()
            }
            imageSpeakView()
        }
    }
}

struct imageSpeakView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    var body: some View {
        let imageSound1 = viewModel.typePositionReading == .before ? "square.lefthalf.filled" : "square.split.2x1"
        let imageSound2 = viewModel.typePositionReading == .after ? "square.righthalf.filled" : imageSound1
        Image(systemName: imageSound2)
        if (viewModel.talkWord && viewModel.syllable && viewModel.typeActivity == .word) {
            Image(systemName: "placeholdertext.fill")
        }
    }
}

struct assistView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    @Binding var textFieldText: String

    let monospacedFont = "Sono-Regular"

    var body: some View {
        
            HStack {
                
                Text(viewModel.showString())
                
                Spacer()
                Text(textFieldText)
                    .lineLimit(1)
                    .truncationMode(.tail)

        }
    }
}

struct typeOverView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    
    let monospacedFont = "Sono-Regular"
    
    var body: some View {
        Section {
            Text("\(viewModel.showString())")
                .font(Font.custom("bartimeus8dots", size: 32))
                .frame(height:60)
        }
    }
}

struct activityView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    let monospacedFont = "Sono-Regular"

    @Binding var textFieldText: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        if viewModel.conditional {
            Section {
                TextField("", text:$textFieldText)
                    .font(Font.custom("bartimeus8dots", size: 32))
                    .foregroundColor(.bart_green)
                    .focused($isFocused)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .frame(height:60)
                    .onSubmit {
                        let result = viewModel.check(input: textFieldText)
                        if (result > -1) { viewModel.indexLesson = result }
                        textFieldText = ""
                        isFocused = true
                    }
            }
        }
        else
        {
            Button(action: {
                let result = viewModel.check(input: textFieldText)
                if (result > -1) { viewModel.indexLesson = result }
            }) {
                Text(viewModel.showString())
                    .font(Font.custom("bartimeus8dots", size: 32))
                
            }
        }
    }
}

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundView()
            .environmentObject(LouisViewModel())
    }
}


