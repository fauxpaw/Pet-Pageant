//
//  GlobalVars.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 9/19/16.
//  Copyright © 2016 Michael Sweeney. All rights reserved.
//
import UIKit

let gScreenSize: CGRect = UIScreen.main.bounds
let gThemeColor = #colorLiteral(red: 0.1253122985, green: 0.6035761833, blue: 0.8839741349, alpha: 1)
let gBackGroundColor = #colorLiteral(red: 1, green: 0.969643414, blue: 0.6297263503, alpha: 1)
let gTextColor = UIColor.white
let gCornerRadius: CGFloat = 15
let gCornerRadiusButton: CGFloat = 10
let gBorderWidthDefault: CGFloat = 2
let gdistanceBetweenViewsInRadians = 2.0 * Double.pi / Double(gNumberOfRankViews)

// vote
let gfetchQueryLimit = 50
let gVoteAnimationInTime = 0.95
let gVoteAnimationOutTime = 0.4

// leaderboard

let gLeaderBoardAnimationTime = 0.7
let gNumberOfRankViews: Int = 5
let gCarouselRankViewLargeScale : CGFloat = 1.2
let gCarouselRankViewSize = CGSize(width: gScreenSize.width/2, height: gScreenSize.width/2 + 75)
let gCarouselCenterPoint = CGPoint(x: gScreenSize.width/2, y: gScreenSize.height/2 - 110)

// profile
let gPhotoUploadLimit = 5


