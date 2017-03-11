//
//  ButtonVotingProtocol.swift
//  Pet Pageant
//
//  Created by Michael Sweeney on 3/10/17.
//  Copyright © 2017 Michael Sweeney. All rights reserved.
//

import Foundation


protocol ButtonVotingProtocol {
    
    func didVoteViaButton(forView: VoteView)
    func didPassViaButton(forView: VoteView)
    
}
