//
//  PlaygroundView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI

struct PlaygroundView: View {
    @EnvironmentObject var settings: Settings
    private var countries: [Country] = Country.allCountries
    
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
                    HStack {
                    Text("\(settings.method.name)")
                            .bold()
                        Spacer()
                        Text("\(settings.selectedLesson+1) \(settings.lesson.name)")
                            .bold()
                    }
                }
                
                Section {
                    let str = settings.lesson.words
                    let items = str.components(separatedBy: " ")
                    List {
                        ForEach(items, id: \.self) { item in
                            HStack {
                                Text(item)
                                    .foregroundColor(.gray)
                                    .font(.custom(
                                        "bartimeus6dots",
                                        fixedSize: 32))
                                
                                Spacer()
                                Text(item)
                            }
                        }
                        
                    }
                    
                }
                
                Section {
                    Button ("selectedLesson inc") {
                        settings.selectedLesson += 1
                    }
                }
                
//                Section {
//                    Button("Search word") {
//                        SearchWordView()
//                    }
//                }
            }
            .navigationTitle("Play")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    
    
}

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundView()
    }
}


