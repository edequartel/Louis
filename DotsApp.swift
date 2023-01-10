//
//  DotsApp.swift
//  Dots
//
//  Created by Eric de Quartel on 14/06/2022.
//

import SwiftUI

@main
struct DotsApp: App {
    @StateObject var viewModel = PlaygroundViewModel()
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(viewModel) //make the model available for the environment aka all other views
        }
    }
}
