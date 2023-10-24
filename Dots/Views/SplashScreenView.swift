//
//  SplashScreenView.swift
//  Braille
//
//  Created by Eric de Quartel on 03/06/2022.
//


//let player = AudioPlayer()
//let audioItem = DefaultAudioItem(audioUrl: "someUrl", sourceType: .stream)
//player.load(item: audioItem, playWhenReady: true) // Load the item and start playing when the player is ready.

import SwiftUI
import Soundable
import Alamofire
import ZipArchive
import SwiftyBeaver

struct SplashScreenView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var viewModel: LouisViewModel
    let log = SwiftyBeaver.self
    @Environment(\.locale) private var locale
    
    let dataURL = "https://www.eduvip.nl/VSOdigitaal/louis/methods-demo.json"
    // let dataURL = "https://raw.githubusercontent.com/edequartel/braillemethods/main/Documents/methods-demo.json"
    
    //    @State private var errorMessage: String?
    @State private var isActive = false
    @State private var isDownloaded = false
    @State private var audioDownloaded = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    //    @State private var message = ""
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
                    Text("\(String(format: "%.0f", progress * 100))%")
                }
                
            }
            .onAppear {
                print(getDocumentDirectory().path)
                audioDownloaded = (countVisibleSubdirectoriesInDocumentsDirectory() != 0)
                if (audioDownloaded) { log.verbose("audioDownloaded != 0") }
                
                
                let sound = Sound(fileName: "perkinsping.mp3")
                sound.play()
                //
                loadData()
                //
                if (countVisibleSubdirectoriesInDocumentsDirectory() == 0) {
                    if (locale.languageCode == "nl") {
                        downloadZipFile(value: "dutch")
                        viewModel.indexLanguage = 0
                    }
                    else {
                        downloadZipFile(value: "english")
                        viewModel.indexLanguage = 1
                    }
                }
                
                //
//                viewModel.indexLanguage = 0
//                viewModel.indexMethod = 0
//                viewModel.indexLesson = 0
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
        log.debug("loadData from: \(dataURL)")
        if let reachability = NetworkReachabilityManager(), reachability.isReachable {
            AF.request(dataURL)
                .validate()
                .responseDecodable(of: [Item].self) { (response) in
                    switch response.result {
                    case .success(let value):
                        //
                        log.debug("downloading was a succes")
                        let encoder = JSONEncoder()
                        do {
                            let data = try encoder.encode(value)
                            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                            let fileURL = documentsDirectory.appendingPathComponent("data.json")
                            try data.write(to: fileURL)
                            log.debug("file writing")
                            self.loadLocalData()
                        } catch {
                            self.log.error(error.localizedDescription)
                        }
                        
                        //
                        viewModel.Languages = value
                        
                    case .failure(let error):
                        log.error("downloading was a failure")
                        self.log.error(error.localizedDescription)
                    }
                }
        } else {
            loadLocalData()
        }
    }
    
    //data which is download and earlier saved as data.json is used when there is now connection
    func loadLocalData() {
        log.debug("loadLocalData")
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentsDirectory.appendingPathComponent("data.json")
            let data = try Data(contentsOf: fileURL)
            let items = try JSONDecoder().decode([Item].self, from: data)
            viewModel.Languages = items
            isDownloaded = true
            log.debug("isDownloaded")
        }
        catch {
            self.log.error(error.localizedDescription)
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
        log.debug("downloadZipFile() \(value)")
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
                    log.debug("\(value) downloaded successfully")
                    self.unzip(value)
                    
                } else {
                    log.error("Error downloading file")
                }
            }
    }
    
    func unzip(_ value: String) {
        log.debug("unzip() \(value)")
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(value+".zip")
        let destination = fileURL.deletingLastPathComponent()
        if SSZipArchive.unzipFile(atPath: fileURL.path, toDestination: destination.path) {
            log.error("File unzipped successfully")
            do { //delete file after unzipping
                try FileManager.default.removeItem(at: fileURL)
                log.debug("remove item")
                log.debug(fileURL.absoluteString)
                audioDownloaded = true
                //                folderExists = checkIfFolderExists(value: value)
            } catch {
                log.error("Error deleting file")
            }
        } else {
            log.error("Error unzipping file")
        }
    }
    
    
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .environmentObject(LouisViewModel())
    }
}
