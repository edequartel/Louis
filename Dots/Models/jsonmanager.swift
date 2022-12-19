//
//  JSONManager.swift
//  JSONTest
//
//  Created by Federico on 08/02/2022.
//
//  Use a model generator like: https://app.quicktype.io/

import Foundation


struct Language: Codable, Identifiable {
    let id: Int
    let name, code, comments, information: String
    let method: [Method]

    static let Language: [Language] = Bundle.main.decode(file: "methods-demo.json")
}

// MARK: - Method
struct Method: Codable, Identifiable {
    let id: Int
    let name, developer, information, letters: String
    let comments: String
    let lesson: [Lesson]
}

// MARK: - Lesson
struct Lesson: Codable, Identifiable {
    let id: Int
    let name, letters, antiletters, words: String
    let allwords: String
    let sentence: [String]
    let comments, information: String
    let voice, audio: [String]
}

//
//www.eduvip.nl/braillestudio-software/methodslouis.json has to be loaded asynchronous
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
