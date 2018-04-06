//
//  Alarm.swift
//  TestAlarm
//
//  Created by anton Shepetuha on 06.04.18.
//  Copyright © 2018 anton Shepetuha. All rights reserved.
//

import Foundation
import RealmSwift

class Alarm: Object {
    
    @objc dynamic var id                = Int()
    @objc dynamic var alarmTriggerDate  = Date()
    @objc dynamic var timerIsSet        = Bool()

    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func newObjectID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Alarm.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    static func addNewAalarmWith(triggerDate: Date) -> Alarm {
        let realm = try! Realm()
        let newAlarm = Alarm()
        try! realm.write {
            newAlarm.id = Alarm.newObjectID()
            newAlarm.alarmTriggerDate = triggerDate
            realm.add(newAlarm, update: true)
        }
        LocalNotificationsManager.scheduleNotificationWith(fireDate: newAlarm.alarmTriggerDate, notifIdentifire: String(newAlarm.id), completion: nil)
        AlarmsManager.shared.setAlarmTimerFor(newAlarm)
        return newAlarm
    }
    
}
