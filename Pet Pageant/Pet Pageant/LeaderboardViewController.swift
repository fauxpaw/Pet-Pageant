
//  LeaderboardViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/23/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.

import UIKit
import Parse

class LeaderboardViewController: UIViewController {
    
    @IBOutlet weak var rightArrowButton: ArrowButton!
    @IBOutlet weak var leftArrowButton: ArrowButton!
    
    var viewSizeDefault: CGSize?
    var views = [RankView]()
    var pets = [Pet]() {
        didSet{
            
            var count = 0
            
            for pet in pets {
                let imageData = pet["imageFile"] as! PFFile
                weak var weakSelf = self
                imageData.getDataInBackground(block: { (data: Data?, error) in
                    guard let strongSelf = weakSelf else {return}
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                    if (data != nil) {
                        let image = UIImage(data: data!)
                        //print("first view? -> \(self.views[count])")
                        let rankview = strongSelf.views[count]
                        rankview.imageView.image = image
                        rankview.image = image
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
                        strongSelf.sortViewsByRank()
                        strongSelf.view.isUserInteractionEnabled = true
                        strongSelf.leftArrowPressed(strongSelf)
                    }
                })
            }
        }
    }
    
    //MARK: VIEWCONTROLLER METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: CLASS METHODS
    
    fileprivate func setup() {
        self.flipRightButton()
        self.setupSwipes()
        self.view.isUserInteractionEnabled = false
        self.instantiateViews()
        self.fetchTopPets()
        self.buttonsToForeground()
    }
    
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
            let tap = UITapGestureRecognizer(target: self, action: #selector(LeaderboardViewController.tapGesture(_:)))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tap)
            self.views.append(view)
            self.view.addSubview(view)
        }
        self.viewSizeDefault = self.views[0].frame.size
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

                }
            }
            
            if index > 0 {
                nextView = views[index-1]
                if let rank2 = views[index-1].rankLabel.text {
                    let ind = rank2.index(rank2.startIndex, offsetBy:6)
                    let cutString2 = rank2.substring(from: ind)
                    if let numString2 = Int(cutString2){
                        
                        if first < numString2 {
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
    
    func animate(clockwise: Bool) {
        
        for view in views {
            
            let currentAngle = self.angleFromPoint(pos: view.center)
            let nextAngle = self.getNextAngle(currentAngle: currentAngle, clockwise: clockwise)
            let destination = pointFromAngle(angle: nextAngle)
            
            UIView.animateKeyframes(withDuration: gAnimationTime, delay: 0.0, options: .calculationModeCubicPaced, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0, animations: {
                    
                    switch destination.y {
                    case 0..<gCarouselCenterPoint.y:
                        self.view.sendSubview(toBack: view)
                        if view.frame.size == self.viewSizeDefault {
                            view.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                        }
                        
                    case (gCarouselCenterPoint.y)..<gCarouselCenterPoint.y + gScreenSize.width / 2 - 1:
                        view.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    case gCarouselCenterPoint.y + gScreenSize.width / 2:
                        self.view.bringSubview(toFront: view)
                        view.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    default:
                        print("Triggered switch default like a bad")
                    }
                    
                    view.center = destination
                })
            }) { (finished) in
                //Anything important to do after animations complete
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func getNextAngle (currentAngle: CGFloat, clockwise: Bool) -> CGFloat {
        
        
        if clockwise == true {
            return currentAngle + CGFloat(gdistanceBetweenViewsInRadians)
        }
        else {
            return currentAngle - CGFloat(gdistanceBetweenViewsInRadians)
        }
    }
    
    public func angleFromPoint (pos: CGPoint) -> CGFloat {
        let angle = atan2(pos.y - gCarouselCenterPoint.y, pos.x - gCarouselCenterPoint.x)
        return angle
    }
    
    fileprivate func pointFromAngle (angle: CGFloat) -> CGPoint {
        //(x,y) = cx + rcos0, cy + sin0
        return CGPoint(x: gCarouselCenterPoint.x + (gScreenSize.width/2) * cos(angle), y:gCarouselCenterPoint.y + (gScreenSize.width/2) * sin(angle))
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
            self.animate(clockwise: true)
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.right {
            
            self.animate(clockwise: false)
        }
        self.buttonsToForeground()
    }
    
    func tapGesture(_ gesture: UITapGestureRecognizer){
        
        let view = gesture.view as! RankView
        
        if view.imageView.image != nil{
            view.imageView.image = nil
        } else {
            view.imageView.image = view.image
        }
    }
    
    //MARK - ACTIONS
    
    @IBAction func leftArrowPressed(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .left
        swipeGesture(swipe)
        self.buttonsToForeground()
    }
    
    @IBAction func rightArrowPressed(_ sender: Any) {
        self.view.isUserInteractionEnabled = false
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .right
        swipeGesture(swipe)
        self.buttonsToForeground()
    }
    
}
