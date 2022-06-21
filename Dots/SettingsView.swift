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
    
    @State var selectedCountry: Int = UserDefaults.standard.integer(forKey: "CountryIndex")
    @State var selectedMethod: Int = UserDefaults.standard.integer(forKey: "MethodIndex")
    @State var selectedLesson: Int = UserDefaults.standard.integer(forKey: "LessonIndex")
    
    @State private var lettersCnt=1
    @State private var wordCnt=3
    
    let action = ["mengsel","luister-schrijf","lees-schrijf","lees-luister-schrijf"]
    @State private var actionIdx=0
    
    @State private var isToggle : Bool = false
    
    
    var body: some View {
        NavigationView {
            
            Form {
                List {
                    Picker("Country", selection: $selectedCountry) {
                        ForEach(countries, id: \.id) { country in
                            Text(country.language)
                        }
                    }
                    .onChange(of: selectedCountry) { _ in
                        UserDefaults.standard.set(self.selectedCountry, forKey: "CountryIndex")
                        selectedMethod = 0
                        UserDefaults.standard.set(self.selectedMethod, forKey: "MethodIndex")
                        selectedLesson = 0
                        UserDefaults.standard.set(self.selectedLesson, forKey: "LessonIndex")
                    }
                    
                    
                    Picker("Methode \(selectedMethod)", selection: $selectedMethod) {
                        ForEach(countries[selectedCountry].method, id: \.id) { method in
                            Text(method.name)
                        }
                    }
                    .onChange(of: selectedMethod) { _ in
                        UserDefaults.standard.set(self.selectedMethod, forKey: "MethodIndex")
                        selectedLesson=0
                        UserDefaults.standard.set(self.selectedLesson, forKey: "LessonIndex")
                    }
                    
                    Picker("Lesson \(selectedLesson)", selection: $selectedLesson) {
                        ForEach(countries[selectedCountry].method[selectedMethod].lesson, id: \.id) { lesson in
                            Text(lesson.name)
                                .foregroundColor(.gray)
                                .font(.custom(
                                    "bartimeus6dots",
                                    fixedSize: 32)) +
                            //                                .font(.largeTitle) +
                            
                            Text(" "+lesson.name)
                            
                        }
                    }
                    .onChange(of: selectedLesson) { _ in
                        UserDefaults.standard.set(self.selectedLesson, forKey: "LessonIndex")
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
