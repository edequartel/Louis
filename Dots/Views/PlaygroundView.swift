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

class Network: ObservableObject {
    @EnvironmentObject var network: Network
    @Published var Languages: [Language] = []
    
    func getData() {
        guard let url = URL(string: "https://www.eduvip.nl/braillestudio-software/methodslouis_edit.json") else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedLanguages = try JSONDecoder().decode([Language].self, from: data)
                        self.Languages = decodedLanguages
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
}

struct bartStijl: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
        //  .background(Color("bartimeus"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func bartStyle() -> some View {
        modifier(bartStijl())
    }
}

struct PlaygroundView: View {
    @EnvironmentObject var network: Network
    
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
    
    @State private var myColor = Color.green
    @State private var items =  ["aa-p","n-oo-t","m-ie-s"] //<<
    @State private var item: String = ""
    @State private var input: String = ""
    @State private var doubleTap = false
    
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
//                    Text("\(network.Languages.count)") //with network
//                    Text(getMethodeName())
//                    //
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
                            if (talkWord && syllable && typeActivity=="word") {
                                Image(systemName: "placeholdertext.fill")
                            }
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
                    
                    
                    let  tempString = (isPlaying) && (!doubleTap) && (readSound == "after") ? prevtempString1 : tempString1
                    
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
                                Listen(value: item)
                            }
                            
                            count += 1
                            if (count >= nrofTrys) { //nextlevel
                                //play(sound: "nextlevel.mp3") //?
                                if indexLesson<(network.Languages[indexLanguage].method[indexMethod].lesson.count-1) {
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
                                Listen(value : item)
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
            doubleTap = true
            Listen(value : item)
            print("\(previousItem)")
            print("\(item)")
        }
        .onAppear() {
            network.getData() //this is asynchronous
            //
            if (atStartup || updateViewData) {
                //
                
                //
                if !network.Languages.isEmpty{
                    print("Languages not empty")
                    items = (typeActivity == "character") ?  network.Languages[indexLanguage].method[indexMethod].lesson[indexLesson].letters.components(separatedBy: " ").shuffled() :
                    network.Languages[indexLanguage].method[indexMethod].lesson[indexLesson].words.components(separatedBy: " ").shuffled()
                    item=items[0]
                    //
                }
                item=items[0]
                //
                isFocused.toggle()
                Shuffle()
                
                atStartup = false
                updateViewData = false
            }
            
            if (readSound == "before") {
                Listen(value : item)
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
            print("xxx")
            //
            if (!network.Languages.isEmpty) {
                items = (typeActivity == "character") ? network.Languages[indexLanguage].method[indexMethod].lesson[indexLesson].letters.components(separatedBy: " ").shuffled() :
                network.Languages[indexLanguage].method[indexMethod].lesson[indexLesson].words.components(separatedBy: " ").shuffled()
                //
            } else { items.shuffle() }
            
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
        if !network.Languages.isEmpty {
            return network.Languages[indexLanguage].method[indexMethod].lesson[indexLesson].name
        }
        else {
            return "unknown Lesson"
        }
    }
    
    func getMethodeName()->String {
        if !network.Languages.isEmpty {
            return network.Languages[indexLanguage].method[indexMethod].name
        } else {
            return "unknown Method"
        }
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
    
    //?wellicht character als een word zien met een lengte van 1, dan kan deze fuctie korter
    func Listen(value : String) {
        Soundable.stopAll()
        isPlaying = false
        //character
        if (typeActivity=="character") {
            if (value.count==1) { //alleen bij letters
                var sounds: [Sound] = []
                let sound = Sound(fileName: prefixPronounce[indexPronounce]+value+".mp3")
                sounds.append(sound)
                if (indexPronounce==3) {
                    let sound = Sound(fileName: prefixPronounce[1]+value+".mp3")
                    sounds.append(sound)
                }
                isPlaying = true
                sounds.play() { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    isPlaying = false
                    doubleTap = false
                }
                
            } else { //tricky sounds gelden voor alle pronounce child/adult/form
                let sound = Sound(fileName: value+".mp3")
                isPlaying = true
                sound.play() { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    isPlaying = false
                    doubleTap = false
                }
            }
        } else { //word
            let myStringArr = value.components(separatedBy: "-")
            let myString = value.replacingOccurrences(of: "-", with: "")
            if (syllable) {
                var sounds: [Sound] = []
                
                if (indexPronounce==adult) || (indexPronounce==form) || (indexPronounce==form_adult) {
                    for i in myString {
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
                
                //sounds.append(Sound(fileName: "perkinspingdoorvoer.mp3"))
                
                isPlaying = true
                sounds.play { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    isPlaying = false
                    doubleTap = false
                }
                
                
            } else { //not syllable just plays
                print(">>>\(myString)")
                let sound = Sound(fileName: myString+".mp3")
                isPlaying = true
                sound.play() { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    isPlaying = false
                    doubleTap = false
                }
            }
        }
    }
}

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        PlaygroundView()
            .environmentObject(Network())
    }
}

