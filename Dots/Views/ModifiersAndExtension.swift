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
        case .child: return "child_"
        case .adult: return "adult_"
        case .form: return "form_"
        case .meaning: return "form_"
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

enum fontEnum: Int, CaseIterable {
    case text = 0
    case dots8 = 1
    
    func stringValue() -> String {
        switch(self) {
        case .text: return "text"
        case .dots8: return "8dots"
        }
    }
}

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
