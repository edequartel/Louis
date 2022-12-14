//
//  JSONManager.swift
//  JSONTest
//
//  Created by Federico on 08/02/2022.
//
//  Use a model generator like: https://app.quicktype.io/

import Foundation

// Generate samples www.eduvip.nl/braillestudio-software/methodslouis.json
//override func viewDidLoad() {
//    super.viewDidLoad()
//
//    // let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
//    let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
//
//    if let url = URL(string: urlString) {
//        if let data = try? Data(contentsOf: url) {
//            // we're OK to parse!
//        }
//    }
//}

struct Language: Codable {
    let id: Int
    let name, code, comments, information: String
    let method: [Method]
//    let success, failure: [String]
    

//    static let Language: [Language] = Bundle.main.decode(file: "methods-syllable.json")
    static let Language: [Language] = Bundle.main.decode(file: "methods-demo.json")
    
//    static let Language: [Language] = Bundle.main.decode(file:
//    static let Language: [Language] = Bundle.main.decode(file: "methods.json")
//    static let sampleLanguage: Language = Language[0]
}

// MARK: - Method
struct Method: Codable {
    let id: Int
    let name, developer, information, letters: String
    let comments: String
    let lesson: [Lesson]
}

// MARK: - Lesson
struct Lesson: Codable {
    let id: Int
    let name, letters, antiletters, words: String
    let allwords: String
    let sentence: [String]
    let comments, information: String
    let voice, audio: [String]
}

//

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
