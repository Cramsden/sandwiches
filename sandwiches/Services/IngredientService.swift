import Foundation
import Alamofire
import SwiftyJSON

class IngredientService {
    private let dateFormatter = DateFormatter()

    func getAllIngredients(_ onCompletion: @escaping (Pantry) -> Void) {
        dateFormatter.dateFormat = "yyyy-mm-dd"

        Alamofire
            .request("http://localhost:8000/ingredients")
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                if let value = response.result.value {
                    let json = JSON(value)
                    onCompletion(self.buildPantryFrom(json))
                }
        }
    }

    private func dateFromString(_ dateString: String?) -> Date {
        guard let dateString = dateString  else { return Date() }
        return dateFormatter.date(from: dateString) ?? Date()
    }

    private func buildPantryFrom(_ json: JSON) -> Pantry {
        var results: Pantry = [:]
        Food.all().forEach { food in
            let foodArray = json[food.rawValue].arrayValue
            let ingredients = foodArray.map { json in
                Ingredient(
                    name: json["name"].stringValue,
                    details: json["details"].stringValue,
                    amount: json["amount"].intValue,
                    bestBy: self.dateFromString(json["best_by"].stringValue),
                    category: food
                )
            }

            results[food] = ingredients

        }

        return results
    }
}
