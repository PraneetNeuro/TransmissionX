//
//  TransmissionXApp.swift
//  TransmissionX
//
//  Created by Praneet S on 06/05/21.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var popover = NSPopover.init()
    var statusBar: StatusBarController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let contentView = ContentView()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.contentViewController = NSHostingController(rootView: contentView)
        statusBar = StatusBarController.init(popover)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
}

@main
struct TransmissionXApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
