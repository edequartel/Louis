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

struct Event {
    var sounds=["a.wav","b.wav","c.wav"]
    var playlistIndex: Int = 0
    var FisSpelend = false
    var isSpelend: Bool {
        get {
            FisSpelend
        }
        set(newValue) {
            playlistIndex = (!newValue && FisSpelend) ? playlistIndex+1 : playlistIndex
            FisSpelend = newValue
            print("newvalue \(playlistIndex)")
        }
    }
}

struct AudioView: View {
    var sounds=["a.wav","b.wav","c.wav"]
    
    @State private var audioEvent = Event()
    
    @State private var playIndex: Int = 0
    @State private var isSpelend = false
    
    var body: some View {
        
        NavigationView{
            Form {
                HStack{
                    Text(isSpelend ? "playing" : "notPlaying")
                    Spacer()
                    Text("\(sounds[playIndex])")
                    Spacer()
                    Text("\(playIndex)")
                    Spacer()
                    Image(systemName: isSpelend ? "speaker.wave.3" : "speaker")
                }
                
                
                Section {
                    Button {
                        isSpelend.toggle()
                        audioEvent.isSpelend.toggle()
                    } label: {
                        Text("Play")
                    }
                    .sound(sounds[audioEvent.playlistIndex], isPlaying: $audioEvent.isSpelend)
                    
                    Picker("Sounds \(playIndex)", selection: $playIndex) {
                        ForEach(0..<sounds.count) {
                            Text(sounds[$0]) // <3>
                        }
                    }

                    
                    
                } header: {
                    Text("Player")
                }
                
                
                Section {
                    Button("TekstNaarSpraak NL") {
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
        Group {
            AudioView()
            AudioView()
        }
    }
}
