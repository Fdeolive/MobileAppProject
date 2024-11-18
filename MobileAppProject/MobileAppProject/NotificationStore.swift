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
    let loadFromFile = false//true
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
        }
    }
    
    @discardableResult
    func saveChanges() -> Bool {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(allNotifications)
            try data.write(to: notificationArchiveURL, options: [.atomic])
            print("Saved data to \(notificationArchiveURL)")
            print(allNotifications)
            return true
        } catch let encodingError {
            print("Error encoding allItems: \(encodingError)")
            return false
        }
    }
    
    func delete(notification: Notification!) {
        if let idx = allNotifications.firstIndex(where: {$0.notificationId == notification.notificationId}) {
            allNotifications.remove(at: idx)
        }
    }

}
