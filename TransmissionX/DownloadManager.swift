//
//  DownloadManager.swift
//  TransmissionX
//
//  Created by Praneet S on 06/05/21.
//

import Foundation

class DownloadManager : ObservableObject {
    
    struct DownloadItem {
        let id: UUID = UUID()
        let url: URL
        var isPaused: Bool = false
        var isActive: Bool = true
        var downloadTask: URLSessionDownloadTask
        var priority: Float?
    }
    
    private init() {}
    public static var shared: DownloadManager = DownloadManager()
    @Published var downloadQueue: [DownloadItem] = []
    
    func download(url: String, callback: @escaping (URL, URLResponse?) -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        let downloadTask: URLSessionDownloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
            localFileURL, response, error in
            guard let url = localFileURL else { return }
            callback(url, response)
        })
        downloadTask.resume()
        downloadQueue.append(DownloadItem(url: url, downloadTask: downloadTask, priority: nil))
    }
    
    func finishDownloadsBasedOnSize(isAscending: Bool, sharedBandwidth: Bool) {
        downloadQueue.sort(by: { download1, download2 in
            if isAscending {
                return download1.downloadTask.countOfBytesClientExpectsToReceive < download2.downloadTask.countOfBytesClientExpectsToReceive
            }
            return download1.downloadTask.countOfBytesClientExpectsToReceive > download2.downloadTask.countOfBytesClientExpectsToReceive
        })
        // To-do : Shared bandwidth logic
    }
    
}
