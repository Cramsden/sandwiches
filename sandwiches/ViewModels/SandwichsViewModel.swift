import Foundation
import UIKit

struct SandwichesViewModel {
    let noSammiesText = "😭\nNo sandwiches!\n You should make some, eh?\n🤔"
    private let service: Service

    var hasSandwiches: Bool {
        return service.sharedSandwiches.count > 0
    }

    var numberOfSandwiches: Int {
        return service.sharedSandwiches.count
    }

    init(service: Service = Service.shared()) {
        self.service = service
    }

    func sandwich(at index: Int) -> Sandwich? {
        return service.sharedSandwiches.elementMaybeAt(index)
    }

    func colorFor(_ sandwich: Sandwich) -> UIColor {
        switch sandwich.quality {
        case .expired: return .red
        case .expiresSoon: return .orange
        default: return .blue
        }
    }

    func remove(_ sandwich: Sandwich) {
        if let index = service.sharedSandwiches.index(of: sandwich) {
            service.removeSandwich(at: index)
        }
    }
}
