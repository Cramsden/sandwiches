import Foundation
import UIKit

struct SandwichesViewModel {
    let noSammiesText = "😭\nNo sandwiches!\n You should make some, eh?\n🤔"
    private var sandwiches: [Sandwich]

    var hasSandwiches: Bool {
        return sandwiches.count > 0
    }

    var numberOfSandwiches: Int {
        return sandwiches.count
    }

    init(sandwiches: [Sandwich]) {
        self.sandwiches = sandwiches
    }

    func sandwich(at index: Int) -> Sandwich? {
        return sandwiches.elementMaybeAt(index)
    }

    func colorFor(_ sandwich: Sandwich) -> UIColor {
        switch sandwich.quality {
        case .expired: return .red
        case .expiresSoon: return .orange
        default: return .blue
        }
    }

    mutating func remove(at index: Int) {
        sandwiches.remove(at: index)
    }
}
