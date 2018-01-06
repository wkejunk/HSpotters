//
//  ExtFunctions.swift
//  Airport
//
//  Created by Walter Edgar on 12/26/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import Foundation

import UIKit

extension UILabel {
    var optimalHeight: CGFloat {
        get {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.font = self.font
            label.text = self.text
            label.sizeToFit()
            return label.frame.height
        }
    }
}
