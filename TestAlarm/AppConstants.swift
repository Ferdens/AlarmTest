//
//  AppConstants.swift
//  TestAlarm
//
//  Created by anton Shepetuha on 06.04.18.
//  Copyright © 2018 anton Shepetuha. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

extension Notification.Name {
    static let applicationDidBecomeActiveNotification = Notification.Name("applicationDidBecomeActiveNotification")
    static let alarmTrigeringNotification = Notification.Name("alarmTrigeringNotification")

}

class AppConstants {
    
    static func requestNotificationsPermission() {
        // Request notification permissions
        if #available(iOS 10, *) {
            let notificationCenter = UNUserNotificationCenter.current()
            if !UIApplication.shared.isRegisteredForRemoteNotifications {
                UIApplication.shared.registerForRemoteNotifications()
            }
            notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if let error = error {
                    print(error)
                } else if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    // denied
                }
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
}
