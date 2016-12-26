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
                        rankview.rankLabel.text = "Rank: \(self.pets.index(of: pet))"
                        //rankview.votePercentageLabel.text = "\(pet.viewed)"
                        rankview.votePercentageLabel.text = "Votes per total views: \((100 * pet.votes/pet.viewed))%"
                        
                    }
                    
                    count += 1
                    if count == 5 {
                        print("Attempting sort")
                        self.sortViewsByRank()
                    }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupSwipes(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(LeaderboardViewController.swipeGesture(_:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(LeaderboardViewController.swipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
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
            view.currentPosition = position
            self.viewCenterPositions.append(position)
            self.views.append(view)
            self.view.addSubview(view)
        }
    }
    
    func sortViewsByRank() {
        //TODO: TODO - SORT FUNCTION
        //Check each views votes to the adjacent view and switch positions if B < A
        views.sort(by: { $0.votesLabel.text?.compare($1.votesLabel.text!) == ComparisonResult.orderedAscending })
    }
    
    func fetchTopPets(){
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
    }
}
