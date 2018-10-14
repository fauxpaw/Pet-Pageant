//
//  VoteView.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/22/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.


import UIKit
import Parse

@IBDesignable class VoteView: UIView {
    
    //MARK: - PROPERTIES
    
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var rightBackgroundImage: UIImageView!
    @IBOutlet weak var leftBackgroundImage: UIImageView!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var menuButton: UIButton!
    
    @IBInspectable var petImage: UIImage? {
        get{
            return petImageView.image
        }
        set(image) {
//            DispatchQueue.main.async {
                self.petImageView.image = image
//            }
        }
    }
    
    var view: UIView!
    var nibName: String = "VoteView"
    var petRecord: Pet?
    var delegate: VoteViewController?
    
    //MARK: - INITIALIZERS
    
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
    
    //MARK: - CLASS METHODS
    
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
        
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
        
    }
    
    func fetchImageForRecord(completion: @escaping (Bool)->()){
        guard let petRecord = self.petRecord else {
            print("No pet record on this voteview")
            completion(false)
            return
        }
        
        guard let imageData = petRecord["imageFile"] as? PFFile else {
            print("PFFile badness for key 'imageFile'")
            API.deleteRecord(record: petRecord)
            completion(false)
            return
        }
        
        imageData.getDataInBackground(block: { (data: Data?, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let stuff = data else {
                print("data param came back nil")
                completion(false)
                return
            }
            guard let img = UIImage(data: stuff) else {
                print("failed to init UIImage from data ")
                completion(false)
                return
            }
            
            self.petImage = img
            completion(true)
        })
    }

    func incrementRecordsViews() {
        guard let record = self.petRecord else {return}
        record.incrementKey("viewed")
        record.saveInBackground(block: { (success, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            // handle success
        })
    }
    
    func incrementRecordsVotes() {
        guard let record = self.petRecord else {return}
        record.incrementKey("votes")
        record.incrementKey("viewed")
        record.saveInBackground(block: { (success, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            // handle success
        })
    }
    
    func alterAlphaForUnselectedState(alpha: CGFloat) {
        
        self.alpha = alpha
    }
    
    func resetViewAlphas() {
        self.alterAlphaForUnselectedState(alpha: 1.0)
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
            self.delegate?.didPassViaButton(forView: self)
        }
        actionController.addAction(reportAction)
        guard let topVC = UIApplication.shared.keyWindow?.rootViewController else {return}
        topVC.present(actionController, animated: true, completion: nil)
    
    }
    
    func reportPictureSelected() {
        guard let record = self.petRecord else { return }
        //API call
        
        record.incrementKey("reports")
        self.disableInteraction()
        record.saveInBackground(block: { (success, error) in
            if let error = error {
                print(error.localizedDescription)
                ErrorHandler.presentNotification(title: "Error", message: "Report not successfully recieved due to: \(error.localizedDescription)")
            }
            if success {
                ErrorHandler.presentNotification(title:"Success!", message: "Report successfully recieved. Thank you for helping keep Pet Pageant family friendly.")
            }
        })
        
        guard let user = PFUser.current() else {return}
        let relation = record.relation(forKey: "usersBlocked")
        relation.add(user)
        record.saveInBackground(block: { (success, error) in
            if let error = error {
                print(error.localizedDescription)
                print("Pet record did not update with ignored user")
            }
            
            if success {
                print("User will be listed on this record as blocked")
            }
        })
    }
    
    func disableInteraction() {
//        DispatchQueue.main.async {
            self.reportButton.isUserInteractionEnabled = false
//        }
    }
    
    func enableInteraction() {
//        DispatchQueue.main.async {
            self.reportButton.isUserInteractionEnabled = true
//        }
    }
    
    func enterVotingState() {
        self.turnOffSpinner()
        self.enableInteraction()
    }
    
    func enterPreVoteState() {
        self.disableInteraction()
        self.alterAlphaForUnselectedState(alpha: 1.0)
        self.petImage = nil
        self.turnOnSpinner()
    }
    
    private func turnOnSpinner() {
//        DispatchQueue.main.async {
            self.spinner.startAnimating()
            self.spinner.isHidden = false
//        }
    }
    
    private func turnOffSpinner() {
//        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
//        }
    }
    
    //MARK: - ANIMATIONS
    
    func animateViewIn() {
        
        self.enterPreVoteState()
        guard let destinationCenter = self.superview?.center.x else {
            print("vote view super view cry")
            return}
        if self.center.x == destinationCenter {
            print("no need to animate, we are at center!")
            return
        }
        
        UIView.animate(withDuration: gVoteAnimationInTime, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            
            self.center.x = destinationCenter
            
            
        }, completion: nil)
    }
    
    //MARK: - ACTIONS
    
    @IBAction func leftButtonSelected(_ sender: UIButton) {
        self.menuButtonSelected()
    }
    
    @IBAction func rightButtonSelected(_ sender: UIButton) {
        self.reportPicture()
        
    }
}
