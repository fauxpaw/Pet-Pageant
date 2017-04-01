//
//  CustomBaseViewContollerViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 3/3/17.
//  Copyright © 2017 Michael Sweeney. All rights reserved.
//

import UIKit

class CustomBaseViewContollerViewController: UIViewController, SetupViewControllerProtocol, ModifyViewProtocol, ModifyButtonProtocol, ModifyImageProtocol, StatusBarBackgroundProtocol {
    
    internal func modifyButtons() {
        
        let views = self.view.subviews
        for view in views {
            if view is UIButton {
                view.backgroundColor = gBackGroundColor
                view.layer.borderWidth = gBorderWidthDefault
                view.layer.cornerRadius = gCornerRadiusButton
                view.layer.borderColor = gThemeColor.cgColor
                let b = view as! UIButton
                b.tintColor = gThemeColor
            }
        }
    }

    internal func modifyImage() {
        let views = self.view.subviews
        for view in views {
            if view is UIImageView {
                view.layer.cornerRadius = gCornerRadius
                view.layer.cornerRadius = gCornerRadius
                view.layer.borderWidth = gBorderWidthDefault
                view.layer.borderColor = gThemeColor.cgColor
            }
        }
    }

    internal func modifyBackground() {
        self.view.backgroundColor = gBackGroundColor
    }

    internal func setup() {
        self.modifyBackground()
        self.modifyButtons()
        self.modifyImage()
        modifyStatusBarBackground(view: self.view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
