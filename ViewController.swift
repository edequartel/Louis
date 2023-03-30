//
//  ViewController.swift
//  
//
//  Created by Eric de Quartel on 30/03/2023.
//

import Foundation
import UIKit

class ViewController: UIViewController, UITextViewDelegate {
    var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up text view
        textView = UITextView(frame: view.bounds)
        textView.delegate = self
        view.addSubview(textView)
    }
    
    // Detect changes in cursor position
    func textViewDidChangeSelection(_ textView: UITextView) {
        let cursorPosition = textView.selectedRange.location
        print("Cursor position: \(cursorPosition)")
    }
}
