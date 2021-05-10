//
//  ContentView.swift
//  TransmissionX
//
//  Created by Praneet S on 06/05/21.
//

import SwiftUI

struct ContentView: View {
    @State var downloadURL: String = ""
    @ObservedObject var downloadManager: DownloadManager = DownloadManager.shared
    var body: some View {
        VStack {
            HStack {
                if let urlFromPasteBoard = NSPasteboard.general.string(forType: .string) {
                    Button(action: {
                        downloadURL = urlFromPasteBoard
                    }, label: {
                        Image(systemName: "doc.on.clipboard")
                    })
                }
                TextField("Download URL", text: $downloadURL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Download", action: {
                    DownloadManager.shared.download(url: downloadURL, callback: { url, response in
                        print(url)
                        let filename = ((response as! HTTPURLResponse).allHeaderFields["Content-Disposition"] as? String)?.split(separator: "=")[1]
                        guard let partialFileName = filename else {
                            return
                        }
                        var dirtyPath: String = String(String(partialFileName).split(separator: " ")[0])
                        dirtyPath = dirtyPath.replacingOccurrences(of: "%20", with: " ")
                        dirtyPath = dirtyPath.replacingOccurrences(of: ";", with: "")
                        dirtyPath = dirtyPath.replacingOccurrences(of: "\"", with: "")
                        print(dirtyPath)
                        var localSaveURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
                        localSaveURL.appendPathComponent(dirtyPath)
                        do {
                            try FileManager.default.moveItem(atPath: url.path, toPath: localSaveURL.path)
                            try FileManager.default.createFile(atPath: localSaveURL.path, contents: Data(contentsOf: url))
                        } catch {
                            print(error)
                        }
                    })
                })
            }
            .padding()
            List(0..<downloadManager.downloadQueue.count, id: \.self) { index in
                if downloadManager.downloadQueue[index].isActive {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(downloadManager.downloadQueue[index].downloadTask.currentRequest?.url?.absoluteString ?? "")
                                .lineLimit(1)
                            if downloadManager.downloadQueue[index].isPaused {
                                Button(action: {
                                    downloadManager.downloadQueue[index].isPaused = false
                                    downloadManager.downloadQueue[index].downloadTask.resume()
                                }, label: {
                                    Image(systemName: "play.fill")
                                })
                            } else {
                                Button(action: {
                                    downloadManager.downloadQueue[index].isPaused = true
                                    downloadManager.downloadQueue[index].downloadTask.suspend()
                                }, label: {
                                    Image(systemName: "pause.fill")
                                })
                            }
                            Button(action: {
                                downloadManager.downloadQueue[index].isActive = false
                                downloadManager.downloadQueue[index].downloadTask.cancel()
                            }, label: {
                                Image(systemName: "xmark.circle")
                            })
                        }
                        ProgressView(downloadManager.downloadQueue[index].downloadTask.progress)
                            .padding()
                    }
                    .padding()
                    .background(Color.accentColor.opacity(0.4))
                    .cornerRadius(6)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
