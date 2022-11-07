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
    
    @AppStorage("COUNT") var count = 0
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    @AppStorage("INDEX_ACTIVITY") var indexActivity = 1
    @AppStorage("INDEX_READING") var indexReading = 0
    @AppStorage("INDEX_WORDS") var indexWords = 3
    @AppStorage("INDEX_PRONOUNCE") var indexPronouce = 0
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
    let pronouce = ["phonetic","adult","form"]
    
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
                            changeIndex = true
                            count = 0
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
                            count = 0
                        }
                        
                        //                    Text(Languages[indexLanguage].method[indexMethod].information)
                        //                        .font(.footnote)
                        
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
                            count = 0
                        }
                        

                    
                    Section{
//                        Text("\(indexActivity)")
                        Picker("activity".localized(), selection: $indexActivity)
                        {
                            ForEach(0 ..< activities.count) {
                                Text("\(activities[$0])".localized()).tag($0)
                            }
                            
                        }
                        .onChange(of: indexActivity) { tag in
                            print("change in indexActivity  \(activities[tag]) tag \(tag)")
                            typeActivity = activities[tag]
                            changeIndex = true
                        }
                        
                        
                        Picker("nroftrys".localized(), selection: $indexWords) {
                            ForEach(0 ..< words.count) {
                                Text("\(words[$0])").tag($0)
                            }
                        }
                        .onChange(of: indexWords) { tag in
                            print("change in nrofWords \(words[tag])")
                            nrofWords = words[tag]
                            count = 0
                            changeIndex = true
                        }
                        
                        Picker("reading".localized(), selection: $indexReading) {
                            ForEach(0..<reading.count) {
                                Text("\(reading[$0])".localized()).tag($0)
                            }
                        }
                        .onChange(of: indexReading) { tag in
                            print("change in indexReading \(tag)")
                            readSound = reading[tag]
                            changeIndex = true
                        }
                        
//                        Picker("pronounce".localized(), selection: $indexPronouce) {
//                            ForEach(0..<pronouce.count) {
//                                Text("\(pronouce[$0])".localized()).tag($0)
//                            }
//                        }
//                        .onChange(of: indexReading) { tag in
//                            print("change in indexPronouce \(tag)")
////                            readPronounce = pronouce[tag]
////                            changeIndex = true
//                        }
//
                        
                        Toggle("conditional".localized(), isOn: $conditional)
                        Toggle("brailleText".localized(), isOn: $brailleOn)
                    }
                    
                    Section{
                        Button {
                            indexMethod = 0
                            indexLesson = 0
                            indexLanguage = 0
                            
                            indexActivity = 0
                            indexReading = 1
                            indexWords = 3
                            
                            brailleOn = true
                            conditional = false
                            
                            readSound = reading[indexReading]
                            typeActivity = activities[indexActivity]
                            nrofWords = words[indexWords]
                            
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




