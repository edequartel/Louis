//
//  SettingsView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI
import Subsonic

struct SettingsView: View {
    private var countries: [Country] = Country.allCountries
    
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    @AppStorage("INDEX_COUNTRY") var indexCountry = 0
    @AppStorage("NROFWORDS") var nrofWords = 3
    @AppStorage("TALKINGON") var talkingOn = false
    @AppStorage("BRAILLEON") var brailleOn = false
    @AppStorage("MODESTUDENT") var modeStudent = true

    
    @State private var lettersCnt=1
    @State private var wordCnt=3
    
    let words = [3, 4, 5, 6, 7]
    
    var body: some View {
        NavigationView {
            Form {
                List {
                    Picker("country".localized(), selection: $indexCountry) {
                        ForEach(countries, id: \.id) { country in
                            Text(country.language).tag(country.id)
                        }
                    }
                    .onChange(of: indexCountry) { tag in
                        print("Change in tag country: \(tag)")
                        indexLesson = 0
                        indexMethod = 0
                    }
                    
                    
                    Picker("method".localized(), selection: $indexMethod) {
                        ForEach(countries[indexCountry].method, id: \.id) { method in
                            Text(method.name).tag(method.id)
                        }
                    }
                    .onChange(of: indexMethod) { tag in
                        print("Change in tag method: \(tag)")
                        indexLesson = 0
                    }
                    
                    Picker("lesson".localized(), selection: $indexLesson) {
                        ForEach(countries[indexCountry].method[indexMethod].lesson, id: \.id) { lesson in
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
                        Picker("nrofWords".localized(), selection: $nrofWords) {
                            ForEach(words, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        
                        Toggle("talkingWord".localized(), isOn: $talkingOn)
                        Toggle("brailleText".localized(), isOn: $brailleOn)
                    }
                    
                    Section{
                        Button {
                            nrofWords = 3
                        } label : {
                            Text("reset".localized())
                        }
                        
                        Button {
                            print("update from Internet")
                        } label : {
                            Text("update".localized())
                        }
                        
                        
                        Button {
                            if let text = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                                print(text)
                            }
                        } label : {
                            Text("Version 8")
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




