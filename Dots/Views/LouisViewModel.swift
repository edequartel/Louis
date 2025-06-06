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
import SwiftyBeaver

final class LouisViewModel: ObservableObject {
  let log = SwiftyBeaver.self

  @Published var Languages: [Item] = []


  @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
  @AppStorage("INDEX_METHOD") var indexMethod = 0
  @AppStorage("INDEX_LESSON") var indexLesson = 0
  @AppStorage("SYLLABLE") var syllable = false
  @AppStorage("INDEX_TRYS") var indexTrys = 4
  @AppStorage("INDEX_PAUSES") var indexPauses = 0
  @AppStorage("CONDITIONAL") var conditional = false
  @AppStorage("ASSIST") var assist = true
  @AppStorage("INDEX_READING") var indexPosition = 1 //before
  @AppStorage("TALK_WORD") var talkWord = false

  @AppStorage("AIACTIVE") var aiActive = false

//  @Published var apiKey = ""
  @AppStorage("APIKEY") var apiKey = ""

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

  @AppStorage("POSITION_TYPE") var positionTypeRawValue = 1
  var positionReadingType: positionReadingEnum {
    get { positionReadingEnum(rawValue: positionTypeRawValue) ?? .before }
    set { positionTypeRawValue = newValue.rawValue }
  }

  @AppStorage("CASE_CONVERSION") var selectedConversionRawValue = 0
  var conversionType: caseConversionEnum{
    get { caseConversionEnum(rawValue: selectedConversionRawValue) ?? .lowerCase}
    set { selectedConversionRawValue = newValue.rawValue }
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

  var sounds: [Sound] = []

  init() {
    log.debug("init")
    Shuffle() //??
  }

  //get random a new item from selected lesson
  func Shuffle() {
    // Guard clause: check if indexLanguage is valid
    guard Languages.indices.contains(indexLanguage) else {
      log.error("indexLanguage \(indexLanguage) is out of range for Languages array")
      return
    }

    print("---- shuffle ----")
    previousItem = item

    log.error("\(indexLanguage)")
    let str = (activityType == .character) ? getLetters() :
    getMP3Files(atPath: "\(Languages[indexLanguage].zip)/words", containingCharacters: getLetters(), minLength: 0, maxLength: 30).joined(separator: " ")
    items = cleanUpString(str)
    // Filter out the previous item from the list
    let availableItems = items.filter { $0 != previousItem }

    // If all items are the same, fallback to the original list
    let candidates = availableItems.isEmpty ? items : availableItems

    // Pick a new item at random
    item = candidates.randomElement() ?? previousItem

    log.info("Shuffle() items: \(items) item: \(item)")
    log.info("< items[0] \(items.first ?? "")")

    print("item: \(item)")
  }
  //get random a new item from selected lesson
//  func Shuffle() {
//
//    previousItem = item
//
//    log.debug("Shuffle() items: \(items) item: \(item)")
//
//    while (item==items[0]) {
//      let str = (activityType == .character) ? getLetters() :
//      getMP3Files(atPath: "\(Languages[indexLanguage].zip)/words", containingCharacters: getLetters(), minLength: 0, maxLength: 30).joined(separator: " ")
//
//
//      items = cleanUpString(str)
//
//
//      log.debug("indexLanguage \(indexLanguage)")
//      log.debug("indexMethod \(indexMethod)")
//      log.debug("indexLesson \(indexLesson)")
//      log.debug("str \(str)")
//      log.debug("items \(items)")
//      log.debug("item \(item) = \(items[0])")
//      //
//
//      // Check if the items array has at least one element
//      if items.count <= 0 {
//        // Handle the case where the items array is empty
//        log.error("error handling: there are no items")
//        break
//      }
//    }
//    item = items[0]
//  }

  func sortAndSpaceCharacters(in string: String) -> String {
    var characters = string.map { String($0) } // convert string to array of characters
    characters = Array(Set(characters)).sorted() // remove duplicates and sort characters
    let spacedString = characters.joined(separator: " ") // join characters with spaces
    return spacedString.trimmingCharacters(in: .whitespacesAndNewlines) // remove spaces at the beginning and end of the string
  }

  func getLanguageName() -> String {
    return Languages.indices.contains(indexLanguage)
    ? Languages[indexLanguage].name
    : "unknown Language"
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
  func getLetters() -> String {
    //        Languages[indexLanguage].method[indexMethod].lesson[indexLesson].letters!
    if let language = Languages.indices.contains(indexLanguage) ? Languages[indexLanguage] : nil,
       let method = language.method.indices.contains(indexMethod) ? language.method[indexMethod] : nil,
       let lesson = method.lesson.indices.contains(indexLesson) ? method.lesson[indexLesson] : nil,
       let letters = lesson.letters {
      return sortAndSpaceCharacters(in: letters)
    } else {
      // code to execute if the indexes are out of range
      return ("")
    }
  }

  func getAssistWord () -> String {
    var temp : String
    switch conversionType {
    case .lowerCase:
      temp = showString().replacingOccurrences(of: " ", with: "").lowercased()
    case .upperCase:
      temp = showString().replacingOccurrences(of: " ", with: "").uppercased()
    case .capitalisation:
      temp = showString().replacingOccurrences(of: " ", with: "").capitalized
    }
    return temp
  }

  func cleanUpString(_ input: String) -> Array<String>  {
    let pattern = "\\s{2,}"
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(location: 0, length: input.utf16.count)
    let output = regex.stringByReplacingMatches(in: input, options: [], range: range, withTemplate: " ")
    let outputTrimmed = output.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")

    var filterOutput : Array<String> = []
    for word in outputTrimmed {
      if fileExists(value: stripString(value: String(word).lowercased())) {
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
      //
      fn = "/\(self.Languages[indexLanguage].zip)/phonetic/"+pronounceType.prefixValue().lowercased()+"/"+value.lowercased()+".mp3"
      if !fileExistsInDocumentDirectory(fn) {
        if let code = uniCode[value] {
          //                    log.debug("code \(code)")
          fn = "/\(self.Languages[indexLanguage].zip)/phonetic/"+pronounceType.prefixValue().lowercased()+"/"+code+".mp3"
          log.verbose("filename \(fn)")
        }
      }
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
    log.debug("Speak "+value)
    let utterance = AVSpeechUtterance(string: value)
    utterance.voice = AVSpeechSynthesisVoice(language: "nl") //"nl" //voices[6]
    utterance.rate = Float(0.5)
    utterance.volume = Float(0.5)
    synthesizer.speak(utterance)
  }

  func stripString(value: String)->String {
    return value.replacingOccurrences(of: "-", with: "")
  }

  func addSpaces(value: String) -> String {
    return value.map { String($0) }.joined(separator: " ")
  }

  func check(input: String) -> Int {
    //this action, read type and enter to aknowledge
    log.debug("check()")
    var returnValue : Int = -1
    //        if (input == stripString(value: item)) || (!conditional) { adjusted 270323:1151
    if (input == getAssistWord()) || (!conditional) {

      log.debug("stripString() \(stripString(value: item))")
      myColor = .green

      if (positionReadingType == .after) {
        talk(value: item.lowercased())
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
        talk(value : item.lowercased())
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
    log.debug("getPhoneticFile() \(value)")
    return getBaseDirectory().appendingPathComponent("phonetic/"+pronounceType.prefixValue().lowercased()+"/"+value+".mp3")
  }

  func getAudioFile(value : String) -> URL {
    return getBaseDirectory().appendingPathComponent("words/"+value.lowercased()+".mp3")
  }

  func TalkAgain() {
    talk(value: item.lowercased())
  }

  func showString() -> String {
    log.debug("showString() \(item)")

    // Return the appropriate string based on playing and position reading mode
    let temp = isPlaying && positionReadingType == .after
    ? createShowString(item: previousItem,syllable: syllable)
    : createShowString(item: item,syllable: syllable)

    return temp
  }

  func insertSpacesAfterEachCharacter(_ string: String) -> String {
    var stringWithSpaces = ""

    for (index, char) in string.enumerated() {
      if index != string.count - 1 {
        stringWithSpaces += "\(char) "
      } else {
        stringWithSpaces += "\(char)"
      }
    }

    return stringWithSpaces
  }

  func createShowString(item: String, syllable: Bool) -> String {
    log.debug("createShowString \(item) syllable \(syllable)")
    //prepare string for casing
    var tempItem : String
    switch conversionType {
    case .lowerCase:
      tempItem = item.lowercased()
    case .upperCase:
      tempItem = item.uppercased()
    case .capitalisation:
      tempItem = item.capitalized
    }

    let separators = Languages[indexLanguage].information.components(separatedBy: " ")
    // Split the item string into an array based on the separators
    let itemSeparateArray = recursiveConcatenate(tempItem, by: separators)
    let itemSpaceArray = insertSpacesAfterEachCharacter(tempItem)
    log.debug("\t itemSeparateArray: \(itemSeparateArray)")
    log.debug("\t itemSpaceArray: \(itemSpaceArray)")


    // Convert the array into a string with spaces added between syllables
    let syllableString = (pronounceType == .child) && (itemSeparateArray.components(separatedBy: "-").count != 1)
    ? itemSeparateArray.replacingOccurrences(of: "-", with: " ") // the seperated string
    : itemSpaceArray

    log.debug("\t syllableString: \(syllableString)")
    // Create a temporary string without spaces between syllables, if syllable mode is on
    let tempString = syllable ? syllableString : tempItem

    return tempString
  }


  //maybe see character as a word with length 1, this function can be shorter
  func talk(value : String) {
    log.debug("Talk() \(value)")

    Soundable.stopAll()
    isPlaying = false
    var sounds: [Sound] = []

    func AddSilence() {
      for _ in 0..<pauses[indexPauses] { sounds.append(Sound(url: getBaseDirectory().appendingPathComponent("words/space.mp3"))) }
    }

    func playSounds() {
      log.info("playing sounds")
      isPlaying = true
      sounds.play() { error in
        if let error = error {
          self.log.error(error.localizedDescription)
        }
        self.isPlaying = false
      }
    }


    func talkaCharacter() {
      log.info("Talk() character [\(value)]")
      if (value.count==1) { //only with characters, value is the text in text
        log.debug("Characters \(value)")
        if let code = uniCode[value] {
          sounds.append(Sound(url: getPhoneticFile(value: code)))
        } else {
          sounds.append(Sound(url: getPhoneticFile(value: value)))
        }
        if pronounceType == .meaning {
          sounds.append(Sound(url: getBaseDirectory().appendingPathComponent("phonetic/adult/" + (value.lowercased()) + ".mp3")))
        }
        playSounds()

      } else { //tricky sounds gelden voor alle pronounce child/adult/form, tricky sounds are ui oe eu
        log.error("Talk() tricky sounds [\(value)]")
        sounds.append(Sound(fileName: value+".mp3"))
        playSounds()
      }
    }

    func talkaWord() {
      log.info("Talk() word [\(value)]")
      if (syllable) { //
        if ((pronounceType == .adult) || (pronounceType == .form) || (pronounceType == .meaning)) {
          for char in value {
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
          let separators = Languages[indexLanguage].information.components(separatedBy: " ")
          let separatedString = recursiveConcatenate(value, by: separators).components(separatedBy: "-")
          log.debug("separatedString: \(separatedString)")
          for item in separatedString {
            sounds.append(Sound(url: getBaseDirectory().appendingPathComponent("phonetic/child/"+item.lowercased()+".mp3")))
            AddSilence()
          }

        }
        if talkWord {
          sounds.append(Sound(url: getAudioFile(value: value)))
        }
        playSounds()
      } else { //not syllable just plays the word
        sounds.append(Sound(url: getAudioFile(value: value)))
        playSounds()
      }
    }

    //character
    if (activityType == .character) {
      talkaCharacter()

    } else
    {talkaWord()}
  }
}

