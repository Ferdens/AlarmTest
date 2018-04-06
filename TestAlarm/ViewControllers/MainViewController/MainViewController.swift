//
//  MainViewController.swift
//  TestAlarm
//
//  Created by anton Shepetuha on 06.04.18.
//  Copyright © 2018 anton Shepetuha. All rights reserved.
//

import UIKit
import RealmSwift
import DateTimePicker
import UserNotifications

class MainViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    let alarmTableCellReuseId = "alarmTableCellReuseId"
    
    var alarms = [Alarm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateAlarmsFromRealm()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAlarmsFromRealm), name: NSNotification.Name.applicationDidBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(alarmTriggering), name: NSNotification.Name.alarmTrigeringNotification, object: nil)
    }
    
    // MARK: - User's actions
    
    @objc func addNewAlarmButtonAction() {
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 99.0 / 255.0, green: 224.0 / 255.0, blue: 183.0 / 255.0, alpha: 1.0)
        picker.doneButtonTitle = "Set Alarm"
        picker.doneBackgroundColor = UIColor(red: 74.0 / 255.0, green: 144.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
        picker.completionHandler = { date in
            guard date > Date() else {SimpleAlert.showAlert(alert: "You can't make alarm in past.", delegate: self); return}
            let newAlarm = Alarm.addNewAalarmWith(triggerDate: date)
            self.alarms.insert(newAlarm, at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }
    }
    
    @objc func deleteAllButtonAction() {
        cleanAllAlarms()
    }
    
    // MARK: - Help Methods
    
    @objc func alarmTriggering() {
        if AudioManager.shared.alarmIsPlaying() {
            SimpleAlert.showAlert(title: "", alert: "ALARM", delegate: self, handler: { (action) in
                AudioManager.shared.stopAlarmAudio()
            })
        }
        updateAlarmsFromRealm()
    }
    
    @objc func updateAlarmsFromRealm() {
        let realm = try! Realm()
        alarms = Array(realm.objects(Alarm.self)).filter({ (alarm) -> Bool in
            return alarm.alarmTriggerDate > Date()
        })
        alarms.sort { (alarm1, alarm2) -> Bool in
            return alarm1.alarmTriggerDate < alarm2.alarmTriggerDate
        }
        self.tableView.reloadData()
    }
    
    func cleanAllAlarms() {
        let realm = try! Realm()
        let objects = realm.objects(Alarm.self)
        try! realm.write {
            realm.delete(objects)
        }
        self.updateAlarmsFromRealm()
    }
}
