//
//  VoteView.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/22/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit

@IBDesignable class VoteView: UIView {
    
    var view: UIView!
    var nibName: String = "VoteView"
    
    
    @IBOutlet weak var petImageView: UIImageView!
    
    
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
    
    func removeVoteIcons(){
        
        //check here if things go wrong after pictures add
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
    }
}
