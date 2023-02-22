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
            List {
                ForEach(viewModel.Languages, id: \.id) { language in
                    ListItemView(language: language)
                }
            }
        }
    }
}


struct ListItemView: View {
    let language : Item
    
    @State private var showProgressIndicator = true
    @State private var progress: CGFloat = 0
    @State private var message = ""
    @State private var folderExists = false
    
    var body: some View {
        HStack {
//            Text("")
            Text("\(language.name)")
//                .modifier(Square(color: .green))
            Spacer()
            
            if (folderExists) {
                Button(action: {
                    print("Delete")
                    deleteFolderFromDocumentsDirectory(folderName: language.zip)
                    progress = 0
                })
                {
                    Text("Delete")
                        .modifier(Square(color: .red, width: 120))
                        .font(.footnote)
                }
            } else {
                Button(action: {
                    print("download ")
                    downloadZipFile(value: language.zip)
                    
                })
                { if (progress==0) {
                    Text("Download")
                        .modifier(Square(width: 120))
                        .font(.footnote)
                } else
                    {
                    Text("\(String(format: "%.0f", progress * 100))%")
                        .modifier(Square(color: .bart_green, width: 120))
                    }
                }
            }
        }
        .onAppear {folderExists = checkIfFolderExists(value: language.zip)}
    }
    
    
    func deleteFolderFromDocumentsDirectory(folderName: String) {
        let fileManager = FileManager.default
        do {
            let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let folderURL = documentsDirectory.appendingPathComponent(folderName)
            try fileManager.removeItem(at: folderURL)
            folderExists = checkIfFolderExists(value: folderName)
            
        } catch let error as NSError {
            print("Error deleting folder: \(error)")
        }
    }
    
    func downloadZipFile(value: String) {
        self.message = value
        self.progress = 0
        let url = URL(string: "https://www.eduvip.nl/VSOdigitaal/louis/audio/"+value+".zip")!
        print("downloading... \(value)")
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
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(value+".zip")
        let destination = fileURL.deletingLastPathComponent()
        if SSZipArchive.unzipFile(atPath: fileURL.path, toDestination: destination.path) {
            self.message = "File unzipped successfully"
            do { //delete file after unzipping
                try FileManager.default.removeItem(at: fileURL)
                print("remove item")
                print(fileURL.absoluteString)
                folderExists = checkIfFolderExists(value: value)
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

