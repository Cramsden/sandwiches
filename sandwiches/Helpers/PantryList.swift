import Foundation

class PantryList {
    private var pantryIngredients: Pantry
    private var selectedIngredientPaths: [IndexPath] = []

    init(pantryIngredients: Pantry) {
        self.pantryIngredients = pantryIngredients
    }

    func getPantry() -> Pantry {
        return pantryIngredients
    }

    func getSelectedIngredients() -> [IndexPath] {
        return selectedIngredientPaths
    }

    func numberOfIngredientsInSection(_ number: Int) -> Int {
        let food = Food.all()[number]
        return pantryIngredients[food]?.count ?? 0
    }

    func ingredientFor(_ indexPath: IndexPath) -> Ingredient? {
        guard let ingredients = pantryIngredients[Food.all()[indexPath.section]],
            ingredients.count > indexPath.row else { return nil }

        return ingredients[indexPath.row]
    }

    func removeIngredientAt(_ indexPath: IndexPath) -> Bool {
        guard var ingredients = pantryIngredients[Food.all()[indexPath.section]],
            ingredients.count > indexPath.row else { return false }

        ingredients.remove(at: indexPath.row)
        shiftSelectionsAfter(indexPath)
        return true
    }

    func selectIngredientAt(_ indexPath: IndexPath) {
        selectedIngredientPaths.append(indexPath)
    }

    func deselectIngredientAt(_ indexPath: IndexPath) {
        if let matchingIndex = selectedIngredientPaths.index(of: indexPath) {
            selectedIngredientPaths.remove(at: matchingIndex)
        }
    }

    func ingredientSelectedAt(_ indexPath: IndexPath) -> Bool {
        return selectedIngredientPaths.contains(indexPath)
    }

    func gatherIngredientsForSandwich() -> [Ingredient] {
        let sandwichIngredients: [Ingredient] = selectedIngredientPaths.flatMap { selection in
            let foodType = Food.all()[selection.section]
            if let ingredient = pantryIngredients[foodType]?[selection.row] {
                return ingredient
            }

            return nil
        }

        removeSelectedIngredients()
        resetSelections()
        return sandwichIngredients
    }

    func resetSelections() {
        selectedIngredientPaths = []
    }

    private func removeSelectedIngredients() {
        selectedIngredientPaths
            .sorted()
            .reversed()
            .forEach { selection in
                let foodType = Food.all()[selection.section]
                self.pantryIngredients[foodType]?.remove(at: selection.row)
        }
    }

    private func shiftSelectionsAfter(_ indexPath: IndexPath) {
        selectedIngredientPaths = selectedIngredientPaths.map { selection in
            if selection.greaterThanInSection(indexPath) {
                return IndexPath(row: selection.row-1, section: selection.row)
            }

            return selection
        }
    }
}

extension IndexPath {
    func greaterThanInSection(_ indexPath: IndexPath) -> Bool {
        return (self.section == indexPath.section) && (self.row > indexPath.row)
    }
}
