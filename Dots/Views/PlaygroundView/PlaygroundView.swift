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
    
    let monospacedFont = "Sono-Regular"
    
    let nextlevel : SystemSoundID = 1115
    let nextword : SystemSoundID = 1113
    
    @State private var input: String = ""
    @State private var atStartup = true
    @FocusState private var isFocused: Bool
    @State private var fillPercentage: CGFloat = 20
    
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    VStack {
                        methodLessonView()
                        Spacer()
                        progressView()
                        Spacer()
                        HStack{
                            overviewSettingsView()
                        }
                        .font(.footnote)
                    }
                    .frame(height: 100)
                }
                .accessibilityHidden(true)
                
                Section {
                    typeOverView()
                }
                
                TextField("", text:$input)
                    .font(.custom(monospacedFont, size: 32))
                    .foregroundColor(.blue)
                    .focused($isFocused)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .frame(height:60)
                    .onSubmit {
                        viewModel.check(input)
                        input = ""
                        isFocused = true
                    }
                
                //                Button("inc") {
                //                    viewModel.inc()
                //                }
                //                Text("\(viewModel.count)")
                
                Text("\(input)")
                    .frame(height:60)
                    .font(viewModel.indexFont==0 ? .custom(monospacedFont, size: 32): viewModel.indexFont==1 ? Font.custom("bartimeus6dots", size: 32) : Font.custom("bartimeus8dots", size: 32))
                    .accessibilityHidden(true)
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
                //
                
                //
                if !viewModel.Languages.isEmpty{
                    print("Languages not empty")
                    viewModel.items = (viewModel.typeActivity == "character") ?  viewModel.Languages[viewModel.indexLanguage].method[viewModel.indexMethod].lesson[viewModel.indexLesson].letters.components(separatedBy: " ").shuffled() :
                    viewModel.Languages[viewModel.indexLanguage].method[viewModel.indexMethod].lesson[viewModel.indexLesson].words.components(separatedBy: " ").shuffled()
                    viewModel.item=viewModel.items[0]
                    //
                }
                viewModel.item=viewModel.items[0]
                //
                isFocused.toggle()
                viewModel.Shuffle()
                
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
//    @StateObject var viewModel = PlaygroundViewModel()
    @EnvironmentObject var viewModel: PlaygroundViewModel
    
    let monospacedFont = "Sono-Regular"
    let child = 0
    let adult = 1
    let form = 2
    let form_adult = 3
    
    var body: some View {
//        Text("\(viewModel.item)")
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

struct overviewSettingsView : View {
    @EnvironmentObject var viewModel: PlaygroundViewModel
    
    let CHARACTER = 0
    let WORD = 1
    
    var body: some View {
        Image(systemName: viewModel.conditional ? "checkmark.circle": "circle")
        Image(systemName: viewModel.isPlaying ? "speaker.wave.3" : "speaker")
        Spacer()
        if ((viewModel.syllable) && (viewModel.indexActivity==WORD)) || (viewModel.indexActivity==CHARACTER) {
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

struct methodLessonView : View {
    @EnvironmentObject var viewModel: PlaygroundViewModel
    var body: some View {
        HStack {
            Text("\(viewModel.getMethodeName())")
                .bold()
            Spacer()
            Text("\(viewModel.getLessonName())")
        }
        .font(.headline)
    }
}

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundView()
    }
}


