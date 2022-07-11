//
//  SettingsView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI
import Subsonic

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    private var countries: [Country] = Country.allCountries
    
    @State private var lettersCnt=1
    @State private var wordCnt=3
    
    let action = ["mengsel","luister-schrijf","lees-schrijf","lees-luister-schrijf"]
    @State private var actionIdx=0
    
    @State private var isToggle : Bool = false
    
    var body: some View {
        NavigationView {
            
            
            
            Form {
                List {
                    Picker("Country", selection: $settings.selectedCountry) {
                        ForEach(countries, id: \.id) { country in
                            Text(country.language)
                        }
                    }
                    
                    Picker("Method ", selection: $settings.selectedMethod) {
                        ForEach(countries[settings.selectedCountry].method, id: \.id) { method in
                            Text(method.name)
                        }
                    }
                    
                    Picker("Lesson ", selection: $settings.selectedLesson) {
                        ForEach(countries[settings.selectedCountry].method[settings.selectedMethod].lesson, id: \.id) { lesson in
                            Text(lesson.name)
                                .foregroundColor(.gray)
                                .font(.custom(
                                    "bartimeus6dots",
                                    fixedSize: 32)) +
                            
                            Text(" "+lesson.name)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: NavigationLink(destination: InformationView()) {Image(systemName: "info.circle")},
                                trailing: NavigationLink(destination: AudioView()) {Image(systemName: "play.square")}
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}


//                Toggle(isOn: $isToggle){
//                    Text("Auto increment")
//                }
//
//                Section(header: Text("Moeilijkheid")) {
//                    Button("Letters \(lettersCnt)") {
//                        lettersCnt += 1
//                        if lettersCnt > 10 {
//                            lettersCnt = 1
//                        }
//                    }
//                    Button("Woorden \(wordCnt)") {
//                        wordCnt += 1
//                        if  wordCnt > 10 {
//                            wordCnt = 1
//                        }
//
//                    }
//                }
//
//
//                Section(header: Text("Oefening")) {
//                    Button("Oefening \(actionIdx+1) \(action[actionIdx])") {
//                        actionIdx += 1
//                        if  actionIdx >= action.count {
//                            actionIdx = 0
//                        }
//                    }
//                }
//    .foregroundColor(.gray)

