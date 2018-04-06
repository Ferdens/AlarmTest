//
//  MainVCTableMethods.swift
//  TestAlarm
//
//  Created by anton Shepetuha on 06.04.18.
//  Copyright © 2018 anton Shepetuha. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: alarmTableCellReuseId, for: indexPath) as! AlarmTableCell
        let alarm = alarms[indexPath.row]
        print(alarm.alarmTriggerDate)
        cell.triggerDate = alarm.alarmTriggerDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .default, title: "Delete Alarm") { (_, indexPath) in
            let alarm = self.alarms[indexPath.row]
            LocalNotificationsManager.removeNotifications(identifier: String(alarm.id))
            for timer in AlarmsManager.shared.alarmTimers {
                guard let alarmId = timer.userInfo as? Int else {continue}
                if alarmId == alarm.id {
                    timer.invalidate()
                }
            }
            self.alarms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let realm = try! Realm()
            try! realm.write {
                realm.delete(alarm)
            }
        }
        return [action]
    }
}

