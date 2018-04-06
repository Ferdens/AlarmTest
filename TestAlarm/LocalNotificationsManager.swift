//
//  AppNotificationsManager.swift
//  TestAlarm
//
//  Created by anton Shepetuha on 06.04.18.
//  Copyright © 2018 anton Shepetuha. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import RealmSwift

class LocalNotificationsManager: NSObject {
    
    static func scheduleAllFutureAlarms() {
        let realm = try! Realm()
        let alarms = Array(realm.objects(Alarm.self)).filter({ (alarm) -> Bool in
            return alarm.alarmTriggerDate > Date()
        })
        for alarm in alarms {
            LocalNotificationsManager.scheduleNotificationWith(fireDate: alarm.alarmTriggerDate, notifIdentifire: String(alarm.id), completion: nil)
        }
    }
    
    static func scheduleNotificationWith(fireDate: Date, notifIdentifire: String, completion: ((Error?) -> Void)?) {
        LocalNotificationsManager.removeNotifications(identifier: notifIdentifire)
        
        let content      = UNMutableNotificationContent()
        content.title    = "Alarm triggering"
        content.userInfo = ["alarm": notifIdentifire]
        content.body     = "ALARM"
        content.sound    = UNNotificationSound.default()
        
        let claendar   = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components = claendar.dateComponents([.month,.day,.hour,.minute,.second], from: fireDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: notifIdentifire, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                let _ = SimpleAlert.showAlert(alert: error.localizedDescription, delegate: ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController)!)
                print(error.localizedDescription)
                if let completionHandler = completion {
                    completionHandler(error)
                }
            } else {
                if let completionHandler = completion {
                    completionHandler(nil)
                }
            }
        }
    }
    
    static func removeNotifications(identifier: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
}
