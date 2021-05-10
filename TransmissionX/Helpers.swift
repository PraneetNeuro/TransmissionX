//
//  Helpers.swift
//  TransmissionX
//
//  Created by Praneet S on 07/05/21.
//

import Foundation

func randomString(length: Int) -> String {
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    var randomString = ""
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    return randomString
}

func saveToDownloads(_ url: URL, _ response: URLResponse?) {
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
}
