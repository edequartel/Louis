//
//  ContentView.swift
//  Dots
//
//  Created by Eric de Quartel on 14/06/2022.
//

import SwiftUI
import SwiftSpeech

struct ContentView: View {
//    @Environment(\.colorScheme) var colorScheme
  @EnvironmentObject var viewModel: LouisViewModel

  var body: some View {
    TabView() {

      PlaygroundView()
        .tabItem {
          Image(systemName: "hand.point.up.braille.fill")
          Text("play".localized())
        }

      SettingsView()
        .tabItem {
          Image(systemName: "gearshape.fill")
          Text("settings".localized())
        }

      if viewModel.aiActive {
        OpenAIView()
          .tabItem {
            Image(systemName: "atom")
            Text("AI")
          }
      }

      InformationView()
        .tabItem {
          Image(systemName: "info.circle.fill")
          Text("information".localized())
        }


//      TextFieldCursorView()
//        .tabItem {
//          Image(systemName: "person.fill.questionmark")
//          Text("BrailleDisplay")
//        }
//

    }
    //            .onAppear {
    //                SwiftSpeech.requestSpeechRecognitionAuthorization()
    //            }
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
    }
}
