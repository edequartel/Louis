//
//  InformationView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI

struct InformationView: View {
    @Environment(\.accessibilityVoiceOverEnabled) var voEnabled: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.locale) private var locale
    @Environment(\.calendar) private var calendar
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    
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
                    
                    //                    Image("Logo") // displays a cute image saved as "puppy" in Assets folder
                    //                        .resizable() // makes image fill all available space
                    //                        .aspectRatio(contentMode: .fit)
                    //                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                    
                    
                    Section {
                        Text(locale.description)
                        Text(calendar.description)
                        Text(horizontalSizeClass == .compact ? "Compact": "Regular")
                        Text(colorScheme == .dark ? "Dark mode" : "Light mode")
                        Text(voEnabled ? "Voiceover On`" : "Voiceover off")
                    }.font(.headline)
                    
                    
                }
                
                Text("developedBy".localized())
            
                //                        .italic()
                .foregroundColor(.primary)
                //                        .fontWeight(Weight(value: 0.0))
                .multilineTextAlignment(.leading)
                .lineLimit(5)
                .lineSpacing(1.0)
                //                        .textSelection(.enabled)
            }
            
            
        }
        .navigationTitle("Information".localized())
        .navigationBarTitleDisplayMode(.inline)
    }
    
}


struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
