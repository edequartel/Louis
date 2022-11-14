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
                    Text("developedBy".localized())
                        .listRowSeparator(.hidden)
                    List{
                        Link(destination: URL(string: "http://www.bartimeus.nl")!, label: {
                            Text("www.bartimeus.nl")
                            
                        })
                        Link(destination: URL(string: "http://www.tastenbraille.com/wikilouis")!, label: {
                            Text("louisOnline".localized())
                            
                        })
                       
                        Link(destination: URL(string: "https://vimeo.com/showcase/9833359")!, label: {
                            Text("instructionVideos".localized())
                            
                        })
                       
                    }

                }
                .font(.footnote)
                
                Section {
                    Text("helpshorttext".localized())
                }
                .font(.footnote)

                
                Section {
                    Text(version())
                    Text(locale.description)
                    Text(voEnabled ? "Voiceover on" : "Voiceover off")
                }
                .font(.footnote)
//            header: {
//                    Text("information".localized())
//                }
//                .font(.headline)
                

                
            }
                            .lineSpacing(0.5)
            .navigationTitle("information".localized())
            .navigationBarTitleDisplayMode(.inline)
            
            
        }
 
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
