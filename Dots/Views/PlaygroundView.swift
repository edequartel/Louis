//
//  PlaygroundView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI
import Subsonic
import SwiftProgress

import AVFoundation

struct PlaygroundView: View {
    @EnvironmentObject var settings: Settings
    let failure : SystemSoundID = 1057
    let nextword : SystemSoundID = 1113
    let nextlevel : SystemSoundID = 1115
    let monospacedFont = "Sono-Regular"
    
    @State private var items =  [""]
    @State private var item: String = ""
    @State private var input: String = ""
    @State private var count: Int = 0
    
    @FocusState private var isFocused: Bool
    
    @State private var fillPercentage: CGFloat = 20
    
    var body: some View {
        
        NavigationView{
            Form {
                Section {
                    HStack {
                        Text("\(settings.method.name)")
                            .bold()
                        //                        Spacer()
                        //                        Text("\(count)/\(settings.nrofWords)")
                        Spacer()
                        Text("\(settings.selectedLesson+1) \(settings.lesson.name)")
                    }
                }
                .accessibilityHidden(true)
                
                //                Section {
                
                //                }
                .accessibilityHidden(true)
                
                Section {
                    LinearProgress(
                        progress: CGFloat(100*count/settings.nrofWords),
                        foregroundColor: .green,
                        backgroundColor: Color.green.opacity(0.2),
                        fillAxis: .horizontal
                    )
                    .frame(height: 5)
                    if (settings.brailleOn) {
                        HStack{
                            Text("\(item)")
                                .accessibilityHidden(true)
                                .font(Font.custom("bartimeus6dots", size: 32))
                            //                                .foregroundColor(.blue)
                        }
                    }
                    else {
                        
                        HStack{
                            Text("\(item)")
                                .font(.custom(monospacedFont, size: 32))
                            //                                .foregroundColor(.blue)
                                .accessibilityHidden(true)
                            
                            Spacer()
                            Text("\(item)")
                                .font(Font.custom("bartimeus6dots", size: 32))
                            //                                .foregroundColor(.blue)
                        }
                    }
                    
                    //                    Text("\(input)")
                    //                        .font(Font.custom("bartimeus6dots", size: 32))
                    //                        .foregroundColor(.red)
                    
                    
                    TextField("Input", text:$input)
                        .font(.custom(monospacedFont, size: 32))
                        .foregroundColor(.blue)
                        .disableAutocorrection(true)
                        .focused($isFocused)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit {
                            //dit is lees en tik//
                            if input == item {
                                count += 1
                                if (count >= settings.nrofWords) { //nextlevel
                                    play(sound: "nextlevel.mp3")
                                    settings.selectedLesson += 1
                                    count = 0
                                }
                                
                                //wacht tot sound klaar is voordat er geshuffeld wordt
                                Shuffle()
                                input = ""
                            }
                            else {
                                //try it again
                                AudioServicesPlaySystemSound(failure)
                                //                                play(sound: "failure.mp3")
                                
                            }
                            isFocused = true
                            //lees en tik//
                            
                        }
                    
                }
                
                Section {
                    Text("""
                            3x sidebutton voiceOver
                            3x3 fingers screen curtain
                            3x2 fingers speechoff
                         """)
                    //                        .italic()
                    .foregroundColor(.primary)
                    //                        .fontWeight(Weight(value: 0.0))
                    .multilineTextAlignment(.leading)
                    .lineLimit(5)
                    .lineSpacing(1.0)
                    //                        .textSelection(.enabled)
                }
                .accessibilityHidden(true)
                
                
                
            }
            //            .navigationTitle("Play \(count) - \(settings.nrofWords)")
            //            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button( action: {
                    AudioServicesPlaySystemSound(nextlevel)
                    settings.selectedLesson += 1
                    Shuffle()
                }) {Image(systemName: "plus.circle")}
                    .accessibility(label: Text("Next word"))
                    .accessibilityHidden(true)
                ,
                trailing: HStack {
                    Button( action: {
                        isFocused.toggle()
                    }) {Image(systemName: "keyboard")
                            .accessibilityHidden(true)
                    }
                    
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
        if (settings.talkingOn) {
            play(sound: item+".mp3")
        }
        else //nextone
        {
            AudioServicesPlaySystemSound(nextword)
            //                                    play(sound: "succes.mp3")
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

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = Settings()
        PlaygroundView().environmentObject(settings)
    }
}

