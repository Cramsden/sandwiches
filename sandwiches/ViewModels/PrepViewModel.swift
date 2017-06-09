import Foundation

class PrepViewModel: ViewModel {
    var pantry: Pantry
    var sectionVMs: [PrepSectionViewModel]

    init(pantry: Pantry) {
        self.pantry = pantry
        self.sectionVMs = Food.all().map { food in
            let itemsForFood = pantry[food] ?? []
            return PrepSectionViewModel(items: itemsForFood)
        }
    }

    var tldr: Pantry {
        var current: Pantry = [:]
        Food.all().enumerated().forEach { (index, food) in
            current[food] = sectionVMs[index].getItems()
        }

        return current
    }

    func removeIngredientAt(_ indexPath: IndexPath) -> Bool {
        deselectIngredientAt(indexPath)
        sectionVMs[indexPath.section].removeIngredientAt(row: indexPath.row)
        return true
    }

    func selectIngredientAt(_ indexPath: IndexPath) {
        sectionVMs[indexPath.section].toggleSelectedIngredientAt(row: indexPath.row)
    }

    func deselectIngredientAt(_ indexPath: IndexPath) {
        sectionVMs[indexPath.section].toggleSelectedIngredientAt(row: indexPath.row)
    }

    func ingredientSelectedAt(_ indexPath: IndexPath) -> Bool {
        return sectionVMs[indexPath.section].isIngredientSelectedAt(row: indexPath.row)
    }

    func gatherIngredientsForSandwich() -> [Ingredient] {
        var ingredients: [Ingredient] = []
        sectionVMs.forEach { sectionVM in
            ingredients.append(contentsOf: sectionVM.gatherSelectedIngredients())
        }
        return ingredients
    }

    func resetSelections() {
        sectionVMs.forEach {
            $0.deselectAllIngredients()
        }
    }

    var allIngredientsUnselected: Bool {
        for sectionVM in sectionVMs {
            for item in sectionVM.items {
                if item.isSelected {
                    return false
                }
            }
        }
        return true
    }
}
