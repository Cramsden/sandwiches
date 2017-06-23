import Foundation

enum Quality {
    case yummy, expiresSoon, expired, none
}

struct Sandwich {
    let ingredients: [Ingredient]
    var quality: Quality
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
        self.quality = .none
        self.details = details
        setQuality()
    }

    func isNastierThan(_ sandwich: Sandwich) -> Bool {
        guard let otherLeastFresh = sandwich.leastFreshIngredient,
            let leastFresh = self.leastFreshIngredient else { return false }
        return leastFresh.bestBy < otherLeastFresh.bestBy
    }

    private mutating func setQuality() {
        guard let ingredient = leastFreshIngredient else { return }

        if ingredient.bestBy < Date() {
            self.quality = .expired
        } else if ingredient.bestBy <= Date.daysFromNow(2) {
            self.quality = .expiresSoon
        } else {
            self.quality = .yummy
        }
    }
}

extension Sandwich: Equatable {}

func == (lhs: Sandwich, rhs: Sandwich) -> Bool {
    return lhs.name == rhs.name &&
    lhs.details == rhs.details
}
