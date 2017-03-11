//
//  VoteView.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/22/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit

@IBDesignable class VoteView: UIView {
    
    //MARK: PROPERTIES
    
    var view: UIView!
    var nibName: String = "VoteView"
    var petRecord: Pet?
    var delegate: VoteViewController?
    
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var rightBackgroundImage: UIImageView!
    @IBOutlet weak var leftBackgroundImage: UIImageView!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var voteIcon: UIImageView!
    
    @IBInspectable var petImage: UIImage? {
        get{
            return petImageView.image
        }
        set(image) {
            petImageView.image = image
        }
    }
    
    //MARK: INITIALIZERS
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.commenceAesthetics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UINib(nibName: "VoteView", bundle: nil).instantiate(withOwner: self, options: nil)
        self.setup()
        self.commenceAesthetics()
    }
    
    //MARK: CLASS METHODS
    
    fileprivate func setup() {
        view = self.loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
    }
    
    fileprivate func commenceAesthetics() {
        
        let corners = [self.rightBackgroundImage, self.leftBackgroundImage, self.petImageView]
        
        for view in corners {
            view?.layer.cornerRadius = gCornerRadius
            view?.layer.borderWidth = 3
            view?.layer.borderColor = gBackGroundColor.cgColor
        }
        let buttons = [self.menuButton, self.reportButton]
        for button in buttons {
            button?.layer.borderWidth = 3
            button?.layer.borderColor = gThemeColor.cgColor
            button?.layer.cornerRadius = gCornerRadiusButton
        }
        
        self.voteIcon.isHidden = true
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
        
    }
    
    func addYesVoteIcon(){
        
        self.voteIcon.image = UIImage(named: "chooseDestruct.png")
        self.voteIcon.alpha = 0.0
        self.voteIcon.isHidden = false
    }
    
    func addNoVoteIcon(){
        
        self.voteIcon.image = UIImage(named: "rejectDestruct.png")
        self.voteIcon.alpha = 0.0
        self.voteIcon.isHidden = false
    }
    
    func removeVoteIcon(){
        self.voteIcon.isHidden = true
    }
    
    func menuButtonSelected() {

        guard let topVC = UIApplication.shared.keyWindow?.rootViewController else {return}
        let alertVC = UIAlertController(title: "Menu", message: "To cast a vote for this photo, press <Vote>.(additionally, you may cancel this menu and swipe the photo left or right) To pass on this round of voting, press <Pass>. To close this menu, press <Cancel>.", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Vote", style: .default, handler: { (action) in
            if (self.delegate != nil) {
                self.delegate?.didVoteViaButton(forView: self)
            }
        }))
        alertVC.addAction(UIAlertAction(title: "Pass", style: .default, handler: { (action) in
            print("passing voting round")
            if (self.delegate != nil) {
                self.delegate?.didPassViaButton(forView: self)
            }
            
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        topVC.present(alertVC, animated: true, completion: nil)
    }
    
    func reportPicture() {
        let actionController = UIAlertController(title: "Report", message: "Do you really want to report this photo for inappropriate content?", preferredStyle: .actionSheet)
        actionController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        let reportAction = UIAlertAction(title: "Report", style: .destructive) {
            (action) in
            self.reportPictureSelected()
        }
        actionController.addAction(reportAction)
        guard let topVC = UIApplication.shared.keyWindow?.rootViewController else {return}
        topVC.present(actionController, animated: true, completion: nil)
    }
    
    func reportPictureSelected() {
        guard (self.petRecord != nil) else { return }
        //API call
        let record = self.petRecord
        record?.incrementKey("reports")
        self.disableReport()
        record?.saveInBackground(block: { (success, error) in
            if let error = error {
                print(error.localizedDescription)
                ErrorHandler.presentNotification(title: "Error", message: "Report not successfully recieved due to: \(error.localizedDescription)")
            }
            if success {
                ErrorHandler.presentNotification(title:"Success!", message: "Report successfully recieved. Thank you for helping keep Pet Pageant family friendly.")
            }
        })
    }
    
    func disableReport() {
        reportButton.isUserInteractionEnabled = false
    }
    
    func enableReport() {
        reportButton.isUserInteractionEnabled = true
    }
    
    //MARK: ACTIONS
    
    @IBAction func leftButtonSelected(_ sender: UIButton) {
        self.menuButtonSelected()
    }
    
    @IBAction func rightButtonSelected(_ sender: UIButton) {
        self.reportPicture()
        
    }
}
