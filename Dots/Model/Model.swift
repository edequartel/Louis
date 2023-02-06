// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let item = try? JSONDecoder().decode(Item.self, from: jsonData)

import Foundation

// MARK: - ItemElement
struct Item: Identifiable, Codable {
    let id: Int
    let name, code, zip, comments, information: String
    let method: [Method]
}

// MARK: - Method
struct Method: Identifiable, Codable {
    let id: Int
    let name, developer, information, letters: String
    let comments: String
    let lesson: [Lesson]
}

// MARK: - Lesson
struct Lesson: Identifiable, Codable {
    let id: Int
    let name, letters, antiletters, words: String
    let allwords: String
    let sentence: [String]
    let comments: String
    let information: Information
    let voice, audio: [Audio]
}

enum Audio: String, Codable {
    case balMp3 = "bal.mp3"
    case blaMp3 = "bla.mp3"
}

enum Information: String, Codable {
    case empty = ".."
    case information = "…"
    case metPuntOpPadBlz10 = "met punt op pad blz. 10"
}

//typealias Item = [ItemElement]
