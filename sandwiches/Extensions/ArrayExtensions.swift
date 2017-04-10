import Foundation

extension Array {
    func rando() -> Element {
        return self[Int(arc4random_uniform(UInt32(count)))]
    }

    func inRange(_ index: Int) -> Bool {
        return index >= 0 && index < count
    }
}
