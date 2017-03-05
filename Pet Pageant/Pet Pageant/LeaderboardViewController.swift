//
//  LeaderboardViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/23/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//

import UIKit
import Parse

class LeaderboardViewController: UIViewController {
    
    @IBOutlet weak var rightArrowButton: ArrowButton!
    @IBOutlet weak var leftArrowButton: ArrowButton!
    
    var views = [RankView]()
    var pets = [Pet]() {
        didSet{
            
            var count = 0
            
            for pet in pets {
                let imageData = pet["imageFile"] as! PFFile
                imageData.getDataInBackground(block: { (data: Data?, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                    if (data != nil) {
                        let image = UIImage(data: data!)
                        //print("first view? -> \(self.views[count])")
                        let rankview = self.views[count]
                        rankview.imageView.image = image
                        rankview.votesLabel.text = "Votes: \(pet.votes)"
                        if let number =  self.pets.index(of: pet) {
                            rankview.rankLabel.text = "Rank: \(number + 1)"
                        }
                        
                        rankview.imageView.layer.cornerRadius = gCornerRadius
                        if pet.viewed != 0 {
                            rankview.votePercentageLabel.text = "Votes of total views: \((100 * pet.votes/pet.viewed))%"
                        } else {
                            rankview.votePercentageLabel.text = "Photo has not yet been viewed"
                        }
                        
                        
                    }
                    
                    count += 1
                    if count == 5 {
                        self.sortViewsByRank()
                        self.view.isUserInteractionEnabled = true
                        self.leftArrowPressed(self)
                    }
                })
            }
        }
    }
    
    //MARK: VIEWCONTROLLER METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.flipRightButton()
        self.setupSwipes()
        self.view.isUserInteractionEnabled = false
        self.instantiateViews()
        self.fetchTopPets()
        self.buttonsToForeground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: CLASS METHODS
    
    fileprivate func buttonsToForeground() {
        let buttons = [leftArrowButton, rightArrowButton]
        for button in buttons {
            self.view.bringSubview(toFront: button!)
        }
    }
    
    fileprivate func flipRightButton () {
        rightArrowButton.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
    fileprivate func instantiateViews() {
        self.views.removeAll()
        for index in 0..<gCarouselViewCount {
            let angle = CGFloat(90 + index * (360/gCarouselViewCount))
            let x = gCarouselCenterPoint.x + CGFloat(gScreenSize.width/2) * cos(angle * CGFloat(M_PI/180))
            let y = gCarouselCenterPoint.y + CGFloat(gScreenSize.width/2) * sin(angle * CGFloat(M_PI/180))
            let position = CGPoint(x: x, y: y)
            let view = RankView(frame: CGRect(x: 0, y: 0, width: gScreenSize.width/2, height: gScreenSize.width/2 + 75))
            view.center = position
            view.currentPosition = position
            self.views.append(view)
            self.view.addSubview(view)
            //view.evaluateViewForResize(angle: angle)
        }
    }
    
    fileprivate func sortViewsByRank() {
        
        var count = 0
        var first = Int()
        var nextView = RankView()
        
        for (index, element) in views.enumerated() {
        
            if let rank1 = element.rankLabel.text {
                let ind = rank1.index(rank1.startIndex, offsetBy: 6)
                let cutString1 = rank1.substring(from: ind)
                if let numString1 = Int(cutString1) {
                    first = numString1
                    print(first)

                }
            }
            
            if index > 0 {
                nextView = views[index-1]
                if let rank2 = views[index-1].rankLabel.text {
                    //print("Next views rank: \(rank2)")
                    let ind = rank2.index(rank2.startIndex, offsetBy:6)
                    let cutString2 = rank2.substring(from: ind)
                    if let numString2 = Int(cutString2){
                        
                        if first < numString2 {
                            print("swappage")
                            self.swapViewPositions(first: element, second: nextView)
                            let temp = self.views.remove(at: index)
                            self.views.insert(temp, at: index-1)
                            self.sortViewsByRank()
                        }
                    }
                }
            }
            count += 1
        }
    }
    
    fileprivate func swapViewPositions(first: RankView, second: RankView){
        let tempPos : CGPoint = first.center
        first.center = second.center
        second.center = tempPos
        first.updateCenterPosition()
        second.updateCenterPosition()
    }
    
    fileprivate func fetchTopPets(){
        let query = PFQuery(className: "Pet")
        query.order(byDescending: "votes")
        query.limit = 5
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: "Could not retrieve data due to \(error.localizedDescription). Please try again later.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            else {
                let petObjects = objects as! [Pet]
                self.pets = petObjects
            }
        }
    }
    
    
    
    //MARK: GESTURES
    
    fileprivate func setupSwipes(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(LeaderboardViewController.swipeGesture(_:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(LeaderboardViewController.swipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func swipeGesture(_ gesture: UISwipeGestureRecognizer){
        
        if gesture.direction == UISwipeGestureRecognizerDirection.left {
            for view in views {
                view.animate(clockwise: true)
            }
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.right {
            for view in views {
                view.animate(clockwise: false)
            }
        }
        self.buttonsToForeground()
    }
    
    //MARK - ACTIONS
    
    @IBAction func leftArrowPressed(_ sender: Any) {
        
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .left
        swipeGesture(swipe)
        self.buttonsToForeground()
    }
    
    @IBAction func rightArrowPressed(_ sender: Any) {

        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .right
        swipeGesture(swipe)
        self.buttonsToForeground()
    }
    
}
