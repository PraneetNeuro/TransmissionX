//
//  DownloadManager.swift
//  TransmissionX
//
//  Created by Praneet S on 06/05/21.
//

import Foundation

class DownloadManager : ObservableObject {
    
    struct downloadItem {
        let id: UUID = UUID()
        var isPaused: Bool = false
        var isActive: Bool = true
        var downloadTask: URLSessionDownloadTask
        var priority: Float?
    }
    
    private init() {}
    public static var shared: DownloadManager = DownloadManager()
    @Published var downloadQueue: [downloadItem] = []
    
    func download(url: String, callback: @escaping (URL) -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        let downloadTask: URLSessionDownloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
            localFileURL, response, error in
            guard let url = localFileURL else { return }
            callback(url)
        })
        downloadTask.resume()
        var download = downloadItem(downloadTask: downloadTask, priority: nil)
        downloadQueue.append(download)
    }
    
}
