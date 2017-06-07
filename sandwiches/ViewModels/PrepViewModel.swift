import Foundation

class PrepViewModel: ViewModel {
    var pantry: Pantry
    var sectionVMs: [SectionViewModel]
    private (set) var selectedIngredientPaths: [IndexPath]

    init(pantry: Pantry) {
        self.pantry = pantry
        self.selectedIngredientPaths = []
        self.sectionVMs = Food.all().map { food in
            let itemsForFood = pantry[food] ?? []
            return SectionViewModel(items: itemsForFood)
        }
    }

    var tldr: Pantry {
        var current: Pantry = [:]
        Food.all().enumerated().forEach { (index, food) in
            current[food] = sectionVMs[index].items
        }

        return current
    }

    func ingredientsFor(_ section: Int) -> [Ingredient]? {
        guard let food = Food.forSection(section) else { return nil }
        return pantry[food]
    }

    func removeIngredientAt(_ indexPath: IndexPath) -> Bool {
        deselectIngredientAt(indexPath)
        sectionVMs[indexPath.section].removeIngredientAt(row: indexPath.row)
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
            if let ingredient = sectionVMs[selection.section].ingredientAt(row: selection.row) {
                return ingredient
            }

            return nil
        }

        cleanUpSelectedIngredients()
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
                _ = removeIngredientAt(selection)
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
}
