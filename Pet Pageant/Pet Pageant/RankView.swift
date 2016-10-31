//
//  TopRankedPet.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 9/16/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit

class RankView: UIView {
    
    var view: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var votePercentageLabel: UILabel!
    
    func loadXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RankView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        UINib(nibName: "RankView", bundle: nil).instantiateWithOwner(self, options: nil)
        self.setup()
    }
    
    func setup() {
        view = self.loadXib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
}
