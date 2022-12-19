//
//  DotsApp.swift
//  Dots
//
//  Created by Eric de Quartel on 14/06/2022.
//

import SwiftUI

@main
struct DotsApp: App {
    var network = Network()
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            SplashScreenView()
                .environmentObject(network)
        }
    }
}
