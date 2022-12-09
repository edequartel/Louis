//
//  sheetView.swift
//  Dots
//
//  Created by Eric de Quartel on 19/09/2022.
//

import SwiftUI

extension Color {
static let teal = Color(red: 49 / 255, green: 163 / 255, blue: 159 / 255)
static let darkPink = Color(red: 208 / 255, green: 45 / 255, blue: 208 / 255)
}

struct sheetView: View {
    let name: String
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Text("Second View \(name)")
        Button("Dismiss") {
                    dismiss()
                }
    }
}

struct sheetView_Previews: PreviewProvider {
    static var previews: some View {
        sheetView(name: "eric")
    }
}


