//
//  DownloadView.swift
//  Pods
//
//  Created by Eric de Quartel on 15/02/2023.
//

import SwiftUI
import ZipArchive
import Alamofire
import ProgressIndicatorView
import Soundable

struct DownloadView: View {
    @EnvironmentObject var viewModel: LouisViewModel
    @State private var message = ""
    @State private var showProgressIndicator = true
    @State private var showActivity = false
    @State private var progress: CGFloat = 0
    
    @State private var indexLanguage = 0
    
    
    var body: some View {
        Form {
            Section {
                List(viewModel.Languages, id: \.id) { language in
                    HStack{
                        Button(action: {
                            self.downloadZipFile(value: viewModel.Languages[indexLanguage].zip)
                        }) {
                            Image(systemName: "square.and.arrow.down")
//                            Text("Download")
                        }
//                        .padding(.leading)
                        
//                        Spacer()
//                        checkIfFolderExists(language.name)
                        Text(checkIfFolderExists(value: viewModel.Languages[indexLanguage].zip) ? "Yes" : "No")
                        
                        Text(language.name).tag(language.id)
                            .frame(maxWidth: .infinity, alignment: .leading)
//                        Spacer()
                        ProgressIndicatorView(isVisible: $showProgressIndicator, type: .circle(progress: $progress, lineWidth: 4.0, strokeColor: .green))
                            .frame(height: 2.0)
                            .foregroundColor(.red)
//                            .padding(.trailing)
                            .scaledToFit()
                    }
                }
            }
        }
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
    
    func checkIfFolderExists(value : String) -> Bool {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folderURL = documentsDirectory.appendingPathComponent(value)
        
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: folderURL.path, isDirectory: &isDirectory)
        
        return exists && isDirectory.boolValue
    }
    
    func getDocumentDirectory() -> URL {
        let fileManager = FileManager.default
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView()
    }
}

//            Section {
//                Button("Print bundle") {
//                    print(getDocumentDirectory().path)
//                }
//                .padding(10)
//            }
