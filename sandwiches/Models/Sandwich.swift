import Foundation

struct Sandwich {
    let ingredients: [Ingredient]
    let name: String
    let details: String?

    var leastFreshIngredient: Ingredient? {
        guard let firstIngredient = ingredients.first else { return nil }
        return ingredients.reduce(firstIngredient) {
            return $0.bestBy < $1.bestBy ? $0 : $1
        }
    }

    init (name: String, ingredients: [Ingredient], details: String?) {
        self.name = name
        self.ingredients = ingredients
        self.details = details
    }

    func isExpired() -> Bool {
        guard let leastFresh = leastFreshIngredient else { return false }
        return leastFresh.bestBy < Date()
    }

    func expiresSoon() -> Bool {
        guard let leastFresh = leastFreshIngredient else { return false }
        return leastFresh.bestBy < Date() - 1
    }

    func isNastierThan(_ sandwich: Sandwich) -> Bool {
        guard let otherLeastFresh = sandwich.leastFreshIngredient,
            let leastFresh = self.leastFreshIngredient else { return false }
        return leastFresh.bestBy < otherLeastFresh.bestBy
    }
}

extension Sandwich: Equatable {}

func == (lhs: Sandwich, rhs: Sandwich) -> Bool {
    return lhs.name == rhs.name &&
    lhs.details == rhs.details
}
