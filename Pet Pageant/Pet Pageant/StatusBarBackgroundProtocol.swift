//
//  StatusBarBackgroundProtocol.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 3/4/17.
//  Copyright © 2017 Michael Sweeney. All rights reserved.
//

import UIKit

protocol StatusBarBackgroundProtocol {
    
}

extension StatusBarBackgroundProtocol {
    func modifyStatusBarBackground(view: UIView) {
        let toAdd = UIView(frame: CGRect(x: 0, y: 0, width: gScreenSize.width, height: 20))
        toAdd.backgroundColor = gThemeColor
        view.addSubview(toAdd)
    }
}

