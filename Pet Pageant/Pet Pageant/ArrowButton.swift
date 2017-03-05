//
//  ArrowButton.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 3/4/17.
//  Copyright © 2017 Michael Sweeney. All rights reserved.
//

import UIKit

class ArrowButton: UIButton {
    
    fileprivate let arrowButtonWidth : CGFloat = 40
    
    override func draw(_ rect: CGRect) {
        
        let mask = CAShapeLayer()
        mask.frame = self.layer.bounds
        let height = self.layer.frame.size.height
        let path = CGMutablePath()
        path.move(to: CGPoint(x: arrowButtonWidth, y: 0))
        path.addLine(to: CGPoint(x: arrowButtonWidth, y: height))
        path.addLine(to: CGPoint(x: 0, y: height/2))
        path.addLine(to: CGPoint(x: arrowButtonWidth, y: 0))
        
        mask.path = path
        self.layer.mask = mask
        
        let shape = CAShapeLayer()
        shape.frame = self.bounds
        shape.path = path
        shape.lineWidth = 5
        shape.strokeColor = gThemeColor.cgColor
        shape.fillColor = gBackGroundColor.cgColor
        self.layer.insertSublayer(shape, at: 0)
        
    }
}
