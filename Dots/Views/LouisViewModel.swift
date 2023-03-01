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
    
    @Published var indexLanguage: Int = 0
    @Published var indexMethod: Int = 0
    @Published var indexLesson: Int = 0
    
    @Published var item: String = "xxx"
    @Published var previousItem: String = "previous"
    @Published var items =  ["bal","n-oo-t","m-ie-s"]
    
    @Published var indexTrys = 0
    @Published var indexPauses = 0
    @Published var syllable = true
    @Published var talkWord = false
    @Published var conditional = false
    @Published var assist = true
    @Published var indexReading = 0
    @Published var indexPronounce = 0
    
    @Published var typeActivity : activityEnum = .character
    @Published var typePronounce : pronounceEnum = .child
    @Published var typePositionReading : positionReadingEnum = .not
//    @Published var typeIndexFont : fontEnum = .dots8
    
    @Published var isPlaying = false
    
    @Published var count = 0
    
    @Published var doubleTap = false
    @Published var updateViewData = false
    @Published var brailleOn = true
    
    @Published var myColor = Color.green
    
    
    let synthesizer = AVSpeechSynthesizer()
    let nextword : SystemSoundID = 1113
    let failure : SystemSoundID = 1057
    
    init() {
        print("init")
    }
    
    //get random a new item from selected lesson
    func Shuffle() {
        
        previousItem = item
        

        while (item==items[0]) {
                let str = (typeActivity == .character) ? Languages[indexLanguage].method[indexMethod].lesson[indexLesson].letters : Languages[indexLanguage].method[indexMethod].lesson[indexLesson].words
            print("before cleaning \(str)")
                items = cleanUpString(str)
            print("after items \(items)")
        }
        item = items[0]
    }
    
    func cleanUpString(_ input: String) -> Array<String>  {
        let pattern = "\\s{2,}"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: input.utf16.count)
        let output = regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: " ")
        
        
        let stripOutput = stripString(value: output.trimmingCharacters(in: .whitespacesAndNewlines)).components(separatedBy: " ") //nice seperated string
        
        var filterOutput : Array<String> = []
        for word in stripOutput {
            if fileExists(value: String(word)) {
                filterOutput.append(String(word))
            }
        }
        return Array(Set(filterOutput.shuffled())) //filterOutput.shuffled()
    }

    
    
    
    func fileExists(value : String) -> Bool {
        var fn : String
        print("value \(value)")
        if (value.count>1) {
            fn = "/\(self.Languages[indexLanguage].zip)/words/\(value).mp3"
        } else {
            fn = "/\(self.Languages[indexLanguage].zip)/phonetic/"+typePronounce.prefixValue().lowercased()+"/"+value+".mp3"
        }
        print(fn)
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
    
    func getLanguageName()->String {
        if !Languages.isEmpty {
            return Languages[indexLanguage].name
        }
        else {
            return "unknown Language"
        }
    }
    
    func getMethodeName()->String {
        if !Languages.isEmpty {
            return Languages[indexLanguage].method[indexMethod].name
        } else {
            return "unknown Method"
        }
    }
    
    func getLessonName()->String {
        if !Languages.isEmpty {
            return Languages[indexLanguage].method[indexMethod].lesson[indexLesson].name
        }
        else {
            return "unknown Lesson"
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
    
    func check(input: String) -> Int {
        //this action, read type and enter to aknowledge
        var returnValue : Int = -1
        if (input == stripString(value: item)) || (!self.conditional) {
            myColor = .green
            
            if (typePositionReading == .after) {
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
            
            if (typePositionReading == .before) {
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
        return getBaseDirectory().appendingPathComponent("phonetic/"+typePronounce.prefixValue().lowercased()+"/"+value+".mp3")
    }
    
    func getAudioFile(value : String) -> URL {
        return getBaseDirectory().appendingPathComponent("words/"+value.lowercased()+".mp3")
    }
    
    func TalkAgain() {
        Talk(value: item.lowercased())
    }
    
    func showString() -> String {
        let syllableString = (typePronounce == .child) ? item.replacingOccurrences(of: "-", with: " ") : addSpaces(value: stripString(value: item))
        let tempString1 = (syllable) ? syllableString :  stripString(value: item)
        
        let prevSyllableString = (typePronounce == .child) ? previousItem.replacingOccurrences(of: "-", with: " ") : addSpaces(value: stripString(value: previousItem))
        let prevtempString1 = (syllable) ? prevSyllableString :  stripString(value: previousItem)
        
       return (isPlaying) && (!doubleTap) && (typePositionReading == .after) ? prevtempString1 : tempString1
    }
    
    //maybe see character as a word with length 1, this function can be shorter
    func Talk(value : String) {
        Soundable.stopAll()
        isPlaying = false
        var sounds: [Sound] = []
        
        func AddSilence() {
            for _ in 0..<pauses[indexPauses] { sounds.append(Sound(url: getBaseDirectory().appendingPathComponent("words/space.mp3"))) }
        }
        
        //character
        if (typeActivity == .character) {
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
                
                if (typePronounce == .meaning) {
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
        if (typeActivity == .word) {
            print("word [\(value)]")
            
            let myStringArr = value.components(separatedBy: "-") //divide the w-o-r-d in characters
            let theWord = value.replacingOccurrences(of: "-", with: "") //make a word
            
            if (syllable) { //
                if ((typePronounce == .adult) || (typePronounce == .form) || (typePronounce == .meaning)) {
                    for char in theWord {
                        if ((typePronounce == .adult) || (typePronounce == .form) || (typePronounce == .meaning)) { //adult
                            sounds.append(Sound(url: getPhoneticFile(value: "\(char)")))
                            AddSilence()
                        }
                        if (typePronounce == .meaning) { //form-adult
                            sounds.append(Sound(url: getBaseDirectory().appendingPathComponent("phonetic/adult/"+char.lowercased()+".mp3")))
                            AddSilence()
                        }
                    }
                }
                
                else {//child
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

