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
    @AppStorage("INDEX_LANGUAGEY") var indexLanguage = 0
    @AppStorage("NROFWORDS") var nrofWords = 3
    @AppStorage("TALKINGON") var talkingOn = false
    @AppStorage("BRAILLEON") var brailleOn = false
    @AppStorage("MODESTUDENT") var modeStudent = true
    @AppStorage("TYPEACTIVITY") var typeActivity = "word"
    
    //    let url = URL(string: "https://www.apple.com")!
    //    let task = URLSession.shared.downloadTask(with: url) { localURL, urlResponse, error in
    //            if let localURL = localURL {
    //                    if let string = try? String(contentsOf: localURL) {
    //                            print(string)
    //                    }
    //            }
    //    }
    
    
    @State private var lettersCnt = 1
    //    @State private var wordCnt = 3
    
    let words = [3, 4, 5, 6, 7]
    let activities = ["character","word","sentence","all"]
    
    
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
                    }
                    
                    Section{
                        Picker("activity".localized(), selection: $typeActivity) {
                            ForEach(activities, id:\.self) { activity in
                                Text("\(activity.localized())")
                            }
                        }
                        
                        Picker("nrofWords".localized(), selection: $nrofWords) {
                            ForEach(words, id: \.self) {
                                Text("\($0)")
                            }
                        }
                    }
                    
                    Section {
                        Toggle("talkingWord".localized(), isOn: $talkingOn)
                        Toggle("brailleText".localized(), isOn: $brailleOn)
                    }
                    
                    Section{
                        Button {
                            nrofWords = 3
                            indexMethod = 0
                            indexLesson = 0
                            indexLanguage = 0
                            typeActivity = "word"
                            talkingOn = false
                            brailleOn = true
                        } label : {
                            Text("reset".localized())
                        }
                        
                        Button {
                            print("update from Internet")
                        } label : {
                            Text("update".localized())
                        }
                        
                        
                    }
                }
            }
            .navigationTitle("settings".localized())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: NavigationLink(destination: InformationView()) {Image(systemName: "info.circle")}
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}




