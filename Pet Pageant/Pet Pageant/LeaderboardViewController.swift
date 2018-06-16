
//  LeaderboardViewController.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 8/23/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.

import UIKit
import Parse

class LeaderboardViewController: UIViewController {
    
    @IBOutlet weak var textLabelView: UILabel!
    @IBOutlet weak var bottomBar: UITabBarItem!
    @IBOutlet weak var rightArrowButton: ArrowButton!
    @IBOutlet weak var leftArrowButton: ArrowButton!
    
    let recordManager = RecordManager()
    var viewSizeDefault: CGSize?
    var views = [RankView]()

    
    //MARK: VIEWCONTROLLER METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.flipRightButton()
        self.setupSwipes()
        self.instantiateViews()
        self.buttonsToForeground()
        self.animate(clockwise: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getTopRecords()
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
    
    fileprivate func getTopRecords() {
        self.recordManager.fetchTopRecordsForLeaderBoard(maxCount: gNumberOfRankViews) { (success) in
            if success == true {
                print("records fetch success")
                self.assignPetRecordToRankViews()
                for rankView in self.views {
                    rankView.fetchImageForRecord(completion: { (success) in
                        // did set img
                        rankView.hideImageLabel()
                        rankView.imageView.image = rankView.image
                    })
                }
            } else {
                print("retrying top records fetch")
                self.getTopRecords()
            }
        }
    }
    
    func assignPetRecordToRankViews() {
        
        for (index,rankView) in self.views.enumerated() {
            rankView.petRecord = self.recordManager.records.removeFirst()
            rankView.assignRank(rank: index + 1)
            rankView.updateLabels()
        }
    }
    
    fileprivate func instantiateViews() {
        self.views.removeAll()
        for index in 0..<gNumberOfRankViews {
            let angle = CGFloat(90 + index * (360/gNumberOfRankViews))
            let x = gCarouselCenterPoint.x + CGFloat(gScreenSize.width/2) * cos(angle * CGFloat(Double.pi/180))
            let y = gCarouselCenterPoint.y + CGFloat(gScreenSize.width/2) * sin(angle * CGFloat(Double.pi/180))
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
    
    func animate(clockwise: Bool) {
        
        for view in views {
            
            let currentAngle = self.angleFromPoint(pos: view.center)
            let nextAngle = self.getNextAngle(currentAngle: currentAngle, clockwise: clockwise)
            let destination = pointFromAngle(angle: nextAngle)
            
            UIView.animateKeyframes(withDuration: gLeaderBoardAnimationTime, delay: 0.0, options: .calculationModeCubicPaced, animations: {
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
            view.showImageLabel()
        } else {
            view.imageView.image = view.image
            view.hideImageLabel()
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
