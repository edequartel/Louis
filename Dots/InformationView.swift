//
//  InformationView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI

struct InformationView: View {
    var body: some View {
        
        NavigationView{
            Form {
                Section {
                    Link(destination: URL(string: "http://www.tastenbraille.com/wiki")!, label: {
                        Text("Tast en Braille")
                            .foregroundColor(.orange)
                    })
                }
            }
            .navigationTitle("Informatie")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
