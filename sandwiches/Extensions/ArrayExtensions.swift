import Foundation

extension Array {
    func rando() -> Element {
        return self[Int(arc4random_uniform(UInt32(count)))]
    }

    func elementMaybeAt(_ index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
}
