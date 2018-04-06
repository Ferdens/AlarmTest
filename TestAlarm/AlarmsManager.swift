//
//  AlarmsManager.swift
//  TestAlarm
//
//  Created by anton Shepetuha on 06.04.18.
//  Copyright © 2018 anton Shepetuha. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class AlarmsManager: NSObject {
    
    static let shared = AlarmsManager()
    
    var alarmTimers = [Timer]()
    
    func setAlarmTimerFor(_ alarm: Alarm) {
        let timeUntil = alarm.alarmTriggerDate.timeIntervalSince(Date())
        DispatchQueue.global().async(execute: {
            DispatchQueue.main.sync {
                AlarmsManager.shared.alarmTimers.append(Timer.scheduledTimer(timeInterval: timeUntil, target: self, selector: #selector(AlarmsManager.shared.triggerAlarm(_:)), userInfo: alarm.id, repeats: false))
            }
        })
        let realm = try! Realm()
        try! realm.write {
            alarm.timerIsSet = true
        }
    }
    
    @objc func triggerAlarm(_ timer: Timer) {
        AudioManager.shared.playAlarmAudio()
        NotificationCenter.default.post(name: NSNotification.Name.alarmTrigeringNotification, object: timer)
    }
    
    static func setTimersForFutureAlarms() {
        let realm = try! Realm()
        let alarms = realm.objects(Alarm.self).filter { (alarm) -> Bool in
            return alarm.alarmTriggerDate > Date()
        }
        for alarm in alarms where !alarm.timerIsSet {
            AlarmsManager.shared.setAlarmTimerFor(alarm)
        }
    }
    
    static func setAllAlarmsTimersNotSet() {
        let realm = try! Realm()
        let alarms = realm.objects(Alarm.self).filter { (alarm) -> Bool in
            return alarm.alarmTriggerDate > Date()
        }
        try! realm.write {
            for alarm in alarms {
                alarm.timerIsSet = false
            }
        }
    }
    
}
