//
//  DownloadManager.swift
//  TransmissionX
//
//  Created by Praneet S on 06/05/21.
//

import Foundation

class DownloadManager : ObservableObject {
    
    struct DownloadItem {
        let id: UUID
        let url: URL
        var isPaused: Bool = false
        var isActive: Bool = true
        var downloadTask: URLSessionDownloadTask
        var priority: Float?
    }
    
    private init() {}
    public static var shared: DownloadManager = DownloadManager()
    @Published var downloadQueue: [DownloadItem] = []
    
    func download(url: String, callback: @escaping (URL, URLResponse?, UUID) -> ()) {
        let downloadID: UUID = UUID()
        guard let url = URL(string: url) else {
            return
        }
        let downloadTask: URLSessionDownloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
            localFileURL, response, error in
            guard let url = localFileURL else { return }
            callback(url, response, downloadID)
        })
        downloadTask.resume()
        downloadQueue.append(DownloadItem(id: downloadID, url: url, downloadTask: downloadTask, priority: nil))
    }
    
}
