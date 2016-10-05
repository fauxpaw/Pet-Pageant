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
    
    var viewCenterPositions = [CGPoint]()
    var views = [UIView]()
    var pets = [Pet]() {
        didSet{
            var count = 0
            for pet in pets {
                let imageData = pet["imageFile"] as! PFFile
                imageData.getDataInBackgroundWithBlock({ (data: NSData?, error) in
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                    if (data != nil) {
                        let image = UIImage(data: data!)
                        print("first view? -> \(self.views[count])")
                        let rankview = self.views[count] as! RankView
                        rankview.imageView.image = image
                        
                    }
                    print("count: \(count)")
                    count += 1
                })
                
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSwipes()
        self.setupViews()
        self.fetchTopPets()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupSwipes(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(LeaderboardViewController.swipeGesture(_:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(LeaderboardViewController.swipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func setupViews() {
        self.views.removeAll()
        for index in 0..<carouselViewCount {
            let angle = CGFloat(90 + index * (360/carouselViewCount))
            let x = carouselCenterPoint.x + CGFloat(screenSize.width/2) * cos(angle * CGFloat(M_PI/180))
            let y = carouselCenterPoint.y + CGFloat(screenSize.width/2) * sin(angle * CGFloat(M_PI/180))
            let position = CGPoint(x: x, y: y)
            let view = RankView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            view.center = position
            self.viewCenterPositions.append(position)
            self.views.append(view)
            self.view.addSubview(view)
        }
    }
    
    func fetchTopPets(){
        let query = PFQuery(className: "Pet")
        query.orderByDescending("votes")
        query.limit = 5
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: "Could not retrieve data due to \(error.localizedDescription). Please try again later.", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                let petObjects = objects as! [Pet]
//                petObjects.sort({$0.votes > $1.votes})
                self.pets = petObjects
                print(self.pets)
            }
        }
    }
    
    func swipeGesture(gesture: UISwipeGestureRecognizer){
        
        if gesture.direction == UISwipeGestureRecognizerDirection.Left{
            CarouselView.rotateViewsClockwise(self, views: &self.views, completion: { (success) in
                CarouselView.toggleUserInteractionAfterAnimation(self, views: self.views)
            })
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.Right {
            CarouselView.rotateViewsCounterClockwise(self, views: &views, completion: { (success) in
                CarouselView.toggleUserInteractionAfterAnimation(self, views: self.views)
            })
        }
    }
}
