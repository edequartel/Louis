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
    @EnvironmentObject var viewModel: PlaygroundViewModel
    
    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    
    let monospacedFont = "Sono-Regular"
    
    let nextlevel : SystemSoundID = 1115
    let nextword : SystemSoundID = 1113
    
    @State private var atStartup = true
    @State private var fillPercentage: CGFloat = 20
    
    var body: some View {
        NavigationView{
            Form {
                scoreBoardView()
                typeOverView()
                activityView()
            }
            .navigationTitle("play".localized())
            .navigationBarTitleDisplayMode(.inline)
        }
        .onTapGesture(count:2) {
            viewModel.doubleTap = true
            viewModel.Listen(value : viewModel.item)
            print("\(viewModel.previousItem)")
            print("\(viewModel.item)")
        }
        .onAppear() {
            if (atStartup || viewModel.updateViewData) {
                if !viewModel.Languages.isEmpty{
                    print("Languages not empty")
                    viewModel.items = (viewModel.typeActivity == "character") ?  viewModel.Languages[indexLanguage].method[indexMethod].lesson[indexLesson].letters.components(separatedBy: " ").shuffled() :
                    viewModel.Languages[indexLanguage].method[indexMethod].lesson[indexLesson].words.components(separatedBy: " ").shuffled()
                    viewModel.item=viewModel.items[0]
                }
                viewModel.item=viewModel.items[0]
                viewModel.Shuffle(indexLanguage: indexLanguage, indexMethod: indexMethod, indexLesson: indexLesson)
                
                atStartup = false
                viewModel.updateViewData = false
            }
            
            if (viewModel.readSound == "before") {
                viewModel.Listen(value : viewModel.item)
            }
            else //nextone
            {
                AudioServicesPlaySystemSound(nextword)
            }
        }
    }
    
}

struct typeOverView : View {
    @EnvironmentObject var viewModel: PlaygroundViewModel
    
    let monospacedFont = "Sono-Regular"
    let child = 0
    let adult = 1
    let form = 2
    let form_adult = 3
    
    var body: some View {
        Section {
            let syllableString = (viewModel.indexPronounce == child) ? viewModel.item.replacingOccurrences(of: "-", with: " ") : viewModel.addSpaces(value: viewModel.stripString(value: viewModel.item))
            let tempString1 = (viewModel.syllable) ? syllableString :  viewModel.stripString(value: viewModel.item)
            
            let prevSyllableString = (viewModel.indexPronounce == viewModel.child) ? viewModel.previousItem.replacingOccurrences(of: "-", with: " ") : viewModel.addSpaces(value: viewModel.stripString(value: viewModel.previousItem))
            let prevtempString1 = (viewModel.syllable) ? prevSyllableString :  viewModel.stripString(value: viewModel.previousItem)
            
            let  tempString = (viewModel.isPlaying) && (!viewModel.doubleTap) && (viewModel.readSound == "after") ? prevtempString1 : tempString1
            
            if (viewModel.indexFont==0) {
                Text("\(tempString)")
                    .font(.custom(monospacedFont, size: 32))
                    .frame(height:60)
            }
            else {
                Text("\(tempString)")
                    .font(Font.custom((viewModel.indexFont==1) ? "bartimeus6dots" : "bartimeus8dots", size: 32))
                    .frame(height:60)
            }
        }
    }
}

struct overviewSettingsView : View {
    @EnvironmentObject var viewModel: PlaygroundViewModel
    @AppStorage("INDEX_ACTIVITY") var indexActivity = 0
    
    let CHARACTER = 0
    let WORD = 1
    
    var body: some View {
        HStack {
            Image(systemName: viewModel.conditional ? "checkmark.circle": "circle")
            Image(systemName: viewModel.isPlaying ? "speaker.wave.3" : "speaker")
            Spacer()
            if ((viewModel.syllable) && (indexActivity==WORD)) || (indexActivity==CHARACTER) {
                Text("\(viewModel.typePronounce)".localized())
                Spacer()
            }
            let imageSound1 = viewModel.readSound=="before" ? "square.lefthalf.filled" : "square.split.2x1"
            let imageSound2 = viewModel.readSound=="after" ? "square.righthalf.filled" : imageSound1
            Image(systemName: imageSound2)
            if (viewModel.talkWord && viewModel.syllable && viewModel.typeActivity=="word") {
                Image(systemName: "placeholdertext.fill")
            }
        }
    }
}

struct progressView : View {
    @EnvironmentObject var viewModel: PlaygroundViewModel
    @State private var myColor = Color.green
    
    var body: some View {
        HStack {
            Text("\(viewModel.count)")
            Spacer()
            LinearProgress(
                progress: CGFloat(100*viewModel.count/viewModel.nrofTrys),
                foregroundColor: myColor,
                backgroundColor:  Color.green.opacity(0.2),
                fillAxis: .horizontal
            )
            .frame(height: 5)
            Spacer()
            Text("\(viewModel.nrofTrys)")
        }
        .font(.footnote)
    }
}

struct scoreBoardView : View {
    @EnvironmentObject var viewModel: PlaygroundViewModel
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
    @EnvironmentObject var viewModel: PlaygroundViewModel

    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    
    var body: some View {
        HStack {
            Text("\(viewModel.getMethodeName(indexLanguage: indexLanguage, indexMethod: indexMethod))")
                .bold()
            Spacer()
            Text("\(viewModel.getLessonName(indexLanguage: indexLanguage, indexMethod: indexMethod, indexLesson: indexLesson))")
        }
        .font(.headline)
    }
}

struct activityView : View {
    @EnvironmentObject var viewModel: PlaygroundViewModel
    
    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    
    let monospacedFont = "Sono-Regular"
    
    @State private var input: String = ""
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextField("", text:$input)
            .font(.custom(monospacedFont, size: 32))
            .foregroundColor(.blue)
            .focused($isFocused)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .frame(height:60)
            .onSubmit {
                let result = viewModel.check(input: input, indexLanguage: indexLanguage, indexMethod: indexMethod, indexLesson: indexLesson)
                if (result > -1) { indexLesson = result }
                input = ""
                isFocused = true
            }
//            .onAppear(perform: isFocused.toggle())
        Text("\(input)")
            .frame(height:60)
            .font(viewModel.indexFont==0 ? .custom(monospacedFont, size: 32): viewModel.indexFont==1 ? Font.custom("bartimeus6dots", size: 32) : Font.custom("bartimeus8dots", size: 32))
            .accessibilityHidden(true)
    }
        
}

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundView()
    }
}


