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

    func freshestIngredient() -> Ingredient? {
        guard let firstIngredient = ingredients.first else { return nil }
        return ingredients.reduce(firstIngredient) { (ingredient1: Ingredient, ingredient2: Ingredient) -> Ingredient in
            return ingredient1.bestBy > ingredient2.bestBy ? ingredient1 : ingredient2
        }
    }

    func isFresherThan(_ sandwich: Sandwich) -> Bool {
        guard let otherFreshestIngredient = sandwich.freshestIngredient(),
            let freshestIngredient = self.freshestIngredient() else { return false }
        return freshestIngredient.bestBy > otherFreshestIngredient.bestBy
    }
}
