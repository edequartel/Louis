//
//  SplashScreenView.swift
//  Braille
//
//  Created by Eric de Quartel on 03/06/2022.
//

import SwiftUI
import Soundable
import Alamofire

struct SplashScreenView: View {
    @EnvironmentObject var viewModel: LouisViewModel
    let dataURL = "https://www.eduvip.nl/VSOdigitaal/louis/methods-demo.json"
    @State private var errorMessage: String?
    
    @AppStorage("INDEX_LANGUAGE") var indexLanguage = 0
    @AppStorage("INDEX_METHOD") var indexMethod = 0
    @AppStorage("INDEX_LESSON") var indexLesson = 0
    
    @AppStorage("INDEX_ACTIVITY") var indexActivity = 0
    @AppStorage("SYLLABLE") var syllable = false
    @AppStorage("TALK_WORD") var talkWord = false
    @AppStorage("INDEX_PRONOUNCE") var indexPronounce = 0 //child
    @AppStorage("INDEX_TRYS") var indexTrys = 5 // 13
    @AppStorage("INDEX_PAUSES") var indexPauses = 0
    @AppStorage("CONDITIONAL") var conditional = true
    @AppStorage("INDEX_READING") var indexPosition = 1 //before
    @AppStorage("INDEX_FONT") var indexFont = 1
    
    @State private var isActive = false
    @State private var isDownloaded = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if (isActive) && (isDownloaded) {
            ContentView()
        } else {
            VStack {
                LottieView(lottieFile: "bartimeusbigb")
                    .frame(width: 150, height: 150)
            }
            .onAppear {
                viewModel.indexLanguage = indexLanguage
                viewModel.indexMethod = indexMethod
                viewModel.indexLesson = indexLesson
                viewModel.conditional = conditional
 
                
                if let activity = activityEnum(rawValue: indexActivity) {
                    viewModel.typeActivity = activity
                }
                
                viewModel.syllable = syllable
                viewModel.talkWord = talkWord
                viewModel.indexPauses = indexPauses
                
                if let pronouncation = pronounceEnum(rawValue: indexPronounce) {
                    viewModel.typePronounce = pronouncation
                }
                
                viewModel.indexTrys = indexTrys
                viewModel.conditional = conditional
                
                
                if let positionReading = positionReadingEnum(rawValue: indexPosition) {
                    viewModel.typePositionReading = positionReading
                }
                
                if let font = fontEnum(rawValue: indexFont) {
                    viewModel.typeIndexFont = font
                }
                
                let sound = Sound(fileName: "perkinsping.mp3")
                sound.play()
                //
                loadData()
                //
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
    
    
    //data is downloaded from url and then save as data.json
    func loadData() {
        print("loadData")
        print("\(dataURL)")
        if let reachability = NetworkReachabilityManager(), reachability.isReachable {
            AF.request(dataURL)
                .validate()
                .responseDecodable(of: [Item].self) { (response) in
                    switch response.result {
                    case .success(let value):
                        //
                        let encoder = JSONEncoder()
                        do {
                            let data = try encoder.encode(value)
                            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                            let fileURL = documentsDirectory.appendingPathComponent("data.json")
                            try data.write(to: fileURL)
                            self.loadLocalData()
                        } catch {
                            self.errorMessage = error.localizedDescription
                        }
                        
                        //
                        viewModel.Languages = value
                        self.errorMessage = nil
                        
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
        } else {
            loadLocalData()
        }
    }
    
    //data which is download and earlier saved as data.json is used when there is now connection
    func loadLocalData() {
        print("loadLocalData")
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentsDirectory.appendingPathComponent("data.json")
            let data = try Data(contentsOf: fileURL)
            let items = try JSONDecoder().decode([Item].self, from: data)
            viewModel.Languages = items
            isDownloaded = true
        }
        catch {
            self.errorMessage = error.localizedDescription
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .environmentObject(LouisViewModel())
    }
}
