import Foundation
import Alamofire
import SwiftyJSON

class IngredientService {
    private let dateFormatter = DateFormatter()
    
    func getAllIngredients(forFood: Food, _ onCompletion: @escaping ([Ingredient]) -> Void) {
        dateFormatter.dateFormat = "yyyy-mm-dd"
        
        Alamofire
            .request("http://localhost:8000/ingredients")
            .validate(statusCode: 200..<400)
            .responseJSON { response in
                if let value = response.result.value {
                    let json = JSON(value)
                    let breadArray = json["bread"].arrayValue
                    let ingredients = breadArray.map { json in
                        Ingredient(
                            name: json["name"].stringValue,
                            details: json["details"].stringValue,
                            amount: json["amount"].intValue,
                            bestBy: self.dateFromString(json["best_by"].stringValue),
                            category: .bread
                        )
                    }
                    
                    onCompletion(ingredients)
                }
        }
    }
    
    private func dateFromString(_ dateString: String?) -> Date {
        guard let dateString = dateString  else { return Date() }
        return dateFormatter.date(from: dateString) ?? Date()
    }
}
