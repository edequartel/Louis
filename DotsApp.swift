//
//  DotsApp.swift
//  Dots
//
//  Created by Eric de Quartel on 14/06/2022.
//

import SwiftUI

@main
struct DotsApp: App {
//    var network = Network()
    @StateObject var viewModel = PlaygroundViewModel()
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            SplashScreenView()
//                .environmentObject(network)
                .environmentObject(viewModel) //make the model available for the environment
        }
    }
}
