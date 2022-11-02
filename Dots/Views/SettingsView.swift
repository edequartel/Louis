//
//  SettingsView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI
import Subsonic

struct SettingsView: View {
    private var Languages: [Language] = Language.Language
    
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    //    @AppStorage("INDEX_ACTIVITY") var indexActivity = 1
    @AppStorage("INDEX_LANGUAGEY") var indexLanguage = 0
    @AppStorage("NROFWORDS") var nrofWords = 3
    @AppStorage("CONDITIONAL") var conditional = true
    @AppStorage("BRAILLEON") var brailleOn = false
    @AppStorage("MODESTUDENT") var modeStudent = true
    @AppStorage("TYPEACTIVITY") var typeActivity = "word"
    @AppStorage("CHANGEINDEX") var changeIndex = false
    @AppStorage("READING") var readSound = "not"
    @AppStorage("MAXLENGTH") var maxLength = 3
    
    let words = [1, 2, 3, 5, 8, 13, 21]
    let activities = ["character","word"]//,"sentence","all"]
    let reading = ["not","before","after"]
    
    
    var body: some View {
        NavigationView {
            Form {
                List {
                    Picker("Language".localized(), selection: $indexLanguage) {
                        ForEach(Languages, id: \.id) { country in
                            Text(country.name).tag(country.id)
                        }
                    }
                    .onChange(of: indexLanguage) { tag in
                        print("Change in tag country: \(tag)")
                        indexLesson = 0
                        indexMethod = 0
                    }
                    
                    
                    Picker("method".localized(), selection: $indexMethod) {
                        ForEach(Languages[indexLanguage].method, id: \.id) { method in
                            Text(method.name).tag(method.id)
                        }
                    }
                    .onChange(of: indexMethod) { tag in
                        print("Change in tag method: \(tag)")
                        indexLesson = 0
                        changeIndex = true
                    }
                    
                    Picker("lesson".localized(), selection: $indexLesson) {
                        ForEach(Languages[indexLanguage].method[indexMethod].lesson, id: \.id) { lesson in
                            Text(lesson.name).tag(lesson.id)
                                .foregroundColor(.gray)
                                .font(.custom(
                                    "bartimeus6dots",
                                    fixedSize: 32))
                        }
                    }
                    .onChange(of: indexLesson) { tag in
                        print("Change in tag lesson: \(tag)")
                        changeIndex = true
                    }
                    
                    
                    Section{
                        Picker("activity".localized(), selection: $typeActivity) {
                            ForEach(activities, id:\.self) { activity in
                                Text("\(activity.localized())")
                            }
                        }
                        //onchange
                        
                        Picker("nroftrys".localized(), selection: $nrofWords) {
                            ForEach(words, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        //onchange
                        
                        Picker("reading".localized(), selection: $readSound) {
                            ForEach(reading, id: \.self) {
                                Text("\($0)".localized())
                            }
                            
                        }
                        
                        Toggle("conditional".localized(), isOn: $conditional)
                        Toggle("brailleText".localized(), isOn: $brailleOn)
                    }
                    
                    Section{
                        Button {
                            nrofWords = 3
                            indexMethod = 0
                            indexLesson = 0
                            indexLanguage = 0
                            typeActivity = "word"
                            brailleOn = true
                            readSound = "before"
                            conditional = false
                        } label : {
                            Text("reset".localized())
                        }
                        
                    }
                }
            }
            .navigationTitle("settings".localized())
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}




