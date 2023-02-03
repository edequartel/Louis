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
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    @State private var isLoading = false
    @State private var downloadComplete = false
    let baseURL = "https://www.eduvip.nl/VSOdigitaal/louis/"
    
    var body: some View {
        if (isActive) && (downloadComplete) {
//        if true {
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
                    viewModel.typePronounceNew = pronouncation
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
                
                
                //download file (now checking if file is downloaded
                downloadFile(value: baseURL+"methods-demo.json")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
    
    //loading
    func loadJSON() {
        isLoading = true
        DispatchQueue.global().async {
            downloadFile(value: baseURL+"methods-demo.json")
            self.isLoading = false
        }
    }
    
    //@State private var downloadComplete = false
    //used to go to next view in SplashScreen
    func downloadFile(value : String) {
        let url = URL(string: value)!
        let filename = url.lastPathComponent
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(filename)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(url, to: destination)
            .response { response in
                if response.error == nil, let fileURL = response.fileURL {
                    print("Downloaded \(fileURL)")
                    downloadComplete = true
                } else {
                    print("Error downloading file: \(response.error!)")
                }
            }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .environmentObject(LouisViewModel())
    }
}
