//
//  DesignableButton.swift
//  todo
//
//  Created by Manu on 02/07/2019.
//  Copyright © 2019 Manu Marchand. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}
