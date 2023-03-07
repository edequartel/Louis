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
//              resetModelView()
            }
            .navigationBarTitle(Text("settings".localized()), displayMode: .inline)
            .navigationBarItems(trailing:
                                    NavigationLink(destination: DownloadView()) {
                Image(systemName: "square.and.arrow.down")
                    .accessibilityLabel("download".localized())
            })
        }
    }
}


struct overviewMethodsView : View {
    @EnvironmentObject var viewModel: LouisViewModel

    var body: some View {
        Section {
            Picker("Language".localized(), selection: $viewModel.indexLanguage) {
                ForEach(viewModel.Languages, id: \.id) { language in
                    if (checkIfFolderExists(value: language.zip)) {
                        Text(language.name.localized()).tag(language.id)
                    }
                }
            }
            .onChange(of: viewModel.indexLanguage) { tag in
                viewModel.indexMethod = 0
                viewModel.indexLesson = 0
                viewModel.count = 0
//                viewModel.Shuffle() //?
            }

            Picker("method".localized(), selection: $viewModel.indexMethod) {
                ForEach(viewModel.Languages[viewModel.indexLanguage].method, id: \.id) { method in
                    Text(method.name).tag(method.id)
                }
            }
            .onChange(of: viewModel.indexMethod) { tag in
                print("Change in tag method: \(tag)")
                viewModel.indexLesson = 0
                viewModel.updateViewData = true
                viewModel.count = 0
//                viewModel.Shuffle() //?
            }

            Picker("lesson".localized(), selection: $viewModel.indexLesson) {
                ForEach(viewModel.Languages[viewModel.indexLanguage].method[viewModel.indexMethod].lesson, id: \.id) { lesson in
                    Text(lesson.name).tag(lesson.id)
                }
            }
            .onChange(of: viewModel.indexLesson) { tag in
                print("Change in tag lesson: \(tag)")
                viewModel.updateViewData = true
                viewModel.count = 0
//                viewModel.Shuffle() //?
            }
        }
    }
    
    func checkIfFolderExists(value : String) -> Bool {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsDirectory.appendingPathComponent(value)
        
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: folderURL.path, isDirectory: &isDirectory)
        
        return exists && isDirectory.boolValue
    }
}


struct overviewActivityView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    
    @State var typeActivity: activityEnum = .character
    
    var body: some View {
        Section {
            Picker("activity".localized(), selection: $viewModel.indexActivity) {
                ForEach(activityEnum.allCases, id: \.self) { typ in
                    Text("\(typ.stringValue().localized())").tag(typ.rawValue)
                }
            }
            .onChange(of: viewModel.indexActivity) { tag in
                print("change in indexActivity  \(tag)")
                viewModel.typeActivity = activityEnum(rawValue: tag) ?? .character
                viewModel.updateViewData = true
            }
            
            if (viewModel.typeActivity == .word) {
                Toggle("chop".localized(), isOn: $viewModel.syllable)
            }
            
            if (viewModel.syllable) && (viewModel.typeActivity == .word) {
                Toggle("talkword".localized(), isOn: $viewModel.talkWord)
            }
            
            if (viewModel.syllable) && (viewModel.typeActivity == .word) {
                Picker("pause".localized(),selection: $viewModel.indexPauses) {
                    ForEach(0 ..< pauses.count, id: \.self) {
                        Text("\(pauses[$0]) sec").tag($0)
                    }
                }
            }
            
            
            if ((viewModel.syllable) && (viewModel.typeActivity == .word)) || (viewModel.typeActivity == .character){
                Picker("pronouncation".localized(), selection: $viewModel.indexPronounce) {
                    ForEach(pronounceEnum.allCases, id: \.self) { pronounce in
                        Text("\(pronounce.stringValue().localized())").tag(pronounce.rawValue)
                    }
                }
                .onChange(of: viewModel.indexPronounce) { tag in
                    print("change in indexPronounce  \(tag)")
                    if let pronounce = pronounceEnum(rawValue: tag) {
                        viewModel.typePronounce = pronounce
                    }
                }
            }
        }
    }
}

struct overviewGeneralView : View {
    @EnvironmentObject var viewModel: LouisViewModel
    
    var body: some View {
        Section{
            Picker("nroftrys".localized(), selection: $viewModel.indexTrys) {
                ForEach(0 ..< trys.count, id: \.self) {
                    Text("\(trys[$0])").tag($0)
                }
            }
            .onChange(of: viewModel.indexTrys) { tag in
                print("change in nrofWords \(trys[tag])")
                viewModel.count = 0
            }
            
            Toggle("conditional".localized(), isOn: $viewModel.conditional)
            
            Toggle("assist".localized(), isOn: $viewModel.assist)
            
            
//            Picker("reading".localized(), selection: $viewModel.typePositionReading) {
//                ForEach(positionReadingEnum.allCases, id: \.self) {
//                    Text($0.stringValue().localized()).tag($0)
//                }
//            }
//            .onChange(of: viewModel.typePositionReading) { tag in
//                print("change in indexPosition \(tag)")
//            }

            
            Picker("reading".localized(), selection: $viewModel.indexPosition) {
                ForEach(positionReadingEnum.allCases, id: \.self) { position in
                    Text("\(position.stringValue().localized())").tag(position.rawValue)
                }
            }
            .onChange(of: viewModel.indexPosition) { tag in
                print("change in indexPosition \(tag)")
                if let position = positionReadingEnum(rawValue: tag) {
                    viewModel.typePositionReading = position
                }
            }
        }
    }
}

struct resetModelView : View {
    @EnvironmentObject var viewModel: LouisViewModel
        
    var body: some View {
        Section{
            Button {
                reset()
            } label : {
                Text("reset".localized())
            }
            
        }
    }
    
    func reset() {
        viewModel.indexLanguage = 0
        viewModel.indexMethod = 0
        viewModel.indexLesson = 0
        
        if let activity = activityEnum(rawValue: viewModel.indexActivity) {
            viewModel.typeActivity = activity
        }
        
        viewModel.syllable = false
        
        if let pronouncation = pronounceEnum(rawValue: viewModel.indexPronounce) {
            viewModel.typePronounce = pronouncation
        }
        
        viewModel.indexTrys = 5 //13
        viewModel.indexPauses = 0
        viewModel.conditional = false
        viewModel.conditional = true
        viewModel.typePositionReading = positionReadingEnum(rawValue: viewModel.indexPosition) ?? .before
        viewModel.count = 0
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(LouisViewModel())
    }
}



