//
//  ModifiersAndExtension.swift
//  Dots
//
//  Created by Eric de Quartel on 08/01/2023.
//

import Foundation
import SwiftUI

//modifiers
struct bartimeusStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.bart_green)
            .foregroundColor(Color.bart_purple)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

//extensions
extension View {
    func bartStyle() -> some View {
        modifier(bartimeusStyle())
    }
}

extension Color {
    static let bart_green = Color(red: 0 / 255, green: 130 / 255, blue: 69 / 255)
    static let bart_purple = Color(red: 130 / 255, green: 0 / 255, blue: 62 / 255)
    static let bart_complement = Color(red: 255 / 255, green: 125 / 255, blue: 0 / 255)
}

//enums
enum activityEnum: Int, CaseIterable {
    case character = 0
    case word = 1
    
    // Convert to string to display in menus and pickers.
    func stringValue() -> String {
        switch(self) {
        case .character: return "character"
        case .word: return "word"
        }
    }
}

enum pronounceEnum: Int, CaseIterable {
    case child = 0
    case adult = 1
    case form = 2
    case meaning = 3
    
    // Convert to string to display in menus and pickers.
    func stringValue() -> String {
        switch(self) {
        case .child: return "child"
        case .adult: return "adult"
        case .form: return "form"
        case .meaning: return "meaning"
        }
    }
    
    func prefixValue() -> String {
        switch(self) {
        case .child: return "child"
        case .adult: return "adult"
        case .form: return "form"
        case .meaning: return "form"
        }
    }
}

enum positionReadingEnum: Int, CaseIterable {
    case not = 0
    case before = 1
    case after = 2
    
    func stringValue() -> String {
        switch(self) {
        case .not: return "not"
        case .before: return "before"
        case .after: return "after"
        }
    }
}

enum caseConversionEnum: Int, CaseIterable {
    case lowerCase = 0
    case upperCase = 1
    case capitalisation = 2
    
    func stringValue() -> String {
        switch(self) {
        case .lowerCase: return "lowercase"
        case .upperCase: return "uppercase"
        case .capitalisation: return "capitalisation"
        }
    }
}

//enum fontEnum: Int, CaseIterable {
//    case text = 0
//    case dots8 = 1
//    
//    func stringValue() -> String {
//        switch(self) {
//        case .text: return "text"
//        case .dots8: return "8dots"
//        }
//    }
//}

let trys = [1, 2, 3, 5, 8, 15, 21, 999]

let pauses = [1, 2, 3, 4, 5]

let uniCode = [
    "!"  : "33",
    //    "\"" : "34",
    "#"  : "35",
    "$"  : "36",
    "%"  : "37",
    "&"  : "38",
    //    "'"  : "39",
    ","  : "44",
    "."  : "46"
]


extension Color {
    static let lightGray = Color(
        uiColor: UIColor.lightGray
    )
    static let darkGray = Color(
        uiColor: UIColor.darkGray
    )
}

struct Square: ViewModifier {
    var color : Color = .blue
    var width : CGFloat = .infinity
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding(20)
            .frame(minWidth: 0, maxWidth: width)
            .background(color)
            .cornerRadius(10)
    }
}

struct Border: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.bart_green)
            .padding(20)
            .border(Color.bart_green, width: 5)
            .cornerRadius(5)
    }
}

// Define separators for long sounds
let separators = ["eeuw", "sch", "eeu", "ij", "ooi", "aa", "ui", "oo", "eu", "ei"]
