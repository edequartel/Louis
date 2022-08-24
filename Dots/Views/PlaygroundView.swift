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
    
    @State private var items =  [""]
    @State private var item: String = ""
    @State private var input: String = ""
    @State private var count: Int = 0
    
    private enum Field : Int, Hashable {
        case name, location, date, addAttendee
    }
    @FocusState private var focusedField: Field?
    
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
                .accessibilityHidden(true)
                
                Section {
                    Text("\(item)")
                    TextField("Input", text:$input)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .addAttendee)
                        .autocapitalization(.none)
                        .onSubmit {
                            if input == item {
                                play(sound: "applaus.mp3")
                                count += 1
                                if (count > 3) {
                                    Speak(value: "volgende woord")
                                    settings.selectedLesson += 1
                                    count = 0
                                }
                                //wacht tot sound klaar is voordat er geshuffeld wordt
                                Shuffle()
                                input = ""
                            }
                            else {
                                Speak(value: "probeer het nog een keer")
                            }
                            //textfield is niet gefocues=d hoe dan?
                        }
                }
            }
            .navigationTitle("Play (\(settings.selectedLesson+1)-\(count+1))")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    Speak(value: settings.lesson.comments)
                }) {Image(systemName: "info.circle")}
                ,
                trailing: Button( action: {
                    settings.selectedLesson += 1
                    Shuffle()
                }) {Image(systemName: "plus.circle")}
            )
        }
        .onAppear() {
            //            Speak(value: settings.lesson.comments) //deze later uit de action halen nu ok
            items = settings.lesson.words.components(separatedBy: " ").shuffled()
            item=items[0]
            play(sound: item+".mp3")
            focusedField = .addAttendee
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
        PlaygroundView()
    }
}

//                    List {
//                        ForEach(items, id: \.self) { item in
//                            HStack {
//                                Text(item)
//                            }
//                        }
//                    }

