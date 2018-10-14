//
//  UIApplication + StatusBar.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 6/11/18.
//  Copyright © 2018 Michael Sweeney. All rights reserved.
//

import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
