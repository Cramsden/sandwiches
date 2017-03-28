import UIKit

class ParentVC: UITabBarController {
    var sharedItems: Pantry = [:]
    var sharedSandwiches: [Sandwich] = [] {
        didSet {
            sharedSandwiches.sort(by: { $0.isNastierThan($1) })
        }
    }
}
