//
//  TopRankedPet.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 9/16/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Foundation
import Parse

class RankView: UIView {
    
    //MARK: PROPERTIES
    
    var petRecord: Pet?
    var view: UIView!
    var image: UIImage?
    
    @IBOutlet weak var imageViewLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var votePercentageLabel: UILabel!
    @IBOutlet weak var labelBackgroundView: UIView!
    
    func loadXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RankView", bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView {
            return view
        }
        return UIView()
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
        addSubview(view)
    }
    
    fileprivate func commenceAesthetics() {
        let corners = [self.imageView, self.view, self.labelBackgroundView]
        for view in corners {
            view?.layer.cornerRadius = gCornerRadiusButton
            view?.layer.borderWidth = gBorderWidthDefault
            view?.layer.borderColor = gThemeColor.cgColor
        }
        
        let labels = [self.rankLabel, self.votesLabel, self.votePercentageLabel, self.imageViewLabel]
        for label in labels {
            label?.textColor = gThemeColor
        }
        self.imageView.contentMode = .scaleAspectFill
    }
    
    func updateLabels() {
        self.updateViewsLabel()
        self.updateVotesLabel()
    }
    
    func assignRank(rank: Int) {
        self.rankLabel.text = "Rank: \(rank)"
    }
    
    func updateVotesLabel() {
        guard let record = petRecord else {return}
        self.votesLabel.text = "Votes: \(record.votes)"
    }
    
    func updateViewsLabel() {
        guard let record = petRecord else {return}
        if record.viewed != 0 {
            self.votePercentageLabel.text = "Showdown win rate: \((100 * record.votes/record.viewed))%"
        } else {
            self.votePercentageLabel.text = "Photo has not yet been viewed"
        }
    }
    
    func showImageLabel() {
        self.imageViewLabel.isHidden = false
    }
    
    func hideImageLabel() {
        self.imageViewLabel.isHidden = true
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
            
            self.image = img
            completion(true)
        })
    }
}
