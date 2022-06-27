//
//  PlaygroundView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI

struct PlaygroundView: View {
    @EnvironmentObject var settings: Settings
    
    private var countries: [Country] = Country.allCountries
    
    @State var text1 = ""
    @State var isEditing1 = true
    @State var text2 = ""
    @State var isEditing2 = false
    
    @State var x=0
    @State var y=0
    
    @State var tekst: String = ""
    
    var body: some View {
        
        NavigationView{
            Form {
                Section {
                    Text("ababbabbba")
                }
                Section {
                    TextField("Placeholder", text: .constant("This is text data"))
                    Button("counter \(settings.counter)") {
                        settings.counter += 1
                        UserDefaults.standard.set(settings.counter, forKey: "counter")
                    }
                    
                    let str = countries[settings.selectedCountry].method[settings.selectedMethod].lesson[settings.selectedLesson].words
                    let items = str.components(separatedBy: " ")
                    List {
                        ForEach(items, id: \.self) { item in
                            Text(item)
                        }

                    }
                    
                }
            }
            .navigationTitle("Speelveld")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    
    
}

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundView()
    }
}


