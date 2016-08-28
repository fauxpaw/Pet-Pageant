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
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var rightBackgroundImage: UIImageView!
    @IBOutlet weak var leftBackgroundImage: UIImageView!
    
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
        UINib(nibName: "VoteView", bundle: nil).instantiateWithOwner(self, options: nil)
        self.setup()
    }
    
    func setup() {
        view = self.loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
        
    }
    //MARK: ICONS
    func addYesVoteIcon(){
        
        let image = UIImage(named: "GreenCheck.png")
        let yesImageView = UIImageView(image: image)
        self.petImageView.addSubview(yesImageView)
        yesImageView.center = CGPointMake(self.petImageView.bounds.midX, self.petImageView.bounds.midY)
        yesImageView.alpha = 0.0
    }
    
    func addNoVoteIcon(){
        
        let image = UIImage(named: "RedX.png")
        let noImageView = UIImageView(image: image)
        self.petImageView.addSubview(noImageView)
        noImageView.center = CGPointMake(self.petImageView.bounds.midX, self.petImageView.bounds.midY)
        noImageView.alpha = 0.0
    }
    
    func removeVoteIcon(){
        //check here if things go wrong after pictures add
        for subview in petImageView.subviews {
            subview.removeFromSuperview()
        }
    }
}
