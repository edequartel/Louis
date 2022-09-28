//
//  Settings.swift
//  Dots
//
//  Created by Eric de Quartel on 19/09/2022.
//

import Foundation

class Settings: ObservableObject {
    @Published var nrofWords: Int =  5
    @Published var idPlay = ""
    @Published var selectedCountry: Int = 0
    @Published var selectedMethod: Int = 0
    @Published var selectedLesson: Int = 0
    @Published var talkingOn : Bool = false
    @Published var brailleOn : Bool = false
    
    
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
