//
//  PlaygroundViewModel.swift
//  Dots
//
//  Created by Eric de Quartel on 09/01/2023.
//

import Foundation
import Soundable
import AVFoundation

final class PlaygroundViewModel: ObservableObject {
    @Published var item: String = ""
    @Published var previousItem: String = "previous"
    @Published var items =  ["aa-p","n-oo-t","m-ie-s"]
    @Published var Languages: [Language] = Language.Language

    @Published var indexWords = 0
    @Published var indexPauses = 0
    @Published var syllable = true
    @Published var talkWord = false
    @Published var nrOfPause = 1
    @Published var conditional = false
    @Published var indexReading = 0
    @Published var indexFont = 1
    
    @Published var typeActivity = "character"
    @Published var isPlaying = false
    @Published var indexPronounce = 0
    
    @Published var count = 0
    @Published var nrofTrys = 5 
    @Published var typePronounce = "child"
    @Published var doubleTap = false
    @Published var readSound = "before"

    @Published var updateViewData = false
//    @Published var changeIndex = false
    @Published var brailleOn = true

    let synthesizer = AVSpeechSynthesizer()
    let nextword : SystemSoundID = 1113
    let failure : SystemSoundID = 1057
    
    let prefixPronounce = ["child_","adult_","form_","form_"]
    
    let child = 0
    let adult = 1
    let form = 2
    let form_adult = 3
    
    func Shuffle(indexLanguage: Int, indexMethod: Int, indexLesson: Int) {
        var teller = 0
        previousItem = item
        print("==========>>>>\(typeActivity)")
        while (item==items[0]) {
            if (!Languages.isEmpty) {
                items = (typeActivity == "character") ? Languages[indexLanguage].method[indexMethod].lesson[indexLesson].letters.components(separatedBy: " ").shuffled() :
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
    
    func getLessonName(indexLanguage: Int, indexMethod: Int, indexLesson: Int)->String {
        if !Languages.isEmpty {
            return Languages[indexLanguage].method[indexMethod].lesson[indexLesson].name
        }
        else {
            return "unknown Lesson"
        }
    }
    
    func getMethodeName(indexLanguage: Int, indexMethod: Int)->String {
        if !Languages.isEmpty {
            return Languages[indexLanguage].method[indexMethod].name
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
    
    func check(input: String, indexLanguage: Int, indexMethod: Int, indexLesson: Int) -> Int {
        //this action, read type and enter to aknowledge
        var returnValue : Int = -1
        if (input == stripString(value: item)) || (!conditional) {
            if (readSound == "after") {
                Listen(value: item)
            }

            count += 1
            if (count >= nrofTrys) { //nextlevel
                if indexLesson<(Languages[indexLanguage].method[indexMethod].lesson.count-1) {
                    returnValue = indexLesson + 1
                }
                else {
                    returnValue = 0
                }
                count = 0
            }

            //wait untill sound is ready before shuffle
            Shuffle(indexLanguage: indexLanguage, indexMethod: indexMethod, indexLesson: indexLesson)

            if (readSound == "before") {
                Listen(value : item)
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

    //maybe see character as a word with lengtb 1, this function can be shorter
    func Listen(value : String) {
        Soundable.stopAll()
        isPlaying = false
        //character
        print(">>>>\(typeActivity)")
        if (typeActivity=="character") {
            if (value.count==1) { //only with letters
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
                    self.isPlaying = false
                }
                
            } else { //tricky sounds gelden voor alle pronounce child/adult/form
                print("---\(typeActivity)")
                let sound = Sound(fileName: value+".mp3")
                isPlaying = true
                sound.play() { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    self.isPlaying = false
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
                
                isPlaying = true
                sounds.play { error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    self.isPlaying = false
                }
                
                
            } else { //not syllable just plays
                print(">>>\(myString)")
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
