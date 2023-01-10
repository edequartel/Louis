//
//  SettingsView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI


struct SettingsView: View {
    @EnvironmentObject var viewModel: PlaygroundViewModel
    
    
    let words = [1, 2, 3, 5, 8, 13, 21]
    let pauses = [1, 2, 3, 4, 5]
    
    let CHARACTER = 0
    let WORD = 1
    
    let activities = ["character","word"]//,"syllable","sentence","all"]
    let reading = ["not","before","after"]
    let pronounce = ["child","adult","form", "meaning"]
    let fonts = ["text","6dots", "8dots"]
    
    @State var showView = true
    
    var body: some View {
        NavigationView {
            Form {
                List {
                    
//                    Picker("Language".localized(), selection: viewModel.indexLanguage) {
//                        ForEach(viewModel.Languages, id: \.id) { country in
//                            Text(country.name).tag(country.id)
//                        }
//                    }
//                    .onChange(of: viewModel.indexLanguage) { tag in
//                        print("Change in tag country: \(tag)")
//                        viewModel.indexLesson = 0
//                        viewModel.indexMethod = 0
////                        viewModel.changeIndex = true
//                        viewModel.count = 0
//                    }
                    
                    Picker("method".localized(), selection: $viewModel.indexMethod) {
                        ForEach(viewModel.Languages[viewModel.indexLanguage].method, id: \.id) { method in
                            Text(method.name).tag(method.id)
                        }
                    }
                    .onChange(of: viewModel.indexMethod) { tag in
                        print("Change in tag method: \(tag)")
                        viewModel.indexLesson = 0
                        viewModel.updateViewData = true
                        viewModel.count = 0
                    }
                    
                    Picker("lesson".localized(), selection: $viewModel.indexLesson) {
                        ForEach(viewModel.Languages[viewModel.indexLanguage].method[viewModel.indexMethod].lesson, id: \.id) { lesson in
                            Text(lesson.name).tag(lesson.id)
                        }
                    }
                    .onChange(of: viewModel.indexLesson) { tag in
                        print("Change in tag lesson: \(tag)")
                        viewModel.updateViewData = true
                        viewModel.count = 0
                    }
                    
                    Section{
                        
                        Picker("activity".localized(), selection: $viewModel.indexActivity)
                        {
                            ForEach(0 ..< activities.count) {
                                Text("\(activities[$0])".localized()).tag($0)
                            }
                            
                        }
                        .onChange(of: viewModel.indexActivity) { tag in
                            print("change in indexActivity  \(activities[tag]) tag \(tag)")
                            viewModel.typeActivity = activities[tag]
                            viewModel.updateViewData = true
                        }
                        
                        if (viewModel.indexActivity==WORD) {
                            Toggle("chop".localized(), isOn: $viewModel.syllable)
                                .onChange(of: viewModel.syllable) {value in
                                }
                        }
                        
                        if (viewModel.syllable) && (viewModel.indexActivity==WORD) {
                            Toggle("talkword".localized(), isOn: $viewModel.talkWord)
                                .onChange(of: viewModel.talkWord) {value in
                                }
                        }
                        
                        if (viewModel.syllable) && (viewModel.indexActivity==WORD) {
                            Picker("pause".localized(),selection: $viewModel.indexPauses) {
                                ForEach(0 ..< pauses.count) {
                                    Text("\(pauses[$0]) x").tag($0)
                                }
                            }
                            .onChange(of: viewModel.indexPauses) {
                                tag in
                                viewModel.nrOfPause = pauses[tag]
                                
                            }
                        }
                        
                        if ((viewModel.syllable) && (viewModel.indexActivity==WORD)) || (viewModel.indexActivity==CHARACTER){
                            Picker("pronouncation".localized(), selection: $viewModel.indexPronounce)
                            {
                                ForEach(0 ..< pronounce.count) {
                                    Text("\(pronounce[$0])".localized()).tag($0)
                                }
                                
                            }
                            .onChange(of: viewModel.indexPronounce) { tag in
                                print("change in indexActivity  \(pronounce[tag]) tag \(tag)")
                                viewModel.typePronounce = pronounce[tag]
                            }
                        }
                    }
                    
                    
                    Section{
                        Picker("nroftrys".localized(), selection: $viewModel.indexWords) {
                            ForEach(0 ..< words.count) {
                                Text("\(words[$0])").tag($0)
                            }
                        }
                        .onChange(of: viewModel.indexWords) { tag in
                            print("change in nrofWords \(words[tag])")
                            viewModel.nrofTrys = words[tag]
                            viewModel.count = 0
                        }
                        
                        Toggle("conditional".localized(), isOn: $viewModel.conditional)
                            .onChange(of: viewModel.conditional) {value in
                            }
                        
                        Picker("reading".localized(), selection: $viewModel.indexReading) {
                            ForEach(0..<reading.count) {
                                Text("\(reading[$0])".localized()).tag($0)
                            }
                        }
                        .onChange(of: viewModel.indexReading) { tag in
                            print("change in indexReading \(tag)")
                            viewModel.readSound = reading[tag]
                        }
                        
                        Picker("font".localized(), selection: $viewModel.indexFont) {
                            ForEach(0..<fonts.count) {
                                Text("\(fonts[$0])".localized()).tag($0)
                            }
                        }
                        .onChange(of: viewModel.indexFont) { tag in
                            print("change in fonts \(tag)")
                        }
                    }
                    
                    Section{
                        Button {
                            viewModel.indexMethod = 0
                            viewModel.indexLesson = 0
                            viewModel.indexLanguage = 0
                            
                            viewModel.indexActivity = 0
                            viewModel.indexReading = 1
                            viewModel.indexWords = 3
                            
                            viewModel.brailleOn = true
                            viewModel.conditional = false
                            viewModel.syllable = false
                            
                            viewModel.readSound = reading[viewModel.indexReading]
                            viewModel.typeActivity = activities[viewModel.indexActivity]
                            viewModel.nrofTrys = words[viewModel.indexWords]
                            
                        } label : {
                            Text("reset".localized())
                        }
                        
                    }
                }
            }
            .navigationTitle("settings".localized())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}



