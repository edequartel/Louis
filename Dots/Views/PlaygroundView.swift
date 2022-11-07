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


struct bartStijl: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
        //            .background(Color("bartimeus"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func bartStyle() -> some View {
        modifier(bartStijl())
    }
}


struct PlaygroundView: View {
    private var Languages: [Language] = Language.Language
    
    let failure : SystemSoundID = 1057
    let nextword : SystemSoundID = 1113
    let nextlevel : SystemSoundID = 1115
    let monospacedFont = "Sono-Regular"
    
    @State private var myColor = Color.green
    @State private var items =  [""]
    @State private var item: String = ""
    @State private var input: String = ""
//    @State private var count: Int = 0
    //    @State private var mode: String = "Student"
    
    @AppStorage("COUNT") var count = 0
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    @AppStorage("INDEX_ACTIVITY") var indexActivity = 1
    @AppStorage("INDEX_READING") var indexReading = 1
    @AppStorage("INDEX_WORDS") var indexWords = 3
    @AppStorage("INDEX_PRONOUNCE") var indexPronouce = 0
    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("NROFWORDS") var nrofWords = 3
    @AppStorage("CONDITIONAL") var conditional = true
    @AppStorage("BRAILLEON") var brailleOn = false
    @AppStorage("MODESTUDENT") var modeStudent = false
    @AppStorage("TYPEACTIVITY") var typeActivity = "character"
    @AppStorage("CHANGEINDEX") var changeIndex = false
    @AppStorage("READING") var readSound = "not"
    @AppStorage("MAXLENGTH") var maxLength = 3
    
    @State private var atStartup = true
    
    @FocusState private var isFocused: Bool
    
    @State private var fillPercentage: CGFloat = 20
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    VStack {
                        HStack {
                            Text("\(getMethodeName())")
                                .bold()
                            Spacer()
                            Text("\(getLessonName())")
                        }
                        
                        .font(.headline)
                        Spacer()
                        
                        LinearProgress(
                            progress: CGFloat(100*count/nrofWords),
                            foregroundColor: myColor,
                            backgroundColor:  Color.green.opacity(0.2),
                            fillAxis: .horizontal
                        )
                        .frame(height: 5)
                        Spacer()
                        HStack{
                            Image(systemName: conditional ? "checkmark.circle": "circle")
                            Spacer()
                            Text("nroftrys".localized()+" \(nrofWords)")
                            Spacer()
                            Text("\(typeActivity)".localized())
                            Spacer()
                            Text("reading".localized() + " " + "\(readSound)".localized())
                        }
                        .font(.footnote)
                    }
                    .frame(height: 100)
                }
                
                .accessibilityHidden(true)
                
                
                
                Section {
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
                    TextField("", text:$input)
                        .font(.custom(monospacedFont, size: 32))
                        .foregroundColor(.blue)
                        .focused($isFocused)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onSubmit {
                            //dit is lees en tik//
                            if (input == item) ||  (!conditional) {
                                myColor =  Color.green
                                play(sound: readSound == "after" ? item+".mp3" : "")
                                
                                count += 1
                                if (count >= nrofWords) { //nextlevel
                                    play(sound: "nextlevel.mp3") //?
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
                                myColor = Color.red
                            }
                            isFocused = true
                        }
                }
                .frame(height: 60)
            }
            .navigationTitle("play".localized())
            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarItems(
//                leading: HStack {
//                    Button( action: {
//                        isFocused.toggle()
//                    }) {Image(systemName: "keyboard")
//                    }
//                }
//            )
        }
        .onAppear() {
            //            indexLesson = 0
            //            indexMethod = 0
            //            if (talkingOn) {
            //                play(sound: item+".mp3")
            //            }
            //            indexActivity=0
            //            indexReading = 0
            //            play(sound: readSound == "before" ? item+".mp3" : "")
            
            if (atStartup || changeIndex) {
                if (typeActivity == "character") {
                    items = Languages[indexLanguage].method[indexMethod].lesson[indexLesson].letters.components(separatedBy: " ").shuffled()
                }
                else {
                    items = Languages[indexLanguage].method[indexMethod].lesson[indexLesson].words.components(separatedBy: " ").shuffled()
                }
                item=items[0]
                isFocused.toggle()
                Shuffle()
                atStartup = false
                if changeIndex { print("changeIndex=true>false")}
                changeIndex = false
            }
        }
        
    }
    
    func Shuffle() {
        print("shuffled")
        var teller = 0
        //        while ((item==items[0]) && (item.count>maxLength)) {
        while (item==items[0]) {
            if (typeActivity == "character") {
                items = Languages[indexLanguage].method[indexMethod].lesson[indexLesson].letters.components(separatedBy: " ").shuffled()
            }
            else {
                items = Languages[indexLanguage].method[indexMethod].lesson[indexLesson].words.components(separatedBy: " ").shuffled()
            }
            
            
            //            items = Languages[indexLanguage].method[indexMethod].lesson[indexLesson].words.components(separatedBy: " ").shuffled()
            teller += 1
        }
        item = items[0]
        
        
        if (readSound == "before") {
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

