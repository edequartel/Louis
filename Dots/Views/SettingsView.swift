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
    
    let words = [3, 4, 5, 6, 7]
    
    var body: some View {
        NavigationView {
            Form {
                List {
                    Picker("country".localized(), selection: $settings.selectedCountry) {
                        ForEach(countries, id: \.id) { country in
                            Text(country.language)
                        }
                    }
                    
                    Picker("method".localized(), selection:
                            $settings.selectedMethod) {
                        ForEach(countries[settings.selectedCountry].method, id: \.id) { method in
                            Text(method.name)
                        }
                    }
                    
                    Picker("lesson".localized(), selection: $settings.selectedLesson) {
                        ForEach(countries[settings.selectedCountry].method[settings.selectedMethod].lesson, id: \.id) { lesson in
                            Text(lesson.name)
                                .foregroundColor(.gray)
                                .font(.custom(
                                    "bartimeus6dots",
                                    fixedSize: 32))
                        }
                    }
                    
                    Section{
                        Picker("nrofWords".localized(), selection: $settings.nrofWords) {
                            ForEach(words, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        
                        Toggle("talkingWord".localized(), isOn: $settings.talkingOn)
                        Toggle("brailleText".localized(), isOn: $settings.brailleOn)
                        //                        Toggle("Simple words", isOn: $settings.simpleWordsOn)
                        
                        
                        
                        
                        //                        Text("Timer: 3 Sec")
                        //                        Text("Number of letters: 5")
                        //                        Text("Number of words: 3")
                    }
                    
                    Section{
                        Button {
                            settings.nrofWords = 3
                        } label : {
                            Text("reset".localized())
                        }
                        
                        Button {
                            Text("Update methods from internet...")
                        } label : {
                            Text("update".localized())
                        }
                        
                    }
                }
            }
            .navigationTitle("settings".localized())
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: NavigationLink(destination: InformationView()) {Image(systemName: "info.circle")}
                                //                                ,
                                //                                trailing: NavigationLink(destination: AudioView()) {Image(systemName: "music.quarternote.3")
                                //
                                //            }
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()
        SettingsView().environmentObject(settings)
    }
}




