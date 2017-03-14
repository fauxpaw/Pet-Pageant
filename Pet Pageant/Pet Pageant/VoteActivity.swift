import UIKit


//Future update implementation for voteview menu actions
class VoteActivity: UIActivity {
    
    override class var activityCategory: UIActivityCategory {
        return .action
    }
    
    override var activityType: UIActivityType? {
        guard let bundleId = Bundle.main.bundleIdentifier else {return nil}
        return UIActivityType(rawValue: bundleId + "\(self.classForCoder)")
    }
    
    override var activityTitle: String? {
        return "VoteActivity"
    }
    
    override var activityImage: UIImage? {
        return UIImage(named: "GreenCheck")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        
    }
    
    override func perform() {
        activityDidFinish(true)
    }
}
