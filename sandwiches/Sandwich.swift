import Foundation

struct Sandwich {
    let ingredients: [Ingredient]
    let name: String
    let details: String?

    init (name: String, ingredients: [Ingredient], details: String?) {
        self.name = name
        self.ingredients = ingredients
        self.details = details
    }
}
