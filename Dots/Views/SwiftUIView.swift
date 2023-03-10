//
//  SwiftUIView.swift
//  Pods
//
//  Created by Eric de Quartel on 15/02/2023.
//

import SwiftUI

struct SwiftUIView: View {
    let filterCharacters = "rosbm"
    
    var body: some View {
        let fileManager = FileManager.default

        guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Could not get documents directory path")
        }

        let audioPath = documentsPath.appendingPathComponent("dutch/words")

        do {
            let directoryContents = try fileManager.contentsOfDirectory(atPath: audioPath.path)

            // Extract file names without extension and filter based on criteria
            let filteredNames = directoryContents.map { (fileName: String) -> String in
                let parts = fileName.split(separator: ".")
                let nameWithoutExtension = parts.first ?? ""
                return String(nameWithoutExtension)
            }.filter { (name: String) -> Bool in
                let nameSet = Set(name)
                let filterSet = Set(filterCharacters)

                return nameSet.isSubset(of: filterSet) && filterSet.isSuperset(of: nameSet)
            }

            // Use filtered names to populate a list view
            return List(filteredNames, id: \.self) { name in
                Text(name)
                    .font(.footnote)
            }

        } catch {
            fatalError("Could not get contents of \(audioPath.path) folder: \(error.localizedDescription)")
        }
    }
}


//struct SwiftUIView: View {
//    let words = ["apple", "banana", "cherry", "date", "elderberry","bal","ba","la"]
//       let filterCharacters = "al"
//
//       var body: some View {
//           let filteredWords = words.filter { word in
//               let wordCharacters = Set(word)
//               let filterCharactersSet = Set(filterCharacters)
//
//               // Check that all characters in the word are also in the filter set,
//               // and that the filter set contains all characters in the word
//               return wordCharacters.isSubset(of: filterCharactersSet) &&
//                   filterCharactersSet.isSuperset(of: wordCharacters)
//           }
//
//           return List(filteredWords, id: \.self) { word in
//               Text(word)
//           }
//       }
//}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}


