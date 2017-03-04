//
//  LoginViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 3/3/17.
//  Copyright © 2017 Michael Sweeney. All rights reserved.
//

import Foundation
import ParseUI

class LoginViewController: PFLogInViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setup() {
        self.initBackgroundView()
        self.modifyButtons()
        self.removeLogos()
    }
    
    private func initBackgroundView (){
        let loginSplash = UIImage(named: "titleLogo1")
        let imageViewBackground = UIImageView(frame: CGRect(x:0,y:0,width:gScreenSize.width,height:gScreenSize.height))
        imageViewBackground.image = loginSplash
        imageViewBackground.contentMode = .scaleAspectFit
        self.logInView?.addSubview(imageViewBackground)
        self.logInView?.sendSubview(toBack: imageViewBackground)
        self.logInView?.backgroundColor = gBackGroundColor
    }
    
    private func modifyButtons () {
        
        var buttons = [UIButton]()
        buttons.append((self.logInView?.signUpButton)!)
        buttons.append((self.logInView?.logInButton)!)
        buttons.append((self.logInView?.passwordForgottenButton)!)
        buttons.append((self.signUpController?.signUpView?.signUpButton)!)
        
        for button in buttons {
            button.setBackgroundImage(nil, for: .normal)
            button.backgroundColor = gTextColor
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 2
            button.layer.borderColor = gThemeColor.cgColor
        }
        self.logInView?.passwordForgottenButton?.setTitleColor(gThemeColor, for: .normal)
        
    }
    
    private func removeLogos() {
        let loginLogoTitle = UILabel()
        loginLogoTitle.text = ""
        self.logInView?.logo = loginLogoTitle
        let signupLogoTitle = UILabel()
        signupLogoTitle.text = ""
        self.signUpController?.signUpView?.logo = signupLogoTitle
    }
    
    private func modifySignupController (){
        
    }
    
}
