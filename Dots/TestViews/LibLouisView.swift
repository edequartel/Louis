//
//  libLouisView.swift
//  
//
//  Created by Eric de Quartel on 11/03/2023.
//

import SwiftUI


func splitWithPriority(string: String, separatorStrings: [String]) -> [String] {
    var substrings = [string]
    for separator in separatorStrings.sorted(by: { $0.count > $1.count }) {
        substrings = substrings.flatMap { $0.components(separatedBy: separator) }
    }
    return substrings
}

struct LibLouisView: View {
    @State private var word = ""
    @State private var substrings = [String]()
    
    let separatorStrings = ["aa", "a", "e", "eu", "oo", "o", "ee"]
    
    var body: some View {
        VStack {
            TextField("Enter a word", text: $word)
                .autocapitalization(.none)
                .padding()
            
            Button("Split") {
                substrings = splitWithPriority(string: word, separatorStrings: separatorStrings)
            }
            .padding()
            
            if !substrings.isEmpty {
                ForEach(substrings, id: \.self) { substring in
                    Text(substring)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                }
            }
        }
    }
}

struct LibLouisView_Previews: PreviewProvider {
    static var previews: some View {
        LibLouisView()
    }
}
