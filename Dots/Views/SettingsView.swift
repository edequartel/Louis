//
//  SettingsView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI


struct SettingsView: View {
    @EnvironmentObject var viewModel: LouisViewModel
    
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
    @EnvironmentObject var viewModel: LouisViewModel

    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0

    var body: some View {
        Section {
            Picker("Language".localized(), selection: $indexLanguage) {
                ForEach(viewModel.Languages, id: \.id) { language in
                    Text(language.name).tag(language.id)
                }
            }
            .onChange(of: indexLanguage) { tag in
                viewModel.indexLanguage = indexLanguage
                indexMethod = 0
                viewModel.indexMethod = 0
                indexLesson = 0
                viewModel.indexLesson = 0
                viewModel.count = 0
            }

            Picker("method".localized(), selection: $indexMethod) {
                ForEach(viewModel.Languages[indexLanguage].method, id: \.id) { method in
                    Text(method.name).tag(method.id)
                }
            }
            .onChange(of: indexMethod) { tag in
                print("Change in tag method: \(tag)")
                viewModel.indexMethod = indexMethod
                indexLesson = 0
                viewModel.indexLesson = 0                
                viewModel.updateViewData = true
                viewModel.count = 0
            }

            Picker("lesson".localized(), selection: $viewModel.indexLesson) {
                ForEach(viewModel.Languages[indexLanguage].method[indexMethod].lesson, id: \.id) { lesson in
                    Text(lesson.name).tag(lesson.id)
                }
            }
            .onChange(of: viewModel.indexLesson) { tag in
                print("Change in tag lesson: \(tag)")
                indexLesson = viewModel.indexLesson
                viewModel.updateViewData = true
                viewModel.count = 0
            }
        }
    }
}


struct overviewActivityView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    
    @AppStorage("INDEX_ACTIVITY") var indexActivity = 0
    @AppStorage("SYLLABLE") var syllable = false
    @AppStorage("INDEX_PRONOUNCE") var indexPronounce = 0
    
    @State var typeActivity: activityEnum = .character
    
    let pauses = [1, 2, 3, 4, 5]
    
    var body: some View {
        Section {
            Picker("activity".localized(), selection: $indexActivity) {
                ForEach(activityEnum.allCases, id: \.self) { typ in
                    Text("\(typ.stringValue().localized())").tag(typ.rawValue)
                }
            }
            .onChange(of: indexActivity) { tag in
                print("change in indexActivity  \(tag)")
                if let activity = activityEnum(rawValue: tag) {
                    viewModel.typeActivity = activity
                }
                viewModel.updateViewData = true
            }
            
            if (viewModel.typeActivity == .word) {
                Toggle("chop".localized(), isOn: $syllable)
                    .onChange(of: syllable) {value in
                        viewModel.syllable = syllable
                    }
            }
            
            if (viewModel.syllable) && (viewModel.typeActivity == .word) {
                Toggle("talkword".localized(), isOn: $viewModel.talkWord)
                    .onChange(of: viewModel.talkWord) {value in
                    }
            }
            
            if (viewModel.syllable) && (viewModel.typeActivity == .word) {
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
            
            if ((viewModel.syllable) && (viewModel.typeActivity == .word)) || (viewModel.typeActivity == .character){
                Picker("pronouncation".localized(), selection: $indexPronounce) {
                    ForEach(pronounceEnum.allCases, id: \.self) { pronounce in
                        Text("\(pronounce.stringValue().localized())").tag(pronounce.rawValue)
                    }
                }
                .onChange(of: indexPronounce) { tag in
                    print("change in indexPronounce  \(tag)")
                    if let pronounce = pronounceEnum(rawValue: tag) {
                        viewModel.typePronounceNew = pronounce
                    }
                }
            }
        }
    }
}

struct overviewGeneralView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    
    @AppStorage("INDEX_TRYS") var indexTrys = 0
    @AppStorage("CONDITIONAL") var conditional = true
    @AppStorage("INDEX_READING") var indexPosition = 0
    @AppStorage("INDEX_FONT") var indexFont = 0
    
    var body: some View {
        Section{
            Picker("nroftrys".localized(), selection: $indexTrys) {
                ForEach(0 ..< trys.count, id: \.self) {
                    Text("\(trys[$0])").tag($0)
                }
            }
            .onChange(of: indexTrys) { tag in
                print("change in nrofWords \(trys[tag])")
                viewModel.indexTrys = indexTrys
                viewModel.count = 0
            }
            
            Toggle("conditional".localized(), isOn: $conditional)
                .onChange(of: conditional) {value in
                    viewModel.conditional = conditional
                }
            
            Picker("reading".localized(), selection: $indexPosition) {
                ForEach(positionReadingEnum.allCases, id: \.self) { position in
                    Text("\(position.stringValue().localized())").tag(position.rawValue)
                }
            }
            .onChange(of: indexPosition) { tag in
                print("change in indexPosition \(tag)")
                if let position = positionReadingEnum(rawValue: tag) {
                    viewModel.typePositionReading = position
                }
            }
            
            Picker("font".localized(), selection: $indexFont) {
                ForEach(fontEnum.allCases, id: \.self) { font in
                    Text("\(font.stringValue().localized())").tag(font.rawValue)
                }
            }
            .onChange(of: indexFont) { tag in
                print("change in indexFont \(tag)")
                if let font = fontEnum(rawValue: tag) {
                    viewModel.typeIndexFont = font
                }
            }
        }
    }
}

struct resetModelView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    
    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    
    @AppStorage("INDEX_ACTIVITY") var indexActivity = 0
    @AppStorage("SYLLABLE") var syllable = false
    @AppStorage("INDEX_PRONOUNCE") var indexPronounce = 0
    @AppStorage("INDEX_TRYS") var indexTrys = 0
    @AppStorage("CONDITIONAL") var conditional = true
    @AppStorage("INDEX_READING") var indexPositionReading = 0
    @AppStorage("INDEX_FONT") var indexFont = 0
        
    var body: some View {
        Section{
            Button {
                indexMethod = 0
                viewModel.indexMethod = indexMethod
                indexLesson = 0
                viewModel.indexLesson = indexLesson
                
                indexActivity = 0
                if let activity = activityEnum(rawValue: indexActivity) {
                    viewModel.typeActivity = activity
                }
                
                syllable = false
                viewModel.syllable = syllable
                
                indexPronounce = 0
                if let pronouncation = pronounceEnum(rawValue: indexPronounce) {
                    viewModel.typePronounceNew = pronouncation
                }
                
                indexTrys = 0
                viewModel.indexTrys = indexTrys
                
                conditional = true
                viewModel.conditional = conditional
                
                indexPositionReading = 0
                if let positionReading = positionReadingEnum(rawValue: indexPositionReading) {
                    viewModel.typePositionReading = positionReading
                }
                
                indexFont = 1
                if let font = fontEnum(rawValue: indexFont) {
                    viewModel.typeIndexFont = font
                }
                
            } label : {
                Text("reset".localized())
            }
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(LouisViewModel())
    }
}



