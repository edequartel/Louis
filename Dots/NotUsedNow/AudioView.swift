//
//  AudioView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI
import Subsonic

import AVFoundation
var player: AVAudioPlayer!

struct AudioEvent {
    var sounds=["a.wav","b.wav","c.wav"]
    var playlistIndex: Int = 0
    
    var FisSpelend = false
    var isSpelend: Bool {
        get {
            return FisSpelend
            
        }
        set(newValue) {
            FisSpelend = newValue
        }
    }
}

struct AudioView: View {
    @State private var audioEvent = AudioEvent()

    var body: some View {
        
        NavigationView{
            Form {
                HStack{
                    Text("\(audioEvent.sounds[audioEvent.playlistIndex])")
                    Spacer()
                    Image(systemName: audioEvent.isSpelend ? "speaker.wave.3" : "speaker")
                }
                
                
                Section {
                    Button {
                        audioEvent.isSpelend = true
                    } label: {
                        Text("Play")
                    }
                    .sound(audioEvent.sounds[audioEvent.playlistIndex], isPlaying: $audioEvent.isSpelend)
                    
//                    Picker("Sounds \(audioEvent.playlistIndex)", selection: $audioEvent.playlistIndex) {
//                        ForEach(0..<audioEvent.sounds.count) {
//                            Text(audioEvent.sounds[$0]) // <3>
//                        }
//                    }
                    
                    
                    
                } header: {
                    Text("Player")
                }
                
                
                Section {
                    Button("TekstNaarSpraak NL") {
                        print("gebruiken voor instructie")
                        Speak(value: "gebruiken voor instructie")
                    }
                }header: {
                    Text("Text To Speech")
                }
            }
            .navigationTitle("Audio")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
    
    func Speak(value: String) {
        let utterance = AVSpeechUtterance(string: value)
        utterance.voice = AVSpeechSynthesisVoice(language: "nl")
        utterance.rate = 0.5
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
}

struct AudioView_Previews: PreviewProvider {
    static var previews: some View {
            AudioView()
    }
}

