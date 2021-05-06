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
                TextField("Download URL", text: $downloadURL)
                Button("Download", action: {
                    DownloadManager.shared.download(url: downloadURL, callback: { url in
                        print(url)
                    })
                })
            }
            List(downloadManager.downloadQueue, id: \.id) { item in
                if item.isActive {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(item.downloadTask.currentRequest?.url?.absoluteString ?? "")
                                .lineLimit(1)
                            if item.isPaused {
                                Button(action: {
                                    for i in 0..<downloadManager.downloadQueue.count where downloadManager.downloadQueue[i].id == item.id {
                                        downloadManager.downloadQueue[i].isPaused = false
                                        downloadManager.downloadQueue[i].downloadTask.resume()
                                    }
                                }, label: {
                                    Image(systemName: "play.fill")
                                })
                            } else {
                                Button(action: {
                                    for i in 0..<downloadManager.downloadQueue.count where downloadManager.downloadQueue[i].id == item.id {
                                        downloadManager.downloadQueue[i].isPaused = true
                                        downloadManager.downloadQueue[i].downloadTask.suspend()
                                    }
                                }, label: {
                                    Image(systemName: "pause.fill")
                                })
                            }
                            Button(action: {
                                for i in 0..<downloadManager.downloadQueue.count where downloadManager.downloadQueue[i].id == item.id {
                                    downloadManager.downloadQueue[i].downloadTask.cancel()
                                    downloadManager.downloadQueue[i].isActive = false
                                }
                            }, label: {
                                Image(systemName: "xmark.circle")
                            })
                        }
                        ProgressView(item.downloadTask.progress)
                            .padding()
                    }
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
