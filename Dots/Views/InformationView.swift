//
//  InformationView.swift
//  Braille
//
//  Created by Eric de Quartel on 14/03/2022.
//

import SwiftUI
import ZipArchive
import Alamofire
import ProgressIndicatorView
import Soundable

struct InformationView: View {
    @Environment(\.accessibilityVoiceOverEnabled) var voEnabled: Bool
    
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.locale) private var locale
    @Environment(\.calendar) private var calendar
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    @State private var message = ""
    @State private var showProgressIndicator = true
    @State private var showActivity = false
    @State private var progress: CGFloat = 0
    
    
    var body: some View {
        Form {
            Section {
                Button("Print bundle") {
//                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                    let fileURL = documentsURL.appendingPathComponent("dutch.zip")
                    print(getDocumentDirectory().path)
                }
                .padding(10)
                
                Button("Download Dutch") {
                    self.downloadZipFile(value: "dutch")
                }
                .padding(10)
                Button("Download English") {
                    self.downloadZipFile(value: "english")
                }
                .padding(10)
                Button("Download Deutsch") {
                    self.downloadZipFile(value: "deutsch")
                }
                .padding(10)
                
                ProgressIndicatorView(isVisible: $showProgressIndicator, type: .dashBar(progress: $progress, numberOfItems: 10))
                    .frame(height: 8.0)
                    .foregroundColor(.green)
                
//                Button("Play") {
//                    Soundable.stopAll()
//                    var sounds: [Sound] = []
//                    var fileURL = getDocumentDirectory().appendingPathComponent("/dutch/words/a/aap.mp3")
//                    sounds.append(Sound(fileName: fileURL.path))
//                    fileURL = getDocumentDirectory().appendingPathComponent("/dutch/words/a/aaien.mp3")
//                    sounds.append(Sound(fileName: fileURL.path))
//                    sounds.play()
//                }
//                .padding(10)
            }
            
            
            
            
            VStack {
                Text("developedBy".localized())
                    .font(.title)
                    .foregroundColor(.bart_green)
            }
            
            Section {
                Link(destination: URL(string: "http://www.bartimeus.nl")!, label: {
                    Text("www.bartimeus.nl")
                })
                Link(destination: URL(string: "http://www.tastenbraille.com/wikilouis")!, label: {
                    Text("louisOnline".localized())
                    
                })
                Link(destination: URL(string: "https://vimeo.com/showcase/9833359")!, label: {
                    Text("instructionVideos".localized())
                })
            }
            
            Section {
                Text("helpshorttext".localized())
            }
            .font(.footnote)
            
            Section {
                Text(version())
                Text(locale.description)
                Text(voEnabled ? "Voiceover on" : "Voiceover off")
            }
            .font(.footnote)
        }
    }
    
    
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "Version \(version) build \(build)"
    }
    
    
    func downloadZipFile(value: String) {
        self.message = value
        self.progress = 0
        self.showActivity = true
        let url = URL(string: "https://www.eduvip.nl/VSOdigitaal/louis/audio/"+value+".zip")!
        print("downloading...")
        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("largeFile.zip")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        AF.download(url, to: destination)
            .downloadProgress { progress in
                self.progress = progress.fractionCompleted
            }
            .response { response in
                if response.error == nil, let fileURL = response.fileURL {
                    self.message = "\(value) downloaded successfully"
                    self.unzip(fileURL)
                    self.showActivity = false
                    
                } else {
                    self.message = "Error downloading file"
                }
            }
    }
    
    
    func unzip(_ fileURL: URL) {
        let destination = fileURL.deletingLastPathComponent()
        if SSZipArchive.unzipFile(atPath: fileURL.path, toDestination: destination.path) {
            self.message = "File unzipped successfully"
            do { //delete file after unzipping
                try FileManager.default.removeItem(at: fileURL)
                print("remove item")
            } catch {
                self.message = "Error deleting file"
            }
        } else {
            self.message = "Error unzipping file"
        }
    }
    
    func getDocumentDirectory() -> URL {
        let fileManager = FileManager.default
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
}


struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
