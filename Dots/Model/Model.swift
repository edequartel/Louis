//
//  methods.swift
//
//  Use a model generator like: https://app.quicktype.io/

import Foundation
import SwiftUI

struct Language: Decodable, Identifiable {
    let id: Int
    let name, code, comments, information: String
    let method: [Method]

    static let Language: [Language] = Bundle.main.decode(file: "methods-demo.json")
}

// MARK: - Method
struct Method: Decodable, Identifiable {
    let id: Int
    let name, developer, information, letters: String
    let comments: String
    let lesson: [Lesson]
}

// MARK: - Lesson
struct Lesson: Decodable, Identifiable {
    let id: Int
    let name, letters, antiletters, words: String
    let allwords: String
    let sentence: [String]
    let comments, information: String
    let voice, audio: [String]
}

// Extension to decode JSON locally
extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) from bundle.")
        }

        return loadedData
    }
}


//class Network: ObservableObject {
//    @EnvironmentObject var network: Network
//    @Published var Languages: [Language] = []
//
//    func getData() {
//        guard let url = URL(string: "https://www.eduvip.nl/braillestudio-software/methodslouis_edit.json") else { fatalError("Missing URL") }
//
//        let urlRequest = URLRequest(url: url)
//
//        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//            if let error = error {
//                print("Request error: ", error)
//                return
//            }
//
//            guard let response = response as? HTTPURLResponse else { return }
//
//            if response.statusCode == 200 {
//                guard let data = data else { return }
//                DispatchQueue.main.async {
//                    do {
//                        let decodedLanguages = try JSONDecoder().decode([Language].self, from: data)
//                        self.Languages = decodedLanguages
//                    } catch let error {
//                        print("Error decoding: ", error)
//                    }
//                }
//            }
//        }
//        dataTask.resume()
//    }
//}
