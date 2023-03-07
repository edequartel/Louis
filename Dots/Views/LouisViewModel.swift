//
//  PlaygroundViewModel.swift
//  Dots
//
//  Created by Eric de Quartel on 09/01/2023.
//

import Foundation
import SwiftUI
import Soundable
import AVFoundation

final class LouisViewModel: ObservableObject {
    @Published var Languages: [Item] = []
    
    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    @AppStorage("SYLLABLE") var syllable = false
    @AppStorage("INDEX_TRYS") var indexTrys = 5 // 13
    @AppStorage("INDEX_PAUSES") var indexPauses = 0
    @AppStorage("CONDITIONAL") var conditional = false
    @AppStorage("ASSIST") var assist = true
    @AppStorage("INDEX_READING") var indexPosition = 1 //before
    @AppStorage("TALK_WORD") var talkWord = false
    
    @AppStorage("ACTIVITY_TYPE") var activityTypeRawValue = 1
    var activityType: activityEnum {
            get { activityEnum(rawValue: activityTypeRawValue) ?? .character }
            set { activityTypeRawValue = newValue.rawValue }
        }
    
    @AppStorage("PRONOUNCE_TYPE") var pronounceTypeRawValue = 0
    var pronounceType: pronounceEnum {
            get { pronounceEnum(rawValue: pronounceTypeRawValue) ?? .child }
            set { pronounceTypeRawValue = newValue.rawValue }
        }
    
    @AppStorage("POSITION_TYPE") var positionTypeRawValue = 0
    var positionReadingType: positionReadingEnum {
        get { positionReadingEnum(rawValue: positionTypeRawValue) ?? .before }
            set { positionTypeRawValue = newValue.rawValue }
        }
    
    @Published var item: String = "xxx"
    @Published var previousItem: String = "previous"
    @Published var items =  ["bal","n-oo-t","m-ie-s"]
    @Published var isPlaying = false
    @Published var count = 0
    @Published var updateViewData = false
    @Published var brailleOn = true
    @Published var myColor = Color.green
    
    let synthesizer = AVSpeechSynthesizer()
    let nextword : SystemSoundID = 1113
    let failure : SystemSoundID = 1057
    
    init() {
        print("init")
        Shuffle() //??
    }
    
    //get random a new item from selected lesson
    func Shuffle() {
        
        previousItem = item
        
        while (item==items[0]) {
            let str = (activityType == .character) ? Languages[indexLanguage].method[indexMethod].lesson[indexLesson].letters : Languages[indexLanguage].method[indexMethod].lesson[indexLesson].words
//            print("before cleaning \(str)")
                items = cleanUpString(str)
//            print("after items \(items)")
        }
        item = items[0]
    }
    
    func cleanUpString(_ input: String) -> Array<String>  {
        let pattern = "\\s{2,}"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: input.utf16.count)
        let output = regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: " ")
        let outputTrimmed = output.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
        
        var filterOutput : Array<String> = []
        for word in outputTrimmed {
            if fileExists(value: stripString(value: String(word))) {
                filterOutput.append(String(word))
            }
        }
        return Array(Set(filterOutput.shuffled()))
    }

    
    func fileExists(value : String) -> Bool {
        var fn : String
        if (value.count>1) {
            fn = "/\(self.Languages[indexLanguage].zip)/words/\(value).mp3"
        } else {
            fn = "/\(self.Languages[indexLanguage].zip)/phonetic/"+pronounceType.prefixValue().lowercased()+"/"+value+".mp3"
        }
        return  fileExistsInDocumentDirectory(fn)
    }
                                        
    func fileExistsInDocumentDirectory(_ fileName: String) -> Bool {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            return FileManager.default.fileExists(atPath: fileURL.path)
        }
        return false
    }
    
    //text to speech
    func Speak(value: String) {
        print(value)
        let utterance = AVSpeechUtterance(string: value)
        utterance.voice = AVSpeechSynthesisVoice(language: "nl") //"nl" //voices[6]
        utterance.rate = Float(0.5)
        utterance.volume = Float(0.5)
        synthesizer.speak(utterance)
    }

    func getMethodeName() -> String {
        return Languages.indices.contains(indexLanguage) &&
               Languages[indexLanguage].method.indices.contains(indexMethod)
            ? Languages[indexLanguage].method[indexMethod].name
            : "unknown Method"
    }
    
    func getLessonName() -> String {
        return Languages.indices.contains(indexLanguage) &&
               Languages[indexLanguage].method.indices.contains(indexMethod) &&
               Languages[indexLanguage].method[indexMethod].lesson.indices.contains(indexLesson)
               ? Languages[indexLanguage].method[indexMethod].lesson[indexLesson].name
               : "unknown Lesson"
    }
    
    func stripString(value: String)->String {
        return value.replacingOccurrences(of: "-", with: "")
    }
    
    func addSpaces(value: String) -> String {
        return value.map { String($0) }.joined(separator: " ")
    }
    
    func check(input: String) -> Int {
        //this action, read type and enter to aknowledge
        print("check")
        var returnValue : Int = -1
        if (input == stripString(value: item)) || (!conditional) {
            print(">>>\(stripString(value: item))")
            myColor = .green
            
            if (positionReadingType == .after) {
                Talk(value: item.lowercased())
            }
            
            count += 1
            if (count >= trys[indexTrys]) { //nextlevel
                if indexLesson<(Languages[indexLanguage].method[indexMethod].lesson.count-1) {
                    returnValue = indexLesson + 1
                    
                }
                else {
                    returnValue = 0
                }
                count = 0
            }
            
            //wait untill sound is ready before shuffle
            Shuffle()
            
            if (positionReadingType == .before) {
                Talk(value : item.lowercased())
            }
            else //nextone
            {
                //                AudioServicesPlaySystemSound(nextword)
            }
        }
        else {
            if count > 0 { count -= 1 }
            AudioServicesPlaySystemSound(failure)
            returnValue = -1
            myColor = .orange
        }
        return returnValue
        
    }
    
    func getDocumentDirectory() -> URL {
        let fileManager = FileManager.default
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func getBaseDirectory() -> URL {
        let fileManager = FileManager.default
        let docDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(Languages[indexLanguage].zip)
    }
    
    func getPhoneticFile(value : String) -> URL {
        print("getPhoneticFile() \(value)")
        return getBaseDirectory().appendingPathComponent("phonetic/"+pronounceType.prefixValue().lowercased()+"/"+value+".mp3")
    }
    
    func getAudioFile(value : String) -> URL {
        return getBaseDirectory().appendingPathComponent("words/"+value.lowercased()+".mp3")
    }
    
    func TalkAgain() {
        Talk(value: item.lowercased())
    }
    
    func showString() -> String {
        print(">>\(item)")
        
        
        let syllableString = (pronounceType == .child)  && (item.components(separatedBy: "-").count != 1)  ? item.replacingOccurrences(of: "-", with: " ") : addSpaces(value: stripString(value: item))
        print("\(syllableString)")
        
        let tempString1 = syllable ? syllableString : item.replacingOccurrences(of: "-", with: "")
        
        let prevSyllableString = (pronounceType == .child) && (item.components(separatedBy: "-").count != 1) ? previousItem.replacingOccurrences(of: "-", with: " ") : addSpaces(value: stripString(value: previousItem))
        
        
        let prevtempString1 = syllable ? prevSyllableString : previousItem.replacingOccurrences(of: "-", with: "")
        
        
        return isPlaying && positionReadingType == .after ? prevtempString1 : tempString1
    }


    
    //maybe see character as a word with length 1, this function can be shorter
    func Talk(value : String) {
        print("talk() \(value)")
        print("getBaseDirectory() \(getBaseDirectory())")
        print("getDocumentDirectory() \(getDocumentDirectory())")
        Soundable.stopAll()
        isPlaying = false
        var sounds: [Sound] = []
        
        func AddSilence() {
            for _ in 0..<pauses[indexPauses] { sounds.append(Sound(url: getBaseDirectory().appendingPathComponent("words/space.mp3"))) }
        }
        
        //character
        if (activityType == .character) {
            print("character [\(value)]")
            
            
            if (value.count==1) { //only with letters, value is the text in text
                
                if let code = uniCode[value]
                {
                    let sound = Sound(url: getPhoneticFile(value: code))
                    sounds.append(sound)
                }
                else {
                    let sound = Sound(url: getPhoneticFile(value: value))
                    sounds.append(sound)
                }
                
                if (pronounceType == .meaning) {
                    let sound = Sound(url: getBaseDirectory().appendingPathComponent("phonetic/adult/"+value.lowercased()+".mp3"))
                    sounds.append(sound)
                }
                
                isPlaying = true
                sounds.play() { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    self.isPlaying = false
                }
                
            } else { //tricky sounds gelden voor alle pronounce child/adult/form, tricky sounds are ui oe eu
                let sound = Sound(fileName: value+".mp3")
                print("tricky sounds [\(value)]")
                
                isPlaying = true
                sound.play() { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    self.isPlaying = false
                }
            }
        }
        
        //word
        if (activityType == .word) {
            print("word [\(value)]")
            
            var myStringArr = value.components(separatedBy: "-") //divide the w-o-r-d in characters
            if myStringArr.count == 1 { //and if not dividing so one string
               myStringArr = value.map { String($0) }
            }
            
            let theWord = value.replacingOccurrences(of: "-", with: "") //make a word
            
            if (syllable) { //
                print("syllable")
                if ((pronounceType == .adult) || (pronounceType == .form) || (pronounceType == .meaning)) {
                    for char in theWord {
                        if ((pronounceType == .adult) || (pronounceType == .form) || (pronounceType == .meaning)) { //adult
                            sounds.append(Sound(url: getPhoneticFile(value: "\(char)")))
                            AddSilence()
                        }
                        if (pronounceType == .meaning) { //form-adult
                            sounds.append(Sound(url: getBaseDirectory().appendingPathComponent("phonetic/adult/"+char.lowercased()+".mp3")))
                            AddSilence()
                        }
                    }
                }
                
                else {//child
                    print("child")
//                    print(myStringArr)
                    for char in myStringArr {
                        sounds.append(Sound(url: getBaseDirectory().appendingPathComponent("phonetic/child/"+char.lowercased()+".mp3")))
                        AddSilence()
                    }
                }
                
                if talkWord {
                    sounds.append(Sound(url: getAudioFile(value: theWord)))
                }
                
                isPlaying = true
                sounds.play { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    self.isPlaying = false
                }
                
                
            } else { //not syllable just plays the word
                let sound = Sound(url: getAudioFile(value: theWord))
                
                isPlaying = true
                sound.play() { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    self.isPlaying = false
                }
            }
        }
    }
}

