//
//  PlaygroundViewModel.swift
//  Dots
//
//  Created by Eric de Quartel on 09/01/2023.
//

import Foundation
import Soundable
import AVFoundation

final class LouisViewModel: ObservableObject {
    @Published var indexLanguage: Int = 0
    @Published var indexMethod: Int = 0
    @Published var indexLesson: Int = 0
    
    @Published var item: String = "bartimeus"
    @Published var previousItem: String = "previous"
    @Published var items =  ["bartimeus","n-oo-t","m-ie-s"]
    @Published var Languages: [Language] = Language.Language

    @Published var indexTrys = 0
    @Published var indexPauses = 0
    @Published var syllable = true
    @Published var talkWord = false
    @Published var nrOfPause = 1
    @Published var conditional = false
    @Published var indexReading = 0
    @Published var indexPronounce = 0
    
    @Published var typeActivity : activityEnum = .character
    @Published var typePronounceNew : pronounceEnum = .child
    @Published var typePositionReading : positionReadingEnum = .not
    @Published var typeIndexFont : fontEnum = .dots8
    
    @Published var isPlaying = false

    @Published var count = 0

    @Published var doubleTap = false
    @Published var updateViewData = false
    @Published var brailleOn = true

    let synthesizer = AVSpeechSynthesizer()
    let nextword : SystemSoundID = 1113
    let failure : SystemSoundID = 1057
    
    
    //get random a new item from selected lesson
    func Shuffle() {
        var teller = 0
        previousItem = item
        while (item==items[0]) {
            if (!Languages.isEmpty) {
                items = (typeActivity == .character) ? Languages[indexLanguage].method[indexMethod].lesson[indexLesson].letters.components(separatedBy: " ").shuffled() :
                Languages[indexLanguage].method[indexMethod].lesson[indexLesson].words.components(separatedBy: " ").shuffled()
            } else { items.shuffle() }
            teller += 1
        }
        item = items[0]
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
        if (input == stripString(value: item)) || (!conditional) {
            if (typePositionReading == .after) {
                Talk(value: item)
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
                Talk(value : item)
            }
            else //nextone
            {
                AudioServicesPlaySystemSound(nextword)
            }
        }
        else {
            if count > 0 { count -= 1 }
            AudioServicesPlaySystemSound(failure)
            returnValue = -1
        }
        return returnValue
    }

    func TalkAgain() {
        Talk(value: item)
    }

    //maybe see character as a word with length 1, this function can be shorter
    func Talk(value : String) {
        Soundable.stopAll()
        isPlaying = false
        var sounds: [Sound] = []
        
        func AddSilence() {
            for _ in 0..<nrOfPause { sounds.append(Sound(fileName: "child_space.mp3")) }
        }
        
        //character
        if (typeActivity == .character) {
            print("character [\(value)]")
        
            
            if (value.count==1) { //only with letters
                
                if let code = uniCode[value]
                {
                    let sound = Sound(fileName: code + ".mp3")
                    sounds.append(sound)
                }
                else {
                    let sound = Sound(fileName: typePronounceNew.prefixValue() + value.lowercased() + ".mp3")
                    sounds.append(sound)
                }
                
                
                if (typePronounceNew == .meaning) {
                    let sound = Sound(fileName: "adult_" + value + ".mp3")
                    sounds.append(sound)
                }
                isPlaying = true
                sounds.play() { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    self.isPlaying = false
                }
                
            } else { //tricky sounds gelden voor alle pronounce child/adult/form
                let sound = Sound(fileName: value+".mp3")
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
            let myStringArr = value.components(separatedBy: "-")
            let myString = value.replacingOccurrences(of: "-", with: "")
            
            if (syllable) {
                if (typePronounceNew == .adult) || (typePronounceNew == .form) || (typePronounceNew == .meaning) {
                    for i in myString {
                        if (typePronounceNew == .adult) { //adult
                            sounds.append(Sound(fileName: typePronounceNew.prefixValue()+"\(i).mp3"))
                            AddSilence()
                        }
                        
                        if (typePronounceNew == .form) { //form
                            sounds.append(Sound(fileName: typePronounceNew.prefixValue()+"\(i).mp3"))
                            AddSilence()
                        }
                        
                        if (typePronounceNew == .meaning) { //form-adult
                            let preOne : pronounceEnum = .adult
                            sounds.append(Sound(fileName: preOne.prefixValue()+"\(i).mp3"))
                            AddSilence()
                            
                            let preSecond : pronounceEnum = .meaning
                            sounds.append(Sound(fileName: preSecond.prefixValue()+"\(i).mp3"))
                            AddSilence()
                        }
                    }
                }
                
                
                else {//child
                    for i in myStringArr {
                        if (i.count > 1) { //just a normal phonem
                            sounds.append(Sound(fileName: "\(i).mp3"))
                            AddSilence()
                            
                        } else { //just a character
                            let pronounceAsChild : pronounceEnum = .child
                            sounds.append(Sound(fileName: pronounceAsChild.prefixValue() + "\(i).mp3"))
                            AddSilence()
                        }
                    }
                }
                
                if talkWord {
                    sounds.append(Sound(fileName: "\(myString).mp3" ))
                }
                
                isPlaying = true
                sounds.play { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    self.isPlaying = false
                }
                
                
            } else { //not syllable just plays
                let sound = Sound(fileName: myString+".mp3")
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
