//
//  UIKitExtension.swift
//  todo
//
//  Created by Manu on 02/07/2019.
//  Copyright © 2019 Manu Marchand. All rights reserved.
//

import UIKit

extension UIButton {
    
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}

extension UITableView {
    
    func setEmptyMessage(title: String, message: String) {
        
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 150)
        let headerView = UIView(frame: frame)
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 15)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(messageLabel)
        
        titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -20).isActive = true
        
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        if (self.tableHeaderView == nil) {
            self.tableHeaderView = headerView
        }
    }
    
    func removeEmptyMessage() {
        if let _ = self.tableHeaderView {
            self.tableHeaderView = nil
        }
    }
}
