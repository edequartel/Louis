//
//  AudioView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI

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
    var body: some View {
        NavigationView{
            Text("Audio")
        }
    }
}

struct AudioView_Previews: PreviewProvider {
    static var previews: some View {
            AudioView()
    }
}

