//
//  ContentView.swift
//  Dots
//
//  Created by Eric de Quartel on 14/06/2022.
//

import SwiftUI

struct ContentView: View {
    private var countries: [Country] = Country.allCountries
    
    
    
    var body: some View {
        NavigationView {
            List {
                Text("Country")
                ForEach(countries, id: \.id) {
                    country in Text("\(country.language)")
                }
                Text("Methods")
                Spacer()
                ForEach(countries[0].method, id: \.id) {
                    method in Text("\(method.name)")
                }
                Text("Lessons")
                Spacer()
                ForEach(countries[0].method[0].lesson, id: \.id) {
                    lesson in Text("\(lesson.name)")
                }
                
            }
        }
        //        TabView {
        //            SettingsView()
        //                .tabItem {
        //                    Image(systemName: "person")
        //                    Text("Instellingen")
        //                }
        //            InformationView()
        //                .tabItem {
        //                    Image(systemName: "text.bubble")
        //                    Text("Informatie")
        //                }
        //            PlaygroundView()
        //                .tabItem {
        //                    Image(systemName: "circle.square")
        //                    Text("Speelveld")
        //                }
        //            SearchWordView()
        //                .tabItem {
        //                    Image(systemName: "circle.square")
        //                    Text("Search Word")
        //                }
        //            AudioView()
        //                .tabItem {
        //                    Image(systemName: "play")
        //                    Text("Audio")
        //                }
        //        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
