//
//  ContentView.swift
//  TransmissionX
//
//  Created by Praneet S on 06/05/21.
//

import SwiftUI

struct DownloadActionsButtonView: View {
    var index: Int
    @ObservedObject var downloadManager: DownloadManager = DownloadManager.shared
    var body: some View {
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
}

struct ContentView: View {
    @State var downloadURL: String = ""
    @State var suggestedURL: String = ""
    @ObservedObject var downloadManager: DownloadManager = DownloadManager.shared
    let timerPublisher = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default).autoconnect()
    var body: some View {
        VStack {
            HStack {
                if suggestedURL.count > 0 {
                    Button(action: {
                        downloadURL = suggestedURL
                    }, label: {
                        Image(systemName: "doc.on.clipboard")
                    })
                }
                TextField("Download URL", text: $downloadURL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Download", action: {
                    DownloadManager.shared.download(url: downloadURL, callback: { url, response, downloadID in
                        for downloadIndex in 0..<downloadManager.downloadQueue.count where downloadManager.downloadQueue[downloadIndex].id == downloadID {
                            downloadManager.downloadQueue[downloadIndex].isActive = false
                        }
                        saveToDownloads(url, response)
                    })
                })
            }
            .padding()
            List(0..<downloadManager.downloadQueue.count, id: \.self) { index in
                VStack(alignment: .leading) {
                    HStack {
                        Text(downloadManager.downloadQueue[index].downloadTask.currentRequest?.url?.absoluteString ?? "")
                            .lineLimit(1)
                        if downloadManager.downloadQueue[index].isActive {
                            DownloadActionsButtonView(index: index)
                        }
                    }
                    ProgressView(downloadManager.downloadQueue[index].downloadTask.progress)
                        .padding()
                }
                .padding()
                .background(downloadManager.downloadQueue[index].isActive ? Color.accentColor.opacity(0.4) : Color.gray.opacity(0.4))
                .cornerRadius(6)
            }
        }.onReceive(timerPublisher, perform: { _ in
            if let urlFromPasteBoard = NSPasteboard.general.string(forType: .string) {
                if urlFromPasteBoard.isValidURL {
                    suggestedURL = urlFromPasteBoard
                }
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
