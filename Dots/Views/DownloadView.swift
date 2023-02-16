//
//  DownloadView.swift
//  Pods
//
//  Created by Eric de Quartel on 15/02/2023.
//

import SwiftUI
import ZipArchive
import Alamofire

struct DownloadView: View {
    @EnvironmentObject var viewModel: LouisViewModel
    
    var body: some View {
        Section {
            List(viewModel.Languages, id: \.id) { language in
                ListItemView(language: language)
//                    .onLongPressGesture {
//                        print(getDocumentDirectory().path)
//                        print("deleted \(language.zip)")
//                        deleteFolderFromMainBundle(folderName: language.zip)
//                    }
            }
        }
    }
    
//    func deleteFolderFromMainBundle(folderName: String) {
//        if let folderURL = Bundle.main.url(forResource: folderName, withExtension: nil) {
//            do {
//                try FileManager.default.removeItem(at: folderURL)
//                print("Folder '\(folderName)' successfully deleted.")
//            } catch {
//                print("Error deleting folder '\(folderName)': \(error)")
//            }
//        } else {
//            print("Folder '\(folderName)' does not exist in main bundle.")
//        }
//    }
    
    func getDocumentDirectory() -> URL {
        let fileManager = FileManager.default
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}


struct ListItemView: View {
    let language : Item
    
    @State private var showProgressIndicator = true
    @State private var showActivity = false
    @State private var progress: CGFloat = 0
    @State private var message = ""
    
    var body: some View {
        HStack {
            Button(action: {
                print("download selected zipfile")
                downloadZipFile(value: language.zip)
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("\(language.name)")
                }
            }
            .disabled((progress>0) && (progress < 1)) //checkIfFolderExists(value : language.zip) ||
            Spacer()
//            if !(checkIfFolderExists(value : language.zip))
            if ((progress>0) && (progress < 1)) {
                Text("\(String(format: "%.0f", progress * 100))%")
                    .padding(.trailing)
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
}


struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView()
    }
}


//                Button("Print bundle") {
//                    print(getDocumentDirectory().path)
//                }
//                .padding(10)

