//
//  SplashScreenView.swift
//  Braille
//
//  Created by Eric de Quartel on 03/06/2022.
//

import SwiftUI
import Soundable
import Alamofire
import ZipArchive

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
    @AppStorage("ASSIST") var assist = false
    @AppStorage("INDEX_READING") var indexPosition = 1 //before
//    @AppStorage("INDEX_FONT") var indexFont = 1
    
    @State private var isActive = false
    @State private var isDownloaded = false
    @State private var audioDownloaded = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var message = ""
    @State private var progress: CGFloat = 0
    
    var body: some View {
        if (isActive) && (isDownloaded) && (audioDownloaded) {
              ContentView()
        } else {
            VStack {
                LottieView(lottieFile: "bartimeusbigb")
                    .frame(width: 150, height: 150)
//                Spacer()
                if (countVisibleSubdirectoriesInDocumentsDirectory() == 0) {
                    Text(message)
                    Text("\(String(format: "%.0f", progress * 100))%")
                }
                
            }
            .onAppear {
                print(getDocumentDirectory().path)
                audioDownloaded = (countVisibleSubdirectoriesInDocumentsDirectory() != 0)
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
                viewModel.assist = assist
                
                
                if let positionReading = positionReadingEnum(rawValue: indexPosition) {
                    viewModel.typePositionReading = positionReading
                }
                
                let sound = Sound(fileName: "perkinsping.mp3")
                sound.play()
                //
                loadData()
                //
                if (countVisibleSubdirectoriesInDocumentsDirectory() == 0) {
                    downloadZipFile(value: "dutch")
                }
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
        print("loadData from: \(dataURL)")
        if let reachability = NetworkReachabilityManager(), reachability.isReachable {
            AF.request(dataURL)
                .validate()
                .responseDecodable(of: [Item].self) { (response) in
                    switch response.result {
                    case .success(let value):
                        //
                        print("downloading was a succes")
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
                        print("downloading was a failure")
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
    
    func countVisibleSubdirectoriesInDocumentsDirectory() -> Int {
        var count = 0
        if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let contents = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
                for item in contents {
                    var isDirectory: ObjCBool = false
                    if FileManager.default.fileExists(atPath: item.path, isDirectory: &isDirectory) && isDirectory.boolValue {
                        count += 1
                    }
                }
            } catch {
                // Handle error here
            }
        }
        return count
    }

    
    func getDocumentDirectory() -> URL {
        let fileManager = FileManager.default
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func downloadZipFile(value: String) {
        self.message = "Downloading "+value
        self.progress = 0
        let url = URL(string: "https://www.eduvip.nl/VSOdigitaal/louis/audio/"+value+".zip")!
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(value+".zip")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(url, to: destination)
            .downloadProgress { progress in
                self.progress = progress.fractionCompleted
            }
            .response { response in
                if response.error == nil {
                    self.message = "\(value) downloaded successfully"
                    self.unzip(value)
                    
                } else {
                    self.message = "Error downloading file"
                }
            }
    }
    
    func unzip(_ value: String) {
        self.message = "Unzipping "+value
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(value+".zip")
        let destination = fileURL.deletingLastPathComponent()
        if SSZipArchive.unzipFile(atPath: fileURL.path, toDestination: destination.path) {
            self.message = "File unzipped successfully"
            do { //delete file after unzipping
                try FileManager.default.removeItem(at: fileURL)
                print("remove item")
                print(fileURL.absoluteString)
                audioDownloaded = true
//                folderExists = checkIfFolderExists(value: value)
            } catch {
                self.message = "Error deleting file"
            }
        } else {
            self.message = "Error unzipping file"
        }
    }
 

}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .environmentObject(LouisViewModel())
    }
}
