import Foundation
import CoreData

enum FactoryError: Error {
    case rawFileReadFailure(fileName: String)
    case serializationFailure
}

struct IngredientFactory {
    static let resource = "Ingredients"
    
    static func build() throws {
        // TODO: Extract to service
        let url = Bundle.main.url(forResource: resource, withExtension: ".json")
        
        var fileContents: Data?
        do {
            fileContents = try Data(contentsOf: url!)
        } catch {
            throw FactoryError.rawFileReadFailure(fileName: resource)
        }
        
        let ingredients: JSONifiable?
        do {
            ingredients = try JSONSerialization.jsonObject(with: fileContents!, options: .allowFragments) as? JSONifiable
        } catch {
            throw FactoryError.serializationFailure
        }
        
        for food in Food.all() {
            guard let foodCollection = ingredients?[food.rawValue],
                let foodArray = foodCollection as? [JSONifiable]
            else { return }
            
            foodArray.forEach { foodItem in
//                guard let foodItem = validItem(foodItem) else { return }
//                let ingredient = Ingredient()
//                ingredient.name = foodItem["name"]
//                ingredient.details = foodItem["name"]
//                coredata.save(ingredient)
            }
        }
    }
    
//    static func validItem() -> Bool {}
}
