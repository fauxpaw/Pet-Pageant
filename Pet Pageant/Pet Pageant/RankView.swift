//
//  TopRankedPet.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 9/16/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Foundation

class RankView: UIView {
    
    //MARK: PROPERTIES
    
    
    var view: UIView!
    var image: UIImage?
    //var currentPosition: CGPoint?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var votePercentageLabel: UILabel!
    @IBOutlet weak var labelBackgroundView: UIView!
    
    func loadXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RankView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    //MARK: INITIALIZERS
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.commenceAesthetics()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
        self.commenceAesthetics()
    }
    
    //MARK: CLASS METHODS
    
    func setup() {
        view = self.loadXib()
        view.frame = self.bounds
        //view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    fileprivate func commenceAesthetics() {
        let corners = [self.imageView, self.view, self.labelBackgroundView]
        for view in corners {
            view?.layer.cornerRadius = gCornerRadiusButton
            view?.layer.borderWidth = gBorderWidthDefault
            view?.layer.borderColor = gThemeColor.cgColor
        }
        
        self.view.backgroundColor = gThemeColor
        self.labelBackgroundView.backgroundColor = gBackGroundColor
        let labels = [self.rankLabel, self.votesLabel, self.votePercentageLabel]
        for label in labels {
            label?.textColor = gThemeColor
        }
    }
}
