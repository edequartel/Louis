//
//  TextFieldCursorView.swift
//  Dots
//
//  Created by Eric de Quartel on 11/03/2023.
//

import SwiftUI

struct TextFieldCursorView: View {
  @State private var text = "bal kam aap"
  @State private var cursorPosition: Int? = nil
  @State private var lastKey: String?

  let fontSize = CGFloat(16)

  var body: some View {
    VStack(alignment: .leading, spacing: 15) {

      // Cursor Position Display
      VStack(alignment: .leading, spacing: 5) {
        Text("Cursor Position: \(cursorPosition ?? 0)")
        Text("Last key typed: \(lastKey ?? "None")")
      }
      .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
      .padding(.horizontal)
      .accessibility(hidden: true)

      // Text Display Area
      VStack(alignment: .leading, spacing: 5) {
        Text(text)
          .font(.custom("Menlo", size: fontSize))
          .lineLimit(1)
          .padding(.vertical, 4)

        Text(text)
          .font(Font.custom("bartimeus8dots", size: fontSize))
          .lineLimit(1)
          .padding(.vertical, 4)
      }
      .padding()
      .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
      .background(Color(UIColor.systemGray6))
      .cornerRadius(8)
      .overlay(
        RoundedRectangle(cornerRadius: 8)
          .stroke(Color.red, lineWidth: 1)
      )
      .accessibility(hidden: true)

      // Custom TextView for Cursor Positioning
      TextView(text: text, cursorPosition: cursorPosition)
        .accessibility(hidden: true)

      // Editable TextView
      UITextViewWrapper(text: $text, cursorPos: $cursorPosition, lastKey: $lastKey)
        .font(.caption)
        .frame(height: 100)
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.blue, lineWidth: 1)
        )

      Spacer()
    }
    .padding()
  }
}

struct TextView: View {
    var text: String
    var cursorPosition: Int?
    let fontSize = CGFloat(16)
    
    var body: some View {
        VStack(alignment: .leading) {

          VStack {
            HStack {
              Text("\(textAtIndex(index: cursorPosition))")
                Spacer()
            }
            VStack(alignment: .leading) {
                Text("\(getWordFromIndex(from: text, position: cursorPosition ?? 0))")
                    .font(.custom("Menlo", size: fontSize))
                    .lineLimit(1)
                Text("\(getWordFromIndex(from: text, position: cursorPosition ?? 0))")
                    .font(Font.custom("bartimeus8dots", size: fontSize))
                    .lineLimit(1)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Ensures VStack aligns left
          }
          .padding()
          .frame(maxWidth: .infinity)
          .frame(height: 140)
          .background(Color.white)
          .cornerRadius(8)
          .overlay(
              RoundedRectangle(cornerRadius: 8)
                  .stroke(Color.blue, lineWidth: 1)
          )
        }
    }
    
    func getWordFromIndex(from inputString: String, position: Int) -> String {
        let unwantedChars: Set<Character> = [",", "!", "?"]
        
        func createIndexArray(from inputString: String) -> [Int] {
            var indexArray = [Int]()
            var currentIndex = 0
            
            for char in inputString {
                if char == " " {
                    indexArray.append(-1)
                    currentIndex += 1
                } else {
                    indexArray.append(currentIndex)
                }
            }
            return indexArray
        }
        
        let array = createIndexArray(from: inputString)
        let words = inputString.components(separatedBy: " ")
        
        var word = ""
        if position >= 0 && position < array.count {
            let index = array[position]
            if index >= 0 && index < words.count {
                word = words[index]
            }
        }
        
        return String(word.filter { !unwantedChars.contains($0) })
    }
    
    
    private func textAtIndex(index: Int?) -> String {
        guard let index = index, index >= 0, index < text.count else {
            return ""
        }
        let i = text.index(text.startIndex, offsetBy: index)
        return String(text[i])
    }
    
    
    
    
}

struct TextStringView: View {
    var text: String
    var cursorPosition: Int?
    
    var body: some View {
        VStack {
            Text("Text at cursor: \(stringUpToCursor)")
        }
    }
    
    private var stringUpToCursor: String {
        guard let cursorPosition = cursorPosition else {
            return ""
        }
        let endIndex = text.index(text.startIndex, offsetBy: cursorPosition)
        return String(text[..<endIndex])
    }
}


struct TextFieldCursorView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldCursorView()
    }
}
