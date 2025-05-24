//
//  Untitled.swift
//  Dots
//
//  Created by Eric de Quartel on 13/03/2025.
//
import SwiftUI

struct UITextViewWrapper: UIViewRepresentable {
  @Binding var text: String
  @Binding var cursorPos: Int?
  @Binding var lastKey: String? // Store last typed key

  var font: SwiftUI.Font? = nil // Accept SwiftUI.Font

  func makeUIView(context: Context) -> UITextView {
    let textView = UITextView()
    textView.delegate = context.coordinator
    textView.font = convertFont(font) // Apply font
    return textView
  }

  func updateUIView(_ uiView: UITextView, context: Context) {
    uiView.text = text
    uiView.font = convertFont(font) // Ensure font updates

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

  private func convertFont(_ font: SwiftUI.Font?) -> UIFont {
    if let font = font {
      return UIFont.preferredFont(from: font) ?? UIFont.systemFont(ofSize: 16)
    }
    return UIFont.systemFont(ofSize: 16)
  }

  class Coordinator: NSObject, UITextViewDelegate {
    var parent: UITextViewWrapper
    private var lastText: String = ""

    init(_ parent: UITextViewWrapper) {
      self.parent = parent
    }

    func textViewDidChange(_ textView: UITextView) {
      parent.text = textView.text
      lastText = textView.text
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
      if let selectedRange = textView.selectedTextRange {
        let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
        parent.cursorPos = cursorPosition
      } else {
        parent.cursorPos = nil
      }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      // Capture the typed key
      parent.lastKey = text

      // Print Unicode scalar values
      let unicodeValues = text.unicodeScalars.map { String(format: "U+%04X", $0.value) }.joined(separator: " ")
      print("Unicode: \(unicodeValues)")

      return true
    }
  }
}

extension UIFont {
  static func preferredFont(from font: SwiftUI.Font) -> UIFont? {
    switch font {
    case .largeTitle: return UIFont.preferredFont(forTextStyle: .largeTitle)
    case .title: return UIFont.preferredFont(forTextStyle: .title1)
    case .title2: return UIFont.preferredFont(forTextStyle: .title2)
    case .title3: return UIFont.preferredFont(forTextStyle: .title3)
    case .headline: return UIFont.preferredFont(forTextStyle: .headline)
    case .subheadline: return UIFont.preferredFont(forTextStyle: .subheadline)
    case .body: return UIFont.preferredFont(forTextStyle: .body)
    case .callout: return UIFont.preferredFont(forTextStyle: .callout)
    case .footnote: return UIFont.preferredFont(forTextStyle: .footnote)
    case .caption: return UIFont.preferredFont(forTextStyle: .caption1)
    case .caption2: return UIFont.preferredFont(forTextStyle: .caption2)
    default: return nil
    }
  }
}

