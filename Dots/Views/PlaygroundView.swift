//
//  PlaygroundView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI
import Subsonic

import AVFoundation


struct PlaygroundView: View {
    @EnvironmentObject var settings: Settings
    let tink : SystemSoundID = 1057
    let nextword : SystemSoundID = 1113
    let nextlevel : SystemSoundID = 1115
    
    @State private var items =  [""]
    @State private var item: String = ""
    @State private var input: String = ""
    @State private var count: Int = 0
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        NavigationView{
            Form {
                Section {
                    HStack {
                        Text("\(settings.method.name)")
                            .bold()
                        Spacer()
                        Text("\(settings.selectedLesson+1) \(settings.lesson.name)")
                    }
                }
                .accessibilityHidden(true)
                
                Section {
//                    Button("Toggle Focus") {
//                                    isFocused.toggle()
//                                }
                    
                    HStack{
                        Text("\(item)")
                        Spacer()
                        Text("\(item)")
                            .font(Font.custom("bartimeus6dots", size: 32))
                            .foregroundColor(.blue)
                    }
                    TextField("Input", text:$input)
                        .disableAutocorrection(true)
                        .focused($isFocused)
                        .autocapitalization(.none)
                        .onSubmit {
                            //dit is lees en tik//
                            if input == item {
                                count += 1
                                if (count >= settings.nrofWords) { //nextlevel
                                    AudioServicesPlaySystemSound(nextlevel)
                                    Speak(value: "volgende woord")
                                    settings.selectedLesson += 1
                                    count = 0
                                }
                                else //nextone
                                {
                                    AudioServicesPlaySystemSound(nextword)
                                }
                                //wacht tot sound klaar is voordat er geshuffeld wordt
                                Shuffle()
                                input = ""
                            }
                            else {
                                //try it again
                                AudioServicesPlaySystemSound(tink)
                            }
                           
                            isFocused = true
                            //lees en tik//
                            
                        }
                }
            }
            .navigationTitle("Play \(count) - \(settings.nrofWords)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
//                    Speak(value: settings.lesson.comments)
                    play(sound: "leesenvulin.wav")
                }) {Image(systemName: "person.wave.2.fill")}
                ,
                trailing: HStack {
                    Button( action: {
                        AudioServicesPlaySystemSound(nextlevel)
                        settings.selectedLesson += 1
                        Shuffle()
                    }) {Image(systemName: "plus.circle")}
                    Spacer()
                    Button( action: {
                        isFocused.toggle()
                    }) {Image(systemName: "poweroff")}
                    
                }
            )
        }
        .onAppear() {
            //            Speak(value: settings.lesson.comments) //deze later uit de action halen nu ok
            items = settings.lesson.words.components(separatedBy: " ").shuffled()
            item=items[0]
//            play(sound: "leesenvulin.wav")
            isFocused.toggle()
        }
        
    }
    
    func Shuffle() {
        print("shuffled")
        while item==items[0] {
            items = settings.lesson.words.components(separatedBy: " ").shuffled()
        }
        item = items[0]
        play(sound: item+".mp3")
    }
    
    func Speak(value: String) {
        let utterance = AVSpeechUtterance(string: value)
        utterance.voice = AVSpeechSynthesisVoice(language: "nl")
        utterance.rate = 0.5
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
    }
    
    
}

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()
        PlaygroundView().environmentObject(settings)
    }
}

