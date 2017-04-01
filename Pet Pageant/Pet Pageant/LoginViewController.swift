//
//  LoginViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 3/3/17.
//  Copyright © 2017 Michael Sweeney. All rights reserved.
//

import Foundation
import ParseUI
import Parse

class LoginViewController: PFLogInViewController, ModifyButtonProtocol, StatusBarBackgroundProtocol, PFLogInViewControllerDelegate {
    
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
        self.modifySignupController()
        modifyStatusBarBackground(view: self.logInView!)
        modifyStatusBarBackground(view: (self.signUpController?.signUpView)!)
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
    
    internal func modifyButtons () {
        
        var buttons = [UIButton]()
        buttons.append((self.logInView?.signUpButton)!)
        buttons.append((self.logInView?.logInButton)!)
        buttons.append((self.signUpController?.signUpView?.signUpButton)!)
        
        for button in buttons {
            button.setBackgroundImage(nil, for: .normal)
            button.backgroundColor = gThemeColor
            button.layer.cornerRadius = gCornerRadiusButton
            button.layer.borderWidth = gBorderWidthDefault
            button.layer.borderColor = gThemeColor.cgColor
            button.tintColor = gTextColor
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
        self.signUpController?.signUpView?.backgroundColor = gThemeColor
        let loginSplash = UIImage(named: "titleLogo1")
        let imageViewBackground = UIImageView(frame: CGRect(x:0,y:0,width:gScreenSize.width,height:gScreenSize.height))
        imageViewBackground.image = loginSplash
        imageViewBackground.contentMode = .scaleAspectFit
        self.signUpController?.signUpView?.addSubview(imageViewBackground)
        self.signUpController?.signUpView?.sendSubview(toBack: imageViewBackground)
        self.signUpController?.signUpView?.backgroundColor = gBackGroundColor
    }
    
}
