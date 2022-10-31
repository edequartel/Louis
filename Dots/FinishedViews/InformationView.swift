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
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    
    var body: some View {
        
        NavigationView{
            
            
            Form {
                Section {
                    Link(destination: URL(string: "http://www.tastenbraille.com/wikilouis")!, label: {
                        Text("Louis online")
                    })
                    //                    Link(destination: URL(string: "https://vimeo.com/showcase/9833359")!, label: {
                    //                        Text("Video")
                    //                    })
                }
                
                //                Section {
                Section {
                    Text(locale.description)
                    Text(calendar.description)
                    Text(horizontalSizeClass == .compact ? "Compact": "Regular")
                    Text(colorScheme == .dark ? "Dark mode" : "Light mode")
                    Text(voEnabled ? "Voiceover On`" : "Voiceover off")
                } header: {
                    Text("information".localized())
                    }
                .font(.headline)
                
                //                }
                
                Section{
                    Text(version())
                }
                
                Section {
                    Text("developedBy".localized())
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(5)
                        .lineSpacing(1.0)
                        .textSelection(.enabled)
                }
            }
            
            
        }
        .navigationTitle("information".localized())
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "Version \(version) build \(build)"
    }
    
}


struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
