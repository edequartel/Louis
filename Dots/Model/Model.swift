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

    static let Language: [Language] = loadLanguages()
}

//Load languages from the local file (earlier downloaded at startup if there was network connection)
func loadLanguages() -> [Language] {
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = documentDirectory.appendingPathComponent("methods-demo.json")

    let data: Data
    do {
        data = try Data(contentsOf: fileURL)
    } catch {
        return []
    }

    let users: [Language]
    do {
        users = try JSONDecoder().decode([Language].self, from: data)
    } catch {
        return []
    }

    return users
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

