//
//  ModifiersAndExtension.swift
//  Dots
//
//  Created by Eric de Quartel on 08/01/2023.
//

import Foundation
import SwiftUI

//modifiers
struct bartStijl: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color("bartimeus"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

//extensions
extension View {
    func bartStyle() -> some View {
        modifier(bartStijl())
    }
}
