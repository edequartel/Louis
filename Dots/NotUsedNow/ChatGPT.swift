////
////  ChatGPT.swift
////  Dots
////
////  Created by Eric de Quartel on 07/11/2024.
////
//
//import SwiftUI
//import Alamofire
//import AVFoundation
//import Foundation
//import SwiftyBeaver
//
//let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] ?? ""
//
//// MARK: - OpenAI Response Model
//struct OpenAIResponse: Codable {
//  struct Choice: Codable {
//    struct Message: Codable {
//      let role: String
//      let content: String
//    }
//    let message: Message
//  }
//
//  let choices: [Choice]
//}
//
//import Foundation
//import Combine
//
//// MARK: - OpenAI ViewModel
//
//class OpenAIViewModel: ObservableObject {
//  @Published var responseText: String = ""
//  let log = SwiftyBeaver.self
//  private var cancellable: AnyCancellable?
//
//  let choiceVvoice = "com.apple.speech.synthesis.voice.GoodNews"
//
//  func fetchResponse(prompt: String, message: String, apiKey: String) {
//    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.setValue(apiKey, forHTTPHeaderField: "Authorization")
//
//    let parameters: [String: Any] = [
//      "model": "gpt-4o",
//      "messages": [
//        ["role": "user", "content":prompt+", "+message]
//      ]
//    ]
//
//    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
//
//    cancellable = URLSession.shared.dataTaskPublisher(for: request)
//      .tryMap { data, response in
//        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//          throw URLError(.badServerResponse)
//        }
//        return data
//      }
//      .decode(type: OpenAIResponse.self, decoder: JSONDecoder())
//      .receive(on: DispatchQueue.main)
//      .sink(receiveCompletion: { completion in
//        if case let .failure(error) = completion {
//          self.responseText = "Error: \(error.localizedDescription)"
//        }
//      }, receiveValue: { response in
//        self.responseText = response.choices.first?.message.content ?? "No response"
//      })
//  }
//}
//
//struct OpenAIView: View {
//  @StateObject private var viewModel = OpenAIViewModel()
//  @EnvironmentObject var viewSettingsModel: LouisViewModel
//
//  let log = SwiftyBeaver.self
//  let synthesizer = AVSpeechSynthesizer()
//
//  @State private var prompt: String = "You are a visionary."
//  @State private var message: String = "What will braille learning look like in five years with iPhone and AI integration? Describe how AI and mobile technology can improve braille education and accessibility for blind and visually impaired users. (Max 50 words)"//"wat eet een paard?"
//
//  var body: some View {
//    VStack {
//
//      Text("Tactile Reading 2025") //- OpenAI Response")
//        .font(.headline)
//
//      HStack {
//        TextEditor(text: $prompt)
//        //          .padding()
//          .frame(height: 60) // Adjust height as needed
//          .overlay(
//            RoundedRectangle(cornerRadius: 8)
//              .stroke(Color.gray, lineWidth: 1)
//          )
//        Spacer()
//        Button(action: {
//          speak(prompt)
//        }) {
//          Image(systemName: "play.fill")
//            .padding()
//        }
//      }
//      .font(.caption)
//
//      HStack {
//        TextEditor(text: $message)
//        //          .padding()
//          .frame(height: 120) // Adjust height as needed
//          .overlay(
//            RoundedRectangle(cornerRadius: 8)
//              .stroke(Color.gray, lineWidth: 1)
//          )
//
//        Spacer()
//        VStack {
//          Button(action: {
//            speak(message)
//          }) {
//            Image(systemName: "play.fill")
//              .padding()
//          }
//
//          Button(action: {
//            hideKeyboard() // Hide keyboard
//            viewModel.fetchResponse(
//              prompt: prompt,
//              message: message,
////              apiKey: apiKey)
//              apiKey: viewSettingsModel.apiKey)
//          }) {
//            Image(systemName: "questionmark")
//              .padding()
//              .foregroundColor(.red)
//          }
//        }
//      }
//      .font(.caption)
//
//      HStack {
//        ScrollView {
//          Text(viewModel.responseText)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(4)
//        }
//        .overlay(
//          RoundedRectangle(cornerRadius: 8)
//            .stroke(Color.gray, lineWidth: 1)
//        )
//        Spacer()
//        VStack {
//          Button(action: {
//            speak(viewModel.responseText)
//          }) {
//            Image(systemName: "play.fill")
//              .padding()
//          }
//          Button(action: {
//            synthesizer.stopSpeaking(at: .immediate)
//          }) {
//            Image(systemName: "stop.fill")
//              .padding()
//          }
//
//        }
//      }
//      .font(.caption)
//
//      Spacer()
//    }
//    .padding()
//  }
//
//  func hideKeyboard() {
//    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//  }
//
//
//  func speak(_ text: String) {
//    for voice in AVSpeechSynthesisVoice.speechVoices() {
//      if voice.language == "en-US" {
//        print("\(voice.name) — \(voice.language) — \(voice.identifier)")
//      }
//    }
//    print("speak")
//    if synthesizer.isSpeaking {
//      synthesizer.stopSpeaking(at: .immediate)
//    }
//
//    let utterance = AVSpeechUtterance(string: text)
//
//    // Example: Use the Samantha voice (U.S. English)
//    if let voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.compact.en-US.Samantha") {
//      utterance.voice = voice
//    } else {
//      utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//    }
//
//    synthesizer.speak(utterance)
//  }
//}
//
//struct OpenAIView_Previews: PreviewProvider {
//  static var previews: some View {
//    OpenAIView()
//  }
//}
