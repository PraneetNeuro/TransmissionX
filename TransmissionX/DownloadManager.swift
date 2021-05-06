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
        downloadQueue.append(DownloadItem(url: url, downloadTask: downloadTask, priority: nil))
    }
    
}
