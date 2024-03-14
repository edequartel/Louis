//
//  TextFieldCursorView.swift
//  Dots
//
//  Created by Eric de Quartel on 11/03/2023.
//

import SwiftUI

struct TextFieldCursorView: View {
    @State private var text = "bal kam aap bal kam aap"
    @State private var cursorPosition: Int? = nil
    
    let fontSize = CGFloat(16)
    
    var body: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                Text("Cursor Position: \(cursorPosition ?? 0)")
                Text("\(text)")
                    .font(.custom("Menlo", size: fontSize))
                    .lineLimit(1)
                Text(text)
                    .font(Font.custom("bartimeus8dots", size: fontSize))
                    .lineLimit(1)
            
            
            Text("")
//
            TextView(text: text, cursorPosition: cursorPosition)
                
            }
            .padding()
            .border(Color.red)
            
            UITextViewWrapper(text: $text, cursorPos: $cursorPosition)
                .border(Color.blue)
                .padding(10)
                .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
            
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
            Text("Char at cursor: \(textAtIndex(index: cursorPosition))")
            Text("\(getWordFromIndex(from: text, position: cursorPosition ?? 0))")
                .font(.custom("Menlo", size: fontSize))
                .lineLimit(1)
            Text("\(getWordFromIndex(from: text, position: cursorPosition ?? 0))")
                .font(Font.custom("bartimeus8dots", size: fontSize))
                .lineLimit(1)
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

struct UITextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    @Binding var cursorPos: Int?
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        if let selectedRange = uiView.selectedTextRange {
            let cursorPosition = uiView.offset(from: uiView.beginningOfDocument, to: selectedRange.start)
            self.cursorPos = cursorPosition
        } else {
            self.cursorPos = nil
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: UITextViewWrapper
        
        init(_ parent: UITextViewWrapper) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            if let selectedRange = textView.selectedTextRange {
                let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
                parent.cursorPos = cursorPosition
            } else {
                parent.cursorPos = nil
            }
        }
    }
}


struct TextFieldCursorView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldCursorView()
    }
}
