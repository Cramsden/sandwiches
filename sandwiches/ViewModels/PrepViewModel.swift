import Foundation

class PrepViewModel {
    var pantry: Pantry
    private var selectedIngredientPaths: [IndexPath] = []
    var sectionVMs: [SectionViewModel]
    var numberOfTypesOfFood: Int {
        return Food.all().count
    }

    init(pantry: Pantry) {
        self.pantry = pantry
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

    func sectionHeaderLabel(for food: Food, in section: Int) -> String {
        return "\(food.rawValue.uppercased()) - \(numberOfItemsIn(section)) ITEMS"
    }

    func visableRowsIn(_ section: Int) -> Int {
        guard section < sectionVMs.count,
            sectionVMs[section].isOpen
            else { return 0 }

        return numberOfItemsIn(section)
    }

    private func numberOfItemsIn(_ section: Int) -> Int {
        guard section < sectionVMs.count else { return 0 }
        return sectionVMs[section].numberOfItems()
    }

    func getSelectedIngredients() -> [IndexPath] {
        return selectedIngredientPaths
    }

    func isOpenAt(_ section: Int) -> Bool {
        return sectionVMs[section].isOpen
    }

    func toggleAtSection(_ section: Int) {
        sectionVMs[section].toggle()
    }

    func ingredientsFor(_ section: Int) -> [Ingredient]? {
        guard let food = Food.forSection(section) else { return nil }
        return pantry[food]
    }

    func ingredientAt(_ row: Int, andSection section: Int) -> Ingredient? {
        guard section < sectionVMs.count else { return nil }
        return sectionVMs[section].ingredientAt(row: row)
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
