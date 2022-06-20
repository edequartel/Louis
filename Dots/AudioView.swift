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
    @StateObject private var sound = SubsonicPlayer(sound: "sample4.mp3")
    var body: some View {
        
        NavigationView{
            Form {
                Section {
                    Button("Start") {
                        sound.play()
                    }
                    
                    Button("Stop") {
                        sound.stop()
                    }
                    
                    Slider(value: $sound.volume)
                } header: {
                    Text("Speler")
                }
                
                Section {
                    Button("TekstNaarSpraak NL") {
                        let utterance = AVSpeechUtterance(string: "Het is lente. De bloemetjes bloeien.")
                        utterance.voice = AVSpeechSynthesisVoice(language: "nl")
                        utterance.rate = 0.5
                        
                        let synthesizer = AVSpeechSynthesizer()
                        synthesizer.speak(utterance)
                    }
                }header: {
                    Text("Tekst naar spraak")
                }
            }
            .navigationTitle("Audio")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AudioView_Previews: PreviewProvider {
    static var previews: some View {
        AudioView()
    }
}
