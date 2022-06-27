//
//  ContentView.swift
//  Dots
//
//  Created by Eric de Quartel on 14/06/2022.
//

import SwiftUI

class Settings: ObservableObject {
    @Published var counter: Int =  UserDefaults.standard.integer(forKey: "counter")
    @Published var selectedCountry: Int = UserDefaults.standard.integer(forKey: "CountryIndex")
    @Published var selectedMethod: Int = UserDefaults.standard.integer(forKey: "MethodIndex")
    @Published var selectedLesson: Int = UserDefaults.standard.integer(forKey: "LessonIndex")
}

struct ContentView: View {
    @EnvironmentObject var settings: Settings

    private var countries: [Country] = Country.allCountries
    
    var body: some View {
                TabView {
                    SettingsView()
                        .tabItem {
                            Image(systemName: "person")
                            Text("Instellingen")
                        }
                    InformationView()
                        .tabItem {
                            Image(systemName: "text.bubble")
                            Text("Informatie")
                        }
                    PlaygroundView()
                        .tabItem {
                            Image(systemName: "circle.square")
                            Text("Speelveld")
                        }
                    SearchWordView()
                        .tabItem {
                            Image(systemName: "circle.square")
                            Text("Search Word")
                        }
                    AudioView()
                        .tabItem {
                            Image(systemName: "play")
                            Text("Audio")
                        }
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
