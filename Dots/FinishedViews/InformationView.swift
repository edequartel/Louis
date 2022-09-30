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
                    Link(destination: URL(string: "http://www.tastenbraille.com/wikilouis")!, label: {
                        Text("Louis")
                    })
                    Text("Video: aansluiten leesregel op iPhone")
                    Text("Video: activiteit, lees de tekst en luister")
                    
                }
                Section {
                    Image("Logo") // displays a cute image saved as "puppy" in Assets folder
                                .resizable() // makes image fill all available space
                                .aspectRatio(contentMode: .fit)
                  
//                                .frame(width: 350, height: 350) // resizes image to specified width and height
//                                .clipShape(Circle()) // clips image with shape circle
//                                .overlay(Circle().stroke(Color.white, lineWidth: 5)) // puts white boarder around image
                                .shadow(radius: 10) // displays shadow around image
                    Text("""
                            Developed and
                            under construction
                            by
                            Bartiméus Education
                            Eric de Quartel
                         """)
                    //                        .italic()
                    .foregroundColor(.primary)
                    //                        .fontWeight(Weight(value: 0.0))
                    .multilineTextAlignment(.leading)
                    .lineLimit(5)
                    .lineSpacing(1.0)
                    //                        .textSelection(.enabled)
                }
                
            }
            .navigationTitle("Information")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
