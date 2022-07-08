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

struct AudioView: View {
    @State private var isPlaying = false
    
    var body: some View {
        
        NavigationView{
            Form {
                Section {
                    Text(isPlaying ? "playing" : "notPlaying")
                    Button {
                        isPlaying.toggle()
                    } label: {
                        Image(systemName: isPlaying ? "speaker.wave.3" : "speaker")
                    }
                    .sound("sample2.mp3", isPlaying: $isPlaying)
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
        AudioView()
    }
}
