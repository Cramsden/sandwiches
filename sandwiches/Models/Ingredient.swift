import Foundation

typealias JSONifiable = [String: Any]

enum Food: String {
    case bread, cheese, meat, spread, veggie, dunno
    
    static func all() -> [Food] {
        return [bread, cheese, meat, spread, veggie]
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
}
