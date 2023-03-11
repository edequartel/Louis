//
//  libLouisView.swift
//  
//
//  Created by Eric de Quartel on 11/03/2023.
//

import SwiftUI

struct LibLouisView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LibLouisView_Previews: PreviewProvider {
    static var previews: some View {
        LibLouisView()
    }
}

//import SwiftUI
//import LibLouis
//
//struct LibLouisView: View {
//    @State private var inputText = ""
//    
//    var body: some View {
//        VStack {
//            TextField("Enter a character", text: $inputText)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            if let brailleChar = convertToBraille(inputText) {
//                Text("Braille equivalent: \(brailleChar)")
//            } else {
//                Text("Invalid input")
//            }
//            
//            Spacer()
//        }
//    }
//    
//    func convertToBraille(_ input: String) -> String? {
//        let inputCString = (input as NSString).utf8String
//        let outputCString = lou_translateString(nil, inputCString, "unicode.braille", 0)
//        if let outputCString = outputCString {
//            let brailleChar = String(cString: outputCString)
//            return brailleChar
//        } else {
//            return nil
//        }
//    }
//}
//
//struct LibLouisView_Previews: PreviewProvider {
//    static var previews: some View {
//        BrailleConverterView()
//    }
//}
//
