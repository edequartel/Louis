//
//  ContentView.swift
//  Dots
//
//  Created by Eric de Quartel on 14/06/2022.
//

import SwiftUI

class Settings: ObservableObject {
    @Published var counter: Int =  0
    @Published var selectedCountry: Int = 0
    @Published var selectedMethod: Int = 0
    
    @Published var selectedLesson: Int = 0
    
    private var countries: [Country] = Country.allCountries
    
    var country: Country {
        get {
            countries[selectedCountry]
        }
    }
    var method: Method {
        get {
            if (selectedMethod>=countries[selectedCountry].method.count) {selectedMethod=0}
            return countries[selectedCountry].method[selectedMethod]
        }
    }
    var lesson: Lesson {
        get {
            if (selectedLesson>=countries[selectedCountry].method[selectedMethod].lesson.count) {selectedLesson=0}
            return countries[selectedCountry].method[selectedMethod].lesson[selectedLesson]
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var settings: Settings
           
    var body: some View {
        TabView {
            PlaygroundView()
                .tabItem {
                    Image(systemName: "hand.point.up.braille.fill")
                    Text("Play")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
