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
                    .onChange(of: settings.selectedCountry) { _ in
                        UserDefaults.standard.set(settings.selectedCountry, forKey: "CountryIndex")
                        settings.selectedMethod = 0
                        UserDefaults.standard.set(settings.selectedMethod, forKey: "MethodIndex")
                        settings.selectedLesson = 0
                        UserDefaults.standard.set(settings.selectedLesson, forKey: "LessonIndex")
                    }
                    
                    
                    Picker("Methode \(settings.selectedMethod)", selection: $settings.selectedMethod) {
                        ForEach(countries[settings.selectedCountry].method, id: \.id) { method in
                            Text(method.name)
                        }
                    }
                    .onChange(of: settings.selectedMethod) { _ in
                        UserDefaults.standard.set(settings.selectedMethod, forKey: "MethodIndex")
                        settings.selectedLesson=0
                        UserDefaults.standard.set(settings.selectedLesson, forKey: "LessonIndex")
                    }
                    
                    Picker("Lesson \(settings.selectedLesson)", selection: $settings.selectedLesson) {
                        ForEach(countries[settings.selectedCountry].method[settings.selectedMethod].lesson, id: \.id) { lesson in
                            Text(lesson.name)
                                .foregroundColor(.gray)
                                .font(.custom(
                                    "bartimeus6dots",
                                    fixedSize: 32)) +
                            
                            Text(" "+lesson.name)
                        }
                    }
                    .onChange(of: settings.selectedLesson) { _ in
                        UserDefaults.standard.set(settings.selectedLesson, forKey: "LessonIndex")
                    }
                    
                  
                    
                    
                }
                Toggle(isOn: $isToggle){
                    Text("Auto increment")
                }
                
                Section(header: Text("Moeilijkheid")) {
                    Button("Letters \(lettersCnt)") {
                        lettersCnt += 1
                        if lettersCnt > 10 {
                            lettersCnt = 1
                        }
                    }
                    Button("Woorden \(wordCnt)") {
                        wordCnt += 1
                        if  wordCnt > 10 {
                            wordCnt = 1
                        }
                        
                    }
                }
                
                
                Section(header: Text("Oefening")) {
                    Button("Oefening \(actionIdx+1) \(action[actionIdx])") {
                        actionIdx += 1
                        if  actionIdx >= action.count {
                            actionIdx = 0
                        }
                    }
                    Button("counter \(settings.counter)") {                        
                        settings.counter += 1
                        UserDefaults.standard.set(settings.counter, forKey: "counter")
                    }
                    
                    Button("counter reset") {
                        settings.counter = 0
                        UserDefaults.standard.set(settings.counter, forKey: "counter")
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

//Text("Country")
//ForEach(countries, id: \.id) {
//    country in Text("\(country.language)")
//}
//Text("Methods")
//Spacer()
//ForEach(countries[selectedCountry].method, id: \.id) {
//    method in Text("\(method.name)")
//}
//Text("Lessons")
//Spacer()
//ForEach(countries[selectedCountry].method[0].lesson, id: \.id) {
//    lesson in Text("\(lesson.name)")
//}
