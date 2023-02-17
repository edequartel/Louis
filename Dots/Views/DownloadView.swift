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
            }
        }
    }
    
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
    @State private var folderExists = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    print("download selected zipfile")
                    print(getDocumentDirectory().path)
                    downloadZipFile(value: language.zip)
                    folderExists = checkIfFolderExists(value: language.name) //<<<<<<
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
                
                //
            }
            .foregroundColor(checkIfFolderExists(value : language.zip) ? .bart_green : .red)
            
            
            if (checkIfFolderExists(value : language.zip)) {
                Button(action: {
                    deleteFolderFromDocumentsDirectory(folderName: language.zip)
                    folderExists = checkIfFolderExists(value: language.name) //<<<<<<
                    
                }) {
                    Text("Delete folder")
                }
            }
            //        .onAppear(dirExists = checkIfFolderExists(value : language.zip))
            
            if folderExists {
                Text("The folder exists!")
            } else {
                Text("The folder does not exist.")
            }
        }
        .onAppear {
            folderExists = checkIfFolderExists(value: language.zip) //<<<<<<
        }
    }
    
       
    
    
    func deleteFolderFromDocumentsDirectory(folderName: String) {
        let fileManager = FileManager.default
        do {
            let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let folderURL = documentsDirectory.appendingPathComponent(folderName)
            try fileManager.removeItem(at: folderURL)
        } catch let error as NSError {
            print("Error deleting folder: \(error)")
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


//                Button("Print bundle") {
//                    print(getDocumentDirectory().path)
//                }
//                .padding(10)

