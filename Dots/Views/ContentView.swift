//
//  ContentView.swift
//  Dots
//
//  Created by Eric de Quartel on 14/06/2022.
//

import SwiftUI

struct ContentView: View {
//    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: LouisViewModel
    
    @State private var selectedTab = 0
   
    let minDragTranslationForSwipe: CGFloat = 50
    let numTabs = 3
           
    var body: some View {
            TabView(selection: $selectedTab) {
                PlaygroundView()
                    .tabItem {
                        Image(systemName: "hand.point.up.braille.fill")
                        Text("play".localized())
                    }.tag(0)
                    .highPriorityGesture(DragGesture().onEnded({ self.handleSwipe(translation: $0.translation.width)}))
                SettingsView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("settings".localized())
                    }.tag(1)
                    .highPriorityGesture(DragGesture().onEnded({ self.handleSwipe(translation: $0.translation.width)}))
                InformationView()
                    .tabItem {
                        Image(systemName: "info.circle.fill")
                        Text("information".localized())
                    }.tag(2)
                    .highPriorityGesture(DragGesture().onEnded({ self.handleSwipe(translation: $0.translation.width)}))
            }
//            .foregroundColor(
//                colorScheme == .dark ? .yellow : .bart_green 
//                    )
    }
    
    private func handleSwipe(translation: CGFloat) {
        print("swiping\(selectedTab)")
        if translation > minDragTranslationForSwipe && selectedTab > 0 {
            selectedTab -= 1
        } else  if translation < -minDragTranslationForSwipe && selectedTab < numTabs-1 {
            selectedTab += 1
        }
    }
}

extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(LouisViewModel())
    }
}
