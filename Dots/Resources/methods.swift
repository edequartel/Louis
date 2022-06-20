// MODEL
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let countries = try? newJSONDecoder().decode(Countries.self, from: jsonData)

import Foundation

// MARK: - Countries
struct Countries: Codable {
    var country: [Country]
}

// MARK: - Country
struct Country: Codable {
    var id: Int
    var language, code, comments, information: String
    var method: [Method]
    var success, failure: [String]
}

// MARK: - Method
struct Method: Codable {
    var id: Int
    var name, developer, information, letters: String
    var comments: String
    var lesson: [Lesson]
}

// MARK: - Lesson
struct Lesson: Codable {
    var id: Int
    var name, letters, antiletters, words: String
    var antiwords: String
    var sentence: [String]
    var comments, information: String
    var voice, audio: [String]
}

//extension Bundle {
//    func decode<T : Decodable> (file: String)->T {
//        guard = let url
//    }
//}
