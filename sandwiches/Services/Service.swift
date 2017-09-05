import Foundation

typealias Pantry = [Food:[Ingredient]]

class Service {
    private static var theOne = Service()

    private (set) var sharedPantry: Pantry = [:]
    private (set) var prepPantry: Pantry = [:]
    private (set) var sharedSandwiches: [Sandwich] = [] {
        didSet {
            sharedSandwiches.sort(by: { $0.isNastierThan($1) })
        }
    }

    static func shared() -> Service {
        return Service.theOne
    }

    func updatePantryWith(_ pantry: Pantry) {
        sharedPantry = pantry
    }

    func add(_ sandwich: Sandwich) {
        sharedSandwiches.append(sandwich)
    }

    func removeSandwich(at index: Int) {
                // BLAMMO 💣
        sharedSandwiches.remove(at: index)
    }

    func makeSandwichFrom(_ pantry: Pantry, with name: String, and detail: String) {
        var newPantry = Pantry()
        var sammyIngredients: [Ingredient] = []
        Food.all.forEach { food in
            var prepIngredients = prepPantry[food] ?? []
            pantry[food]?.forEach { ingredient in
                sammyIngredients.append(ingredient)
                if let index = prepIngredients.index(of: ingredient) {
                    prepIngredients.remove(at: index)
                }
            }
            newPantry[food] = prepIngredients
        }
        let newSammy = Sandwich(name: name, ingredients: sammyIngredients, details: detail)
        sharedSandwiches.append(newSammy)
        prepPantry = newPantry
        // TODO Sandwich
    }

    func ingredientsInPantry(for food: Food) -> [Ingredient] {
        return sharedPantry[food] ?? []
    }

    func ingredientsInPrep(for food: Food) -> [Ingredient] {
        return prepPantry[food] ?? []
    }

    func ingredientInPantry(for food: Food, at index: Int) -> Ingredient? {
        return ingredientsInPantry(for: food).elementMaybeAt(index)
    }

    func ingredientInPrep(for food: Food, at index: Int) -> Ingredient? {
        return ingredientsInPrep(for: food).elementMaybeAt(index)
    }

    func removePantryIngredient(for food: Food, at index: Int) {
        // BLAMMO 💣
        sharedPantry[food]?.remove(at: index)
    }

    func removePrepIngredient(for food: Food, at index: Int) {
        // BLAMMO 💣
        sharedPantry[food]?.remove(at: index)
    }

    func selectForPrep(from food: Food, at index: Int) {
        // BLAMMO 💣
        if let selectedItem = sharedPantry[food]?[index].takeOneForPrep() {
            if prepPantry[food] != nil {
                prepPantry[food]!.append(selectedItem)
            } else {
                prepPantry[food] = [selectedItem]
            }
        }
    }
}
