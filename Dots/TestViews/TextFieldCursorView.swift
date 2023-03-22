//
//  TextFieldCursorView.swift
//  Dots
//
//  Created by Eric de Quartel on 11/03/2023.
//

import SwiftUI

struct TextFieldCursorView: View {
    @State private var text = ""
    @State private var cursorPosition: Int? = nil
    
    var body: some View {
        VStack {
            Text("Cursor Position: \(cursorPosition ?? 0)")
            Text("Text: \(text)")
            Text("")
            TextView(text: text, cursorPosition: cursorPosition)
            
            UITextViewWrapper(text: $text, cursorPosition: $cursorPosition)
                .border(Color.black)
                .padding(10)
            Spacer()
            //Text(substring(from: "this is a nice day", at: 11) ?? "")
//            Button("Now") {
//                let str = "It is a nice day wat denk je hiervan"
//                if let identifier = substringAtCursorPosition(in: str, cursorPosition: 11) {
//                    print(identifier) // Output: "nice"
//                }
//            }
        }
    }
}

struct TextView: View {
    var text: String
    var cursorPosition: Int?
    
    var body: some View {
        VStack {
            Text("Text at cursor: \(textAtIndex(index: cursorPosition))")
            Spacer()
        }
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
            Spacer()
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
    @Binding var cursorPosition: Int?
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        if let selectedRange = uiView.selectedTextRange {
            let cursorPosition = uiView.offset(from: uiView.beginningOfDocument, to: selectedRange.start)
            self.cursorPosition = cursorPosition
        } else {
            self.cursorPosition = nil
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
                parent.cursorPosition = cursorPosition
            } else {
                parent.cursorPosition = nil
            }
        }
    }
}


struct TextFieldCursorView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldCursorView()
    }
}
