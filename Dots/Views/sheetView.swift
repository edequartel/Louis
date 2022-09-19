//
//  sheetView.swift
//  Dots
//
//  Created by Eric de Quartel on 19/09/2022.
//

import SwiftUI

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


