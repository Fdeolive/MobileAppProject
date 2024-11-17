//
//  NotificationStore.swift
//  MobileAppProject
//
//  Created by user267577 on 11/17/24.
//

import Foundation

func load<T: Decodable>(_ url: URL) -> T {
    let data: Data
    do {
        data = try Data(contentsOf: url)
    } catch {
        fatalError("Couldn't load \(url.path) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        print("parse \(url.path)")
        fatalError("Couldn't parse \(url.path) as \(T.self):\n\(error)")
    }
}

class NotificationStore: ObservableObject {
    @Published var allNotifications: [Notification]
    let loadFromFile = false
    let bundlesFilename = "notification-init.json"
    
    let notificationArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("notifications.json")
    } ()
    
    init() {
        if loadFromFile {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: notificationArchiveURL.path) {
                print("load from \(notificationArchiveURL.path)")
                self.allNotifications = load(notificationArchiveURL)
            } else {
                if let url = Bundle.main.url(forResource: bundlesFilename, withExtension: nil) {
                    print("load from \(url.path)")
                    self.allNotifications = load(url)
                } else {
                    fatalError("Can't find file to load")
                }
            }
        }else {
            allNotifications = []
            allNotifications.append(Notification("Welcome to Book Hunting", "Explore the app and all it's features!"))
        }
    }
}
