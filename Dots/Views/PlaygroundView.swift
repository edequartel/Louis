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
    private var Languages: [Language] = Language.Language
    
    let failure : SystemSoundID = 1057
    let nextword : SystemSoundID = 1113
    let nextlevel : SystemSoundID = 1115
    let monospacedFont = "Sono-Regular"
    
    @State private var items =  [""]
    @State private var item: String = ""
    @State private var input: String = ""
    @State private var count: Int = 0
    @State private var mode: String = "Student"
    
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("NROFWORDS") var nrofWords = 3 //dit is aantal wanneer verder wordt gegaan
    @AppStorage("TALKINGON") var talkingOn = false
    @AppStorage("BRAILLEON") var brailleOn = false
    @AppStorage("MODESTUDENT") var modeStudent = true
    @AppStorage("TYPEACTIVITY") var typeActivity = "character"
    
    @State private var firstT = true
    
    
    @FocusState private var isFocused: Bool
    
    @State private var fillPercentage: CGFloat = 20
    
    var body: some View {
        
        NavigationView{
            Form {
                Section {
                    HStack {
                        Text("\(getMethodeName())")
                            .bold()
                        Spacer()
                        //                        Text("\(indexLesson)")
                        //                        Spacer()
                        Text("\(getLessonName())")
                    }
                }
                .accessibilityHidden(modeStudent)
                
                
                
                Section {
                    LinearProgress(
                        progress: CGFloat(100*count/nrofWords),
                        foregroundColor: .green,
                        backgroundColor: Color.green.opacity(0.2),
                        fillAxis: .horizontal
                    )
                    .frame(height: 5)
                    if (brailleOn) {
                        HStack{
                            Text("\(item)")
                                .accessibilityHidden(modeStudent)
                                .font(Font.custom("bartimeus6dots", size: 32))
                        }
                    }
                    else {
                        
                        HStack{
                            Text("\(item)")
                                .font(.custom(monospacedFont, size: 32))
                                .accessibilityHidden(modeStudent)
                        }
                        
                    }
                    
//                    switch typeActivity {
//                    case "character":
//                            Text("Character!")
//                    case "word":
                        TextField("", text:$input)
                            .font(.custom(monospacedFont, size: 32))
                            .foregroundColor(.blue)
                            .focused($isFocused)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .onSubmit {
                                //dit is lees en tik//
                                if input == item {
                                    count += 1
                                    if (count >= nrofWords) { //nextlevel
                                        play(sound: "nextlevel.mp3")
                                        if indexLesson<(Languages[indexLanguage].method[indexMethod].lesson.count-1) {
                                            indexLesson += 1
                                        }
                                        else {
                                            indexLesson = 0
                                        }
                                        count = 0
                                    }
                                    
                                    //wacht tot sound klaar is voordat er geshuffeld wordt
                                    Shuffle()
                                    input = ""
                                }
                                else {
                                    if count>0 {count -= 1}
                                    AudioServicesPlaySystemSound(failure)
                                }
                                isFocused = true
                            }
                    

//                    case "sentence":
//                            Text("Sentence!")
//                    case "all":
//                            Text("All!")
//                    default:
//                            Text("No implementation")
//                    }
                }
                
                Section {
                    
                    Image("CircleLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        
                }
                .accessibilityHidden(modeStudent)
            }
            
            
            .navigationBarItems(
                leading: HStack {
                }
                ,
                trailing: HStack {
                    Button( action: {
                        isFocused.toggle()
                    }) {Image(systemName: "keyboard")
                    }
                }
            )
        }
        .onAppear() {
            //            indexLesson=0
//            indexMethod = 0
            if (talkingOn) {
                play(sound: item+".mp3")
            }
            
            if firstT {
                items = Languages[indexLanguage].method[indexMethod].lesson[indexLesson].words.components(separatedBy: " ").shuffled()
                item=items[0]
                isFocused.toggle()
                Shuffle()
                firstT = false
            }
            
            
        }
        
        
    }
    
    func Shuffle() {
        print("shuffled")
        while item==items[0] {
            items = Languages[indexLanguage].method[indexMethod].lesson[indexLesson].words.components(separatedBy: " ").shuffled()
        }
        item = items[0]
        if (talkingOn) {
            play(sound: item+".mp3")
        }
        else //nextone
        {
            AudioServicesPlaySystemSound(nextword)
        }
    }
    
    func Speak(value: String) {
        let utterance = AVSpeechUtterance(string: value)
        utterance.voice = AVSpeechSynthesisVoice(language: "nl")
        utterance.rate = 0.5
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        
    }
    
    func getLessonName()->String {
        guard (indexLesson < Languages[indexLanguage].method[indexMethod].lesson.count) else {
            return "unknown Lesson"
        }
        return Languages[indexLanguage].method[indexMethod].lesson[indexLesson].name
    }
    
    func getMethodeName()->String {
        guard (indexMethod < Languages[indexLanguage].method.count) else {
            return "unknown Method"
        }
        return Languages[indexLanguage].method[indexMethod].name
    }
    
}

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundView()
    }
}

