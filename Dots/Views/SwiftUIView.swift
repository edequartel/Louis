//
//  SwiftUIView.swift
//  Pods
//
//  Created by Eric de Quartel on 15/02/2023.
//

import SwiftUI

struct SwiftUIView: View {
        let targetWord = "SwiftUI"
        @State private var text = ""
        @State private var cursorPosition = 0
        @State private var wordUnderCursor = ""
        @FocusState private var isFocused: Bool

        var body: some View {
            Text("Test")
//            VStack {
//                TextField("Enter text here", text: $text)
//                    .focused($isFocused)
//                    .onChange(of: isFocused) { focused in
//                        if focused {
//                            // Get the cursor position and word under the cursor when the TextField gains focus
//                            let (newPosition, newWord) = getCursorPositionAndWord()
//                            cursorPosition = newPosition
//                            wordUnderCursor = newWord
//                        }
//                    }
//                    .onChange(of: text) { newText in
//                        // Get the cursor position and word under the cursor when the text changes
//                        let (newPosition, newWord) = getCursorPositionAndWord()
//                        cursorPosition = newPosition
//                        wordUnderCursor = newWord
//                    }
//                    .background(
//                        ZStack {
//                            if wordUnderCursor == targetWord {
//                                Color.green
//                            } else if !wordUnderCursor.isEmpty {
//                                Color.red
//                            }
//                        }
//                    )
//
//                HStack {
//                    Text("Cursor position:")
//                    TextField("", value: $cursorPosition, formatter: NumberFormatter())
//                        .keyboardType(.numberPad)
//                }
//                HStack {
//                    Text("Character under cursor:")
//                    TextField("", text: .constant(String(Array(text)[cursorPosition])))
//                        .disabled(true)
//                }
//                HStack {
//                    Text("Word under cursor:")
//                    TextField("", text: $wordUnderCursor)
//                        .disabled(true)
//                }
            }
        
//        func getCursorPositionAndWord() -> (Int, String) {
//            let startPosition = text.startIndex
//            let selectedRange = text.selectedTextRange
//            let cursorPosition = text.distance(from: startPosition, to: selectedRange?.start ?? startPosition)
//            let wordRange = text.rangeOfComposedCharacterSequence(at: text.index(startPosition, offsetBy: cursorPosition))
//            let word = String(text[wordRange])
//            return (cursorPosition, word)
//            return(2,"test")
//        }
    }


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
