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
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var rightBackgroundImage: UIImageView!
    @IBOutlet weak var leftBackgroundImage: UIImageView!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBInspectable var petImage: UIImage? {
        get{
            return petImageView.image
        }
        set(image) {
            petImageView.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UINib(nibName: "VoteView", bundle: nil).instantiate(withOwner: self, options: nil)
        self.setup()
    }
    
    func setup() {
        view = self.loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
        
    }
    //MARK: ICONS
    func addYesVoteIcon(){
        
        let image = UIImage(named: "GreenCheck.png")
        let yesImageView = UIImageView(image: image)
        self.petImageView.addSubview(yesImageView)
        yesImageView.center = CGPoint(x: self.petImageView.bounds.midX, y: self.petImageView.bounds.midY)
        yesImageView.alpha = 0.0
    }
    
    func addNoVoteIcon(){
        
        let image = UIImage(named: "RedX.png")
        let noImageView = UIImageView(image: image)
        self.petImageView.addSubview(noImageView)
        noImageView.center = CGPoint(x: self.petImageView.bounds.midX, y: self.petImageView.bounds.midY)
        noImageView.alpha = 0.0
    }
    
    func removeVoteIcon(){
        //check here if things go wrong after pictures add
        if petImageView.subviews.count > 0 {
            for subview in petImageView.subviews {
                subview.removeFromSuperview()
            }
        }
    }
    
    func menuButtonSelected() {
        /* let actionController = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        actionController.addAction(UIAlertAction(title: "Details", style: .default , handler: nil))
        actionController.addAction(UIAlertAction(title: "Share on Facebook", style: .default, handler: nil))
       /* let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
            (action) in
            self.deleteRecord()
        }
        actionController.addAction(deleteAction) */
        actionController.addAction(UIAlertAction(title: "Share on Twitter", style: .default, handler: nil))
        actionController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    */
        guard let topVC = UIApplication.shared.keyWindow?.rootViewController else {return}
        let title = "Share with friends"
        let image = UIImage(named: "anna.png")
        let activityController = UIActivityViewController(activityItems: [title, image], applicationActivities: [])
        activityController.excludedActivityTypes = [UIActivityType.copyToPasteboard, UIActivityType.assignToContact, UIActivityType.print, UIActivityType.openInIBooks, UIActivityType.mail, UIActivityType.message]
        topVC.present(activityController, animated: true, completion: nil)
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
    
   /* func deleteRecord() {
        guard self.petRecord != nil else { return }
        let record = self.petRecord
        record?.deleteInBackground(block: { (success, error) in
            if let error = error {
                ErrorHandler.presentNotification(title: "Error", message: "Could not be deleted due to \(error.localizedDescription)")
            }
            else if success {
                ErrorHandler.presentNotification(title: "Success", message: "Record deleted")
            }
        })
    } */
    
    @IBAction func leftButtonSelected(_ sender: UIButton) {
        self.menuButtonSelected()
    }
    
    @IBAction func rightButtonSelected(_ sender: UIButton) {
        self.reportPicture()
        
    }
}
