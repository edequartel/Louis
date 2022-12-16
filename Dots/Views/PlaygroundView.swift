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
    @State var previousItem = "previous"
    @State var isPlaying = false
    
    let child = 0
    let adult = 1
    let form = 2
    let form_adult = 3
    
    let CHARACTER = 0
    let WORD = 1
    
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
    @AppStorage("INDEX_PAUSES") var indexPauses = 1
    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("INDEX_BRAILLEFONT") var indexFont = 1
    @AppStorage("NROFWORDS") var nrofTrys = 3
    @AppStorage("CONDITIONAL") var conditional = true
    @AppStorage("SYLLABLE") var syllable = true
    @AppStorage("BRAILLEON") var brailleOn = false
    @AppStorage("MODESTUDENT") var modeStudent = true
    @AppStorage("TALKWORD") var talkWord = false
    @AppStorage("TYPEACTIVITY") var typeActivity = "word"
    @AppStorage("TYPEPRONOUNCE") var typePronounce = "child"
    @AppStorage("CHANGEINDEX") var updateViewData = false
    @AppStorage("READING") var readSound = "not"
    @AppStorage("MAXLENGTH") var maxLength = 3
    @AppStorage("PAUSE") var nrOfPause = 1
    
    let prefixPronounce = ["child_","adult_","form_","form_"]
    
    
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
                            Image(systemName: conditional ? "checkmark.circle": "circle")
                            //                            Spacer()
                            Image(systemName: isPlaying ? "speaker.wave.3" : "speaker")
                            Spacer()
                            if ((syllable) && (indexActivity==WORD)) || (indexActivity==CHARACTER) {
                                Text("\(typePronounce)".localized())
                                Spacer()
                            }
                            let imageSound1 = readSound=="before" ? "square.lefthalf.filled" : "square.split.2x1"
                            let imageSound2 = readSound=="after" ? "square.righthalf.filled" : imageSound1
                            Image(systemName: imageSound2)
                            Image(systemName: talkWord && syllable ? "placeholdertext.fill" : "")
                            //                                Text("\(readSound)".localized())
                        }
                        .font(.footnote)
                    }
                    .frame(height: 100)
                }
                .accessibilityHidden(true)
                
                
                
                Section {
                    let syllableString = (indexPronounce == child) ? item.replacingOccurrences(of: "-", with: " ") : addSpaces(value: stripString(value: item))
                    let tempString1 = (syllable) ? syllableString :  stripString(value: item)
                    
                    let prevSyllableString = (indexPronounce == child) ? previousItem.replacingOccurrences(of: "-", with: " ") : addSpaces(value: stripString(value: previousItem))
                    let prevtempString1 = (syllable) ? prevSyllableString :  stripString(value: previousItem)
                    
                    let  tempString = (isPlaying) && (readSound == "after") ? prevtempString1 : tempString1
                    
                    if (indexFont==0) {
                        Text("\(tempString)")
                            .font(.custom(monospacedFont, size: 32))
                            .frame(height:60)
                    }
                    else {
                        Text("\(tempString)")
                            .font(Font.custom((indexFont==1) ? "bartimeus6dots" : "bartimeus8dots", size: 32))
                            .frame(height:60)
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
                        if (input == stripString(value: item)) ||  (!conditional) {
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
                            
                            if (readSound == "before") {
                                Listen()
                            }
                            else //nextone
                            {
                                AudioServicesPlaySystemSound(nextword)
                            }
                            
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
            if (atStartup || updateViewData) {
                //
                items = (typeActivity == "character") ?  Languages[indexLanguage].method[indexMethod].lesson[indexLesson].letters.components(separatedBy: " ").shuffled() :
                Languages[indexLanguage].method[indexMethod].lesson[indexLesson].words.components(separatedBy: " ").shuffled()
                //
                item=items[0]
                isFocused.toggle()
                Shuffle()
                
                atStartup = false
                updateViewData = false
            }
            
            if (readSound == "before") {
                Listen()
            }
            else //nextone
            {
                AudioServicesPlaySystemSound(nextword)
            }
        }
    }
    
    func Shuffle() {
        print("shuffled")
        var teller = 0
        previousItem = item
        while (item==items[0]) {
            
            //
            items = (typeActivity == "character") ? Languages[indexLanguage].method[indexMethod].lesson[indexLesson].letters.components(separatedBy: " ").shuffled() :
            Languages[indexLanguage].method[indexMethod].lesson[indexLesson].words.components(separatedBy: " ").shuffled()
            //
            
            teller += 1
        }
        item = items[0]
    }
    
    func Speak(value: String) {
        print(value)
        let utterance = AVSpeechUtterance(string: value)
        utterance.voice = AVSpeechSynthesisVoice(language: "nl") //"nl" //voices[6]
        utterance.rate = Float(0.5)
        utterance.volume = Float(0.5)
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
    
    func stripString(value: String)->String {
        return value.replacingOccurrences(of: "-", with: "")
    }
    
    func addSpaces(value: String)->String{
        var temp = ""
        for char in value {
            temp.append("\(char)")
            temp.append(" ")
        }
        if temp.count>0 { temp.removeLast() }
        return temp
    }
    
    func Listen() {
        Soundable.stopAll()
        isPlaying = false
        //character
        if (typeActivity=="character") {
            if (item.count==1) { //alleen bij letters
                var sounds: [Sound] = []
                let sound = Sound(fileName: prefixPronounce[indexPronounce]+item+".mp3")
                sounds.append(sound)
                if (indexPronounce==3) {
                    let sound = Sound(fileName: prefixPronounce[1]+item+".mp3")
                    sounds.append(sound)
                }
                isPlaying.toggle()
                sounds.play() { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    print("FINISHED PLAYING")
                    isPlaying.toggle()
                }
                
            } else { //tricky sounds gelden voor alle pronounce child/adult/form
                let sound = Sound(fileName: item+".mp3")
                isPlaying.toggle()
                sound.play() { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    print("FINISHED PLAYING")
                    isPlaying.toggle()
                }
            }
        } else { //word
            let myStringArr = item.components(separatedBy: "-")
            let myString = item.replacingOccurrences(of: "-", with: "")
            if (syllable) {
                var sounds: [Sound] = []
                
                if (indexPronounce==adult) || (indexPronounce==form) || (indexPronounce==form_adult) {
                    for i in myString {
                        print(">>>\(i)")
                        if (indexPronounce==adult) { //adult
                            sounds.append(Sound(fileName: prefixPronounce[adult]+"\(i).mp3"))
                            
                            for _ in 0..<nrOfPause {
                                sounds.append(Sound(fileName: "child_space.mp3"))
                            }
                        }
                        
                        if (indexPronounce==form) { //form
                            sounds.append(Sound(fileName: prefixPronounce[form]+"\(i).mp3"))
                            for _ in 0..<nrOfPause { sounds.append(Sound(fileName: "child_space.mp3")) }
                        }
                        
                        if (indexPronounce==form_adult) { //form-adult
                            print(">>\(i)")
                            sounds.append(Sound(fileName: prefixPronounce[form]+"\(i).mp3"))
                            for _ in 0..<nrOfPause { sounds.append(Sound(fileName: "child_space.mp3")) }
                            sounds.append(Sound(fileName: prefixPronounce[adult]+"\(i).mp3"))
                            for _ in 0..<nrOfPause { sounds.append(Sound(fileName: "child_space.mp3")) }
                        }
                    }
                }
                
                
                else {//child
                    for i in myStringArr {
                        print("child - \(i)")
                        if (i.count > 1) { //just a normal phonem
                            print("normal phonem like eeu")
                            sounds.append(Sound(fileName: "\(i).mp3"))
                            for _ in 0..<nrOfPause { print("+")
                                sounds.append(Sound(fileName: "child_space.mp3")) }
                            
                        } else { //just a character
                            print("normal character like a")
                            sounds.append(Sound(fileName: prefixPronounce[child]+"\(i).mp3"))
                            for _ in 0..<nrOfPause { print("+")
                                sounds.append(Sound(fileName: "child_space.mp3")) }
                        }
                    }
                }
                
                if talkWord {
                    sounds.append(Sound(fileName: "\(myString).mp3" ))
                }
                isPlaying.toggle()
                sounds.play { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    print("FINISHED PLAYING")
                    isPlaying.toggle()
                }
                
                
            } else { //not syllable just plays
                print(">>>\(myString)")
                let sound = Sound(fileName: myString+".mp3")
                isPlaying.toggle()
                sound.play() { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    print("FINISHED PLAYING")
                    isPlaying.toggle()
                }
            }
        }
    }
}

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundView()
    }
}

