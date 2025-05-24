//
//  DownloadView.swift
//  Pods
//
//  Created by Eric de Quartel on 15/02/2023.
//
//test

import SwiftUI
import ZipArchive
import Alamofire
import SwiftyBeaver

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
    @EnvironmentObject var viewModel: LouisViewModel
    let language : Item
    
    @State private var showProgressIndicator = true
    @State private var progress: CGFloat = 0
//    @State private var message = ""
    let log = SwiftyBeaver.self
    @State private var folderExists = false
    @State private var showingAlert = false
    
    var body: some View {
        HStack {
            Text("\(language.zip)".localized())
            Spacer()
            
            if (folderExists) {
                Button(action: {
                    log.debug("Delete")
                    if countVisibleSubdirectoriesInDocumentsDirectory() > 1 { //??
                        deleteFolderFromDocumentsDirectory(folderName: language.zip)
                        progress = 0
                    } else {
                            showingAlert = true
                        }
                })
                {
                    Text("Delete")
                        .modifier(Square(color: .red, width: 120))
                        .font(.footnote)
                }
                .alert("minimumlanguages".localized(), isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
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
        log.error("downloadZipFile() \(value)")
        self.progress = 0
        let url = URL(string: endPoint + "audio/"+value+".zip")!
        log.error("downloading... \(value) \(url)")
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
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(value+".zip")
        let destination = fileURL.deletingLastPathComponent()
        if SSZipArchive.unzipFile(atPath: fileURL.path, toDestination: destination.path) {
            log.debug("File unzipped successfully")
            do { //delete file after unzipping
                try FileManager.default.removeItem(at: fileURL)
                print("remove item")
                print(fileURL.absoluteString)
                folderExists = checkIfFolderExists(value: value)
            } catch {
                log.error("Error deleting file")
            }
        } else {
            log.error("Error unzipping file")
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
            .environmentObject(LouisViewModel())
    }
}


//                Button("Print bundle") {
//                    print(getDocumentDirectory().path)
//                }
//                .padding(10)

