//
//  SearchWordView.swift
//  Braille
//
//  Created by Eric de Quartel on 22/03/2022.
//

import SwiftUI

struct SearchWordView: View {
    @State var tekst: String = ""
    var woorden = ["bal","bla","lab"]
    var body: some View {

        NavigationView{
            Form {
                Section {
                    Text("bal")
                }
                Section {
                    TextField("\(woorden.joined(separator: "-"))", text: $tekst)
                }
            }
            .navigationTitle("Zoek woord")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct SearchWordView_Previews: PreviewProvider {
    static var previews: some View {
        SearchWordView()
    }
}
