//
//  AlarmTableCell.swift
//  TestAlarm
//
//  Created by anton Shepetuha on 06.04.18.
//  Copyright © 2018 anton Shepetuha. All rights reserved.
//

import UIKit

class AlarmTableCell: UITableViewCell {
    
    private let alarmTriggerTimeLabel = UILabel()
    
    private lazy var dateFormatter: DateFormatter = { () -> DateFormatter in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYY hh:mm a"
        return dateFormatter
    }()
    
    var triggerDate = Date() {
        didSet {
            self.alarmTriggerTimeLabel.text = dateFormatter.string(from: triggerDate)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .white
        self.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        alarmTriggerTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        alarmTriggerTimeLabel.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        alarmTriggerTimeLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        self.contentView.addSubview(alarmTriggerTimeLabel)
        alarmTriggerTimeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        alarmTriggerTimeLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
