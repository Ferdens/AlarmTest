//
//  MainVCUserInterface.swift
//  TestAlarm
//
//  Created by anton Shepetuha on 06.04.18.
//  Copyright © 2018 anton Shepetuha. All rights reserved.
//

import Foundation
import UIKit

extension MainViewController {
    
    func setupUI() {
        self.view.backgroundColor = .white
        self.title = "Alarms"
        
        let addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        addButton.setBackgroundImage(#imageLiteral(resourceName: "plusIcon"), for: .normal)
        addButton.addTarget(self, action: #selector(addNewAlarmButtonAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addButton)
        
        let clearBarButton = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(deleteAllButtonAction))
        self.navigationItem.leftBarButtonItem = clearBarButton
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "LooopLaunchBackground"))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlarmTableCell.self, forCellReuseIdentifier: alarmTableCellReuseId)
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
}
