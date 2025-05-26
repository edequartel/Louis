//
//  SettingsView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI
import SwiftyBeaver
import SwiftAudioEx


struct SettingsView: View {
  @EnvironmentObject var viewModel: LouisViewModel
  let log = SwiftyBeaver.self

  var body: some View {
    NavigationView {
      Form {
        overviewMethodsView()
        overviewActivityView()
        overviewGeneralView()
        resetModelView()
      }
      .navigationBarTitle(Text("settings".localized()), displayMode: .inline)
      .navigationBarItems(trailing:
                            NavigationLink(destination: DownloadView()) {
        Image(systemName: "square.and.arrow.down")
          .accessibilityLabel("download".localized())
      })
    }
  }
}


struct overviewMethodsView : View {
  @EnvironmentObject var viewModel: LouisViewModel
  let log = SwiftyBeaver.self
  let maxHeight: CGFloat = 100
  
  var body: some View {
    Section {
      Picker("Language".localized(), selection: $viewModel.indexLanguage) {
        ForEach(viewModel.Languages, id: \.id) { language in
          if (checkIfFolderExists(value: language.zip)) {
            Text(language.name.localized()).tag(language.id)
              .lineLimit(1)
              .truncationMode(.tail)
          }
        }
      }
      .onChange(of: viewModel.indexLanguage) { //tag in
        viewModel.indexMethod = 0
        viewModel.indexLesson = 0
        viewModel.count = 0
        viewModel.updateViewData = true
      }
      
      Picker("method".localized(), selection: $viewModel.indexMethod) {
        ForEach(viewModel.Languages[viewModel.indexLanguage].method, id: \.id) { method in
          Text(method.name).tag(method.id)
        }
      }
      .frame(height: 40)
      .onChange(of: viewModel.indexMethod) { //tag in
        viewModel.indexLesson = 0
        viewModel.count = 0
        viewModel.updateViewData = true
      }
      
      //
      if let language = viewModel.Languages[safe: viewModel.indexLanguage],
         let method = language.method[safe: viewModel.indexMethod]
      {
        Picker("lesson".localized(), selection: $viewModel.indexLesson) {
          ForEach(method.lesson, id: \.id) { lesson in
            Text(lesson.name).tag(lesson.id)
          }
        }
        .onChange(of: viewModel.indexLesson) { //tag in
          viewModel.updateViewData = true
          viewModel.count = 0
        }
      } else {
        Text("No lessons available").foregroundColor(.red)
      }
      //
      
      
      //
      Text(viewModel.getLetters())
        .frame(maxHeight: maxHeight)
        .fixedSize(horizontal: false, vertical: true)
        .font(.footnote)
        .foregroundColor(.bart_green)
      
      //
      if (viewModel.activityType == .word) {
        Text(getMP3Files(atPath: "\(viewModel.Languages[viewModel.indexLanguage].zip)/words",
                         containingCharacters: viewModel.getLetters(),
                         minLength: 0,
                         maxLength: 30)
          .joined(separator: " ")
        )
        .frame(maxHeight: maxHeight)
        .fixedSize(horizontal: false, vertical: true)
        .font(.footnote)
        .foregroundColor(.gray)
      }
    }
  }
  
  func checkIfFolderExists(value : String) -> Bool {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let folderURL = documentsDirectory.appendingPathComponent(value)
    
    var isDirectory: ObjCBool = false
    let exists = FileManager.default.fileExists(atPath: folderURL.path, isDirectory: &isDirectory)
    
    return exists && isDirectory.boolValue
  }
}


struct overviewActivityView : View {
  @EnvironmentObject var viewModel: LouisViewModel
  
  var body: some View {
    Section {
      Picker("activity".localized(), selection: $viewModel.activityType) {
        ForEach(activityEnum.allCases, id: \.self) { activityType in
          Text(activityType.stringValue().localized()).tag(activityType)
        }
      }
      .onChange(of: viewModel.activityType) { //tag in
        viewModel.updateViewData = true
        if viewModel.activityType == .character {
          viewModel.conversionType = .lowerCase
        }
      }
      
      if (viewModel.activityType == .word) {
        Toggle("chop".localized(), isOn: $viewModel.syllable)
      }
      
      if (viewModel.syllable) && (viewModel.activityType == .word) {
        Toggle("talkword".localized(), isOn: $viewModel.talkWord)
      }
      
      if (viewModel.syllable) && (viewModel.activityType == .word) {
        Picker("pause".localized(),selection: $viewModel.indexPauses) {
          ForEach(0 ..< pauses.count, id: \.self) {
            Text("\(pauses[$0]) sec").tag($0)
          }
        }
      }
      
      if ((viewModel.syllable) && (viewModel.activityType == .word)) || (viewModel.activityType == .character) {
        Picker("pronouncation".localized(), selection: $viewModel.pronounceType) {
          ForEach(pronounceEnum.allCases, id: \.self) { pronounceType in
            Text(pronounceType.stringValue().localized())//.tag(pronounceType)
          }
        }
      }
    }
  }
}

struct overviewGeneralView : View {
  @EnvironmentObject var viewModel: LouisViewModel
  
  var body: some View {
    Section{
      Picker("nroftrys".localized(), selection: $viewModel.indexTrys) {
        ForEach(0 ..< trys.count, id: \.self) {
          Text(trys[$0] != 999 ? "\(trys[$0])" : "∞").tag($0)
        }
      }
      .onChange(of: viewModel.indexTrys) { //tag in
        //print("change in nrofWords \(trys[tag])")
        viewModel.count = 0
      }
      
      Toggle("conditional".localized(), isOn: $viewModel.conditional)
      
      Toggle("assist".localized(), isOn: $viewModel.assist)
      
      Picker("reading".localized(), selection: $viewModel.positionReadingType) {
        ForEach(positionReadingEnum.allCases, id: \.self) { positionReadingType in
          Text(positionReadingType.stringValue().localized())//.tag(pronounceType)
        }
      }
      
      Picker("caseconversion", selection: $viewModel.conversionType) {
        if (viewModel.activityType == .character) {
          ForEach(caseConversionEnum.allCases.prefix(2), id: \.self) { conversionType in
            Text(conversionType.stringValue().localized().prefix(1))
          }
        } else {
          ForEach(caseConversionEnum.allCases, id: \.self) { conversionType in
            Text(conversionType.stringValue().localized())
          }
        }
      }
      .pickerStyle(SegmentedPickerStyle())
    }
  }
}

struct resetModelView : View {
  @EnvironmentObject var viewModel: LouisViewModel
  
  var body: some View {
    Section{
      Button {
        reset()
      } label : {
        Text("reset".localized())
      }

//      Toggle("AI".localized(), isOn: $viewModel.aiActive)
//
//      TextField("API Key", text: $viewModel.apiKey)
//        .foregroundColor(.red)
    }
  }
  
  func reset() {
    viewModel.indexLanguage = 0
    viewModel.indexMethod = 0
    viewModel.indexLesson = 0
    viewModel.activityType = .word
    viewModel.syllable = false
    viewModel.pronounceType = .child
    viewModel.indexTrys = 4
    viewModel.indexPauses = 0
    viewModel.conditional = false
    viewModel.assist = true
    viewModel.positionReadingType = .before
    viewModel.count = 0
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
      .environmentObject(LouisViewModel())
  }
}

