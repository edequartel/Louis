//
//  PlaygroundView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI
import Soundable
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
    
    let synthesizer = AVSpeechSynthesizer()
    
    let failure : SystemSoundID = 1057
    let nextword : SystemSoundID = 1113
    let nextlevel : SystemSoundID = 1115
    let monospacedFont = "Sono-Regular"
    
    @State var isPlaying = false
    
    let child = 0
    let adult = 1
    let form = 2
    
//    enum Speech {
//        case child
//        case adult
//        case form
//    }
    
    
    @State private var myColor = Color.green
    @State private var items =  [""]
    @State private var item: String = ""
    @State private var input: String = ""
    
    
    
    @AppStorage("COUNT") var count = 0
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    @AppStorage("INDEX_ACTIVITY") var indexActivity = 1
    @AppStorage("INDEX_READING") var indexReading = 0
    @AppStorage("INDEX_PRONOUNCE") var indexPronounce = 0
    @AppStorage("INDEX_WORDS") var indexWords = 3
    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("INDEX_BRAILLEFONT") var indexFont = 1
    @AppStorage("NROFWORDS") var nrofTrys = 3
    @AppStorage("CONDITIONAL") var conditional = true
    @AppStorage("SYLLABLE") var syllable = true
    @AppStorage("BRAILLEON") var brailleOn = false
    @AppStorage("MODESTUDENT") var modeStudent = true
    @AppStorage("TYPEACTIVITY") var typeActivity = "word"
    @AppStorage("TYPEPRONOUNCE") var typePronounce = "child"
    @AppStorage("CHANGEINDEX") var updateViewData = false
    @AppStorage("READING") var readSound = "not"
    @AppStorage("MAXLENGTH") var maxLength = 3
    
//    @AppStorage("TEST") var pron = Speech.adult
    
    let prefixPronounce = ["child_","adult_","form_","form_"]
    
    
    @State private var atStartup = true
    
    @FocusState private var isFocused: Bool
    
    @State private var fillPercentage: CGFloat = 20
    
    
    let sound1 = Sound(fileName: "sch.mp3")
    let sound2 = Sound(fileName: "aa.mp3")
    let sound3 = Sound(fileName: "child_r.mp3")
    
    let klanken = ["sch.mp3","aa.mp3","child_r.mp3"]
    
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
                        HStack {
                            Text("\(count)")
                            Spacer()
                            LinearProgress(
                                progress: CGFloat(100*count/nrofTrys),
                                foregroundColor: myColor,
                                backgroundColor:  Color.green.opacity(0.2),
                                fillAxis: .horizontal
                            )
                            .frame(height: 5)
                            Spacer()
                            Text("\(nrofTrys)")
                            
                        }
                        .font(.footnote)
                        Spacer()
                        HStack{
                            //                            Text("\(count)-\(nrofWords)")
                            Image(systemName: conditional ? "checkmark.circle": "circle")
                            //                            Spacer() "nroftrys".localized()+
                            
                            Spacer()
                            Text("\(typePronounce)".localized())
                            Spacer()
                            //                            Text("\(typeActivity)".localized())
                            //                            Spacer() "reading".localized() + " " +
                            Text("\(readSound)".localized())
                        }
                        .font(.footnote)
                    }
                    .frame(height: 100)
                }
                .accessibilityHidden(true)
                
                
                
                Section {
                    if (indexFont==0) {
                        HStack{
                            Text("\(item)")
                                .font(.custom(monospacedFont, size: 32))
                                .accessibilityHidden(modeStudent)
                        }
                        .frame(height:60)
                    }
                    else {
                        HStack{
                            if (indexFont==1) {
                                Text("\(item)")
                                    .accessibilityHidden(modeStudent)
                                    .font(Font.custom("bartimeus6dots", size: 32))
                                    .frame(height:60)
                            } else {
                                Text("\(item)")
                                    .accessibilityHidden(modeStudent)
                                    .font(Font.custom("bartimeus8dots", size: 32))
                                    .frame(height:60)
                            }
                        }
                    }
                }
                
                //====
                TextField("", text:$input)
                    .font(.custom(monospacedFont, size: 32))
                    .foregroundColor(.blue)
                    .focused($isFocused)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .frame(height:60)
                    .onSubmit {
                        //dit is lees en tik//
                        if (input == item) ||  (!conditional) {
                            myColor =  Color.green
                            
                            if (readSound == "after") {
                                Listen()
                            }
                            
                            count += 1
                            if (count >= nrofTrys) { //nextlevel
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
                
                //====
                
                Text("\(input)")
                    .frame(height:60)
                    .font(indexFont==0 ? .custom(monospacedFont, size: 32): indexFont==1 ? Font.custom("bartimeus6dots", size: 32) : Font.custom("bartimeus8dots", size: 32))
                    .accessibilityHidden(true)
            }
            .navigationTitle("play".localized())
            .navigationBarTitleDisplayMode(.inline)
        }
        .onTapGesture(count:2) {
            self.isPlaying.toggle()
            Listen()
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
            
            if (atStartup || updateViewData) {
                if (typeActivity == "character") {
                    items = Languages[indexLanguage].method[indexMethod].lesson[indexLesson].letters.components(separatedBy: " ").shuffled()
                }
                else { //word
                    items = Languages[indexLanguage].method[indexMethod].lesson[indexLesson].words.components(separatedBy: " ").shuffled()
                }
                item=items[0]
                isFocused.toggle()
                Shuffle()
                atStartup = false
                if updateViewData { print("changeIndex=true>false")}
                updateViewData = false
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
            
            teller += 1
        }
        item = items[0]
        
        
        
        if (readSound == "before") {
            Listen()
        }
        else //nextone
        {
            AudioServicesPlaySystemSound(nextword)
        }
    }
    
    func Speak(value: String) {
        print(value)
        //        let voices = AVSpeechSynthesisVoice.speechVoices()
        let utterance = AVSpeechUtterance(string: value)
        utterance.voice = AVSpeechSynthesisVoice(language: "nl") //"nl" //voices[6]
        utterance.rate = Float(0.5)
        utterance.volume = Float(0.5)
        
        //        synthesizer.stopSpeaking(at: <#T##AVSpeechBoundary#>)
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
    
    func Listen() {
        
        Soundable.stopAll()
        if (typeActivity=="character") {
            if (item.count==1) { //alleen bij letters
                var sounds: [Sound] = []
                let sound = Sound(fileName: prefixPronounce[indexPronounce]+item+".mp3")
                sounds.append(sound)
                if (indexPronounce==3) {
                    let sound = Sound(fileName: prefixPronounce[1]+item+".mp3")
                    sounds.append(sound)
                }
                sounds.play()
                
            } else { //tricky sounds gelden voor alle pronounce child/adult/form
                let sound = Sound(fileName: item+".mp3")
                sound.play()
            }
        } else { //word
            if (syllable) {
                var sounds: [Sound] = []
                for i in item {
                    print("\(i)")
                    sounds.append(Sound(fileName: prefixPronounce[indexPronounce]+"\(i).mp3"))
                    sounds.append(Sound(fileName: "child_space.mp3"))
                    if (indexPronounce==3) {
                        print(">>")
                        let sound = Sound(fileName: prefixPronounce[1]+"\(i).mp3")
                        sounds.append(sound)
                    }
                }
                sounds.play()
            } else {
                let sound = Sound(fileName: item+".mp3")
                sound.play()
            }
        }
    }
}

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundView()
    }
}

