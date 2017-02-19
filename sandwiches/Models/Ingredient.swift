import CoreData
typealias JSONifiable = [String: Any]

enum Food: String {
    case bread, cheese, meat, spread, veggie, dunno
    
    static func all() -> [Food] {
        return [bread, cheese, meat, spread, veggie]
    }
}

class Ingredient: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var details: String
    @NSManaged var amount: Int
    @NSManaged var bestBy: Date
    @NSManaged var nutritionInfoData: Data
    @NSManaged var categoryRaw: String

    var nutritionInfo: JSONifiable {
        get {
            return try! JSONSerialization.jsonObject(with: nutritionInfoData, options: .allowFragments) as! JSONifiable
        }
        set {
            nutritionInfoData = try! JSONSerialization.data(withJSONObject: nutritionInfo, options: .prettyPrinted)
        }
    }
    
    var category: Food {
        get {
            return Food(rawValue: categoryRaw) ?? .dunno
        }
        set {
            self.categoryRaw = newValue.rawValue
        }
    }
}
