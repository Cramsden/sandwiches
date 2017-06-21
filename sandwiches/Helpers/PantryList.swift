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

    func numberOfIngredientsIn(_ section: Int) -> Int {
        guard let foodForSection = Food.forSection(section) else { return 0 }
        return pantryIngredients[foodForSection]?.count ?? 0
    }

    func ingredientsFor(_ section: Int) -> [Ingredient]? {
        guard let food = Food.forSection(section) else { return nil }
        return pantryIngredients[food]
    }

    func ingredientFor(_ indexPath: IndexPath) -> Ingredient? {
        guard let ingredients = pantryIngredients[Food.all()[indexPath.section]],
            ingredients.count > indexPath.row else { return nil }

        return ingredients[indexPath.row]
    }

    func removeIngredientAt(_ indexPath: IndexPath) -> Bool {
        deselectIngredientAt(indexPath)
        guard let foodForSection = Food.forSection(indexPath.section),
            let ingredients = pantryIngredients[foodForSection],
            ingredients.count > indexPath.row else { return false }

        pantryIngredients[foodForSection]?.remove(at: indexPath.row)
        shiftSelectionsAfter(indexPath)
        return true
    }

    func toggleSelectionAt(_ indexPath: IndexPath) {
        ingredientSelectedAt(indexPath)
            ? deselectIngredientAt(indexPath)
            : selectIngredientAt(indexPath)
    }

    func ingredientSelectedAt(_ indexPath: IndexPath) -> Bool {
        return selectedIngredientPaths.contains(indexPath)
    }

    func gatherIngredientsForSandwich() -> [Ingredient] {
        let sandwichIngredients: [Ingredient] = selectedIngredientPaths.flatMap { selection in
            if let foodForSection = Food.forSection(selection.section),
                let ingredient = pantryIngredients[foodForSection]?[selection.row] {
                return ingredient
            }

            return nil
        }

        cleanUpSelectedIngredients()
        resetSelections()
        return sandwichIngredients
    }

    func resetSelections() {
        selectedIngredientPaths = []
    }

    private func cleanUpSelectedIngredients() {
        selectedIngredientPaths
            .sorted()
            .reversed()
            .forEach { selection in
                if let foodForSection = Food.forSection(selection.section) {
                    self.pantryIngredients[foodForSection]?.remove(at: selection.row)
                }
        }
    }

    private func shiftSelectionsAfter(_ indexPath: IndexPath) {
        selectedIngredientPaths = selectedIngredientPaths.map { selection -> IndexPath in
            if selection.greaterThanInSection(indexPath) {
                return IndexPath(row: selection.row-1, section: selection.section)
            }

            return selection
        }
    }

    private func selectIngredientAt(_ indexPath: IndexPath) {
        selectedIngredientPaths.append(indexPath)
    }

    private func deselectIngredientAt(_ indexPath: IndexPath) {
        if let matchingIndex = selectedIngredientPaths.index(of: indexPath) {
            selectedIngredientPaths.remove(at: matchingIndex)
        }
    }
}
