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
    var sounds=["a.wav","b.wav","c.wav"]
    
    @State private var playIndex: Int = 0
    @State private var isPlaying = false
    
    var body: some View {
        
        NavigationView{
            Form {
                HStack{
                    Text(isPlaying ? "playing" : "notPlaying")
                    Spacer()
                    Text("\(sounds[playIndex])")
                    Spacer()
                    Text("\(playIndex)")
                    Spacer()
                    Image(systemName: isPlaying ? "speaker.wave.3" : "speaker")
                }
                
                
                Section {
                    Button {
                        isPlaying = true //.toggle()
                    } label: {
                        Text("\(sounds[playIndex])")
                    }
                    .sound("\(sounds[playIndex])", isPlaying: $isPlaying) //<<<<
                    
                    Button {
                        playIndex = playIndex >= sounds.count-1 ?  0 : playIndex+1
                        //isPlaying.toggle()
                    } label : {
                        Text("next")
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
