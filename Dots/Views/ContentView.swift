//
//  ContentView.swift
//  Dots
//
//  Created by Eric de Quartel on 14/06/2022.
//

import SwiftUI



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
//            ProgressView()
//                .tabItem {
//                    Image(systemName: "asterisk")
//                    Text("Progress")
//                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()
        ContentView().environmentObject(settings)
    }
}
