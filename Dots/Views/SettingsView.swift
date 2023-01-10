//
//  SettingsView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI


struct SettingsView: View {
    @EnvironmentObject var viewModel: PlaygroundViewModel

    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    
    var body: some View {
        NavigationView {
            Form {
                overviewMethodsView()
                overviewActivityView()
                overviewGeneralView()
                resetModelView()
            }
            .navigationTitle("settings".localized())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct overviewMethodsView : View {
    @EnvironmentObject var viewModel: PlaygroundViewModel
    
    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    
    var body: some View {
        Section {
            Picker("Language".localized(), selection: $indexLanguage) {
                ForEach(viewModel.Languages, id: \.id) { language in
                    Text(language.name ?? "no language").tag(language.id)
                }
            }
            .onChange(of: indexLanguage) { tag in
                indexLesson = 0
                indexMethod = 0
//                viewModel.changeIndex = true
                viewModel.count = 0
            }
            
//            Text("\(viewModel.Languages[4].name ?? "no name")")
            
            Picker("method".localized(), selection: $indexMethod) {
                ForEach(viewModel.Languages[indexLanguage].method, id: \.id) { method in
                    Text(method.name).tag(method.id)
                }
            }
            .onChange(of: indexMethod) { tag in
                print("Change in tag method: \(tag)")
                indexLesson = 0
                viewModel.updateViewData = true
                viewModel.count = 0
            }
            
            Picker("lesson".localized(), selection: $indexLesson) {
                ForEach(viewModel.Languages[indexLanguage].method[indexMethod].lesson, id: \.id) { lesson in
                    Text(lesson.name).tag(lesson.id)
                }
            }
            .onChange(of: indexLesson) { tag in
                print("Change in tag lesson: \(tag)")
                viewModel.updateViewData = true
                viewModel.count = 0
            }
        }
    }
}


struct overviewActivityView : View {
    @EnvironmentObject var viewModel: PlaygroundViewModel
    
    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    
    @AppStorage("INDEX_ACTIVITY") var indexActivity = 0
    let CHARACTER = 0
    let WORD = 1
    
    let pauses = [1, 2, 3, 4, 5]
    let activities = ["character","word"]//,"syllable","sentence","all"]
    let pronounce = ["child","adult","form", "meaning"]
    
    var body: some View {
        Section {
            
            Picker("activity".localized(), selection: $indexActivity)
            {
                ForEach(0 ..< activities.count, id: \.self) {
                    Text("\(activities[$0])".localized()).tag($0)
                }
                
            }
            .onChange(of: indexActivity) { tag in
                print("change in indexActivity  \(activities[tag]) tag \(tag)")
                viewModel.typeActivity = activities[tag]
                print("=====\(viewModel.typeActivity)")
            }
            
            if (indexActivity==WORD) {
                Toggle("chop".localized(), isOn: $viewModel.syllable)
                    .onChange(of: viewModel.syllable) {value in
                    }
            }
            
            if (viewModel.syllable) && (indexActivity==WORD) {
                Toggle("talkword".localized(), isOn: $viewModel.talkWord)
                    .onChange(of: viewModel.talkWord) {value in
                    }
            }
            
            if (viewModel.syllable) && (indexActivity==WORD) {
                Picker("pause".localized(),selection: $viewModel.indexPauses) {
                    ForEach(0 ..< pauses.count, id: \.self) {
                        Text("\(pauses[$0]) x").tag($0)
                    }
                }
                .onChange(of: viewModel.indexPauses) {
                    tag in
                    viewModel.nrOfPause = pauses[tag]
                    
                }
            }
            
            if ((viewModel.syllable) && (indexActivity==WORD)) || (indexActivity==CHARACTER){
                Picker("pronouncation".localized(), selection: $viewModel.indexPronounce)
                {
                    ForEach(0 ..< pronounce.count, id: \.self) {
                        Text("\(pronounce[$0])".localized()).tag($0)
                    }
                    
                }
                .onChange(of: viewModel.indexPronounce) { tag in
                    print("change in indexActivity  \(pronounce[tag]) tag \(tag)")
                    viewModel.typePronounce = pronounce[tag]
                }
            }
        }
    }
}

struct overviewGeneralView : View {
    @EnvironmentObject var viewModel: PlaygroundViewModel
    
    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    
    let reading = ["not","before","after"]
    let fonts = ["text","6dots", "8dots"]
    let words = [1, 2, 3, 5, 8, 13, 21]
    
    var body: some View {
        Section{
            Picker("nroftrys".localized(), selection: $viewModel.indexWords) {
                ForEach(0 ..< words.count, id: \.self) {
                    Text("\(words[$0])").tag($0)
                }
            }
            .onChange(of: viewModel.indexWords) { tag in
                print("change in nrofWords \(words[tag])")
                viewModel.nrofTrys = words[tag]
                viewModel.count = 0
            }
            
            Toggle("conditional".localized(), isOn: $viewModel.conditional)
                .onChange(of: viewModel.conditional) {value in
                }
            
            Picker("reading".localized(), selection: $viewModel.indexReading) {
                ForEach(0..<reading.count, id: \.self) {
                    Text("\(reading[$0])".localized()).tag($0)
                }
            }
            .onChange(of: viewModel.indexReading) { tag in
                print("change in indexReading \(tag)")
                viewModel.readSound = reading[tag]
            }
            
            Picker("font".localized(), selection: $viewModel.indexFont) {
                ForEach(0..<fonts.count, id: \.self) {
                    Text("\(fonts[$0])".localized()).tag($0)
                }
            }
            .onChange(of: viewModel.indexFont) { tag in
                print("change in fonts \(tag)")
            }
        }
    }
}

struct resetModelView : View {
    @EnvironmentObject var viewModel: PlaygroundViewModel
    
    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    @AppStorage("INDEX_ACTIVITY") var indexActivity = 0
    
    let reading = ["not","before","after"]
    let activities = ["character","word"]//,"syllable","sentence","all"]
    let words = [1, 2, 3, 5, 8, 13, 21]
    
    var body: some View {
        Section{
            Button {
                indexMethod = 0
                indexLesson = 0
                indexLanguage = 0
                
                indexActivity = 0
                viewModel.indexReading = 1
                viewModel.indexWords = 3
                
                viewModel.brailleOn = true
                viewModel.conditional = false
                viewModel.syllable = false
                
                viewModel.readSound = reading[viewModel.indexReading]
                viewModel.typeActivity = activities[indexActivity]
                viewModel.nrofTrys = words[viewModel.indexWords]
                
            } label : {
                Text("reset".localized())
            }
            
        }
    }
}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(PlaygroundViewModel())
    }
}



