//
//  ErrorHandler.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 10/20/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit

class ErrorHandler {
    class func presentNotification(title: String ,message: String) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return }
        rootVC.present(alertController, animated: true, completion: nil)
    }
}
