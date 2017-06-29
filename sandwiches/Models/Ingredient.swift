import Foundation

typealias JSONifiable = [String: Any]

enum Food: String {
    case bread, cheese, meat, spread, veggie, dunno
    static var all = [bread, cheese, meat, spread, veggie]

    static func forSection(_ number: Int) -> Food? {
        return all.elementMaybeAt(number)
    }
}

struct Ingredient {
    let name: String
    let details: String
    var amount: Int
    let bestBy: Date
    let nutritionInfoData: Data?
    var categoryRaw: String
    var category: Food {
        get {
            return Food(rawValue: categoryRaw) ?? .dunno
        }
        set {
            self.categoryRaw = newValue.rawValue
        }
    }

    init (name: String, details: String, amount: Int, bestBy: Date, category: Food) {
        self.name = name
        self.details = details
        self.amount = amount
        self.bestBy = bestBy
        self.categoryRaw = category.rawValue
        self.nutritionInfoData = nil
    }

    mutating func takeOneForPrep() -> Ingredient? {
        guard amount > 0 else { return nil }

        amount -= 1

        return Ingredient(
            name: name,
            details: details,
            amount: 1,
            bestBy: bestBy,
            category: category
        )
    }
}
