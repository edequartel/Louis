//
//  PlaygroundView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI

struct PlaygroundView: View {
    @State var text1 = ""
    @State var isEditing1 = true
    @State var text2 = ""
    @State var isEditing2 = false
    
    @State var x=0
    @State var y=0
    
    @State var tekst: String = ""

    
    var body: some View {
        
        NavigationView{
            Form {
                Section {
                    Text("ababbabbba")
                }
                Section {
                    TextField("Placeholder", text: .constant("This is text data"))
              
                }
            }
            .navigationTitle("Speelveld")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    
    
}

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundView()
    }
}


