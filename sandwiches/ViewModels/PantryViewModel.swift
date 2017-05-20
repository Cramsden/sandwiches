struct PantryViewModel {
    var pantry: Pantry
    var sectionVMs: [SectionViewModel]

    init(pantry: Pantry) {
        self.pantry = pantry
        self.sectionVMs = Food.all().map { food in
            let itemsForFood = pantry[food] ?? []
            return SectionViewModel(items: itemsForFood)
        }
    }

    var numberOfTypesOfFood: Int {
        return Food.all().count
    }

    func numberOfItemsIn(_ section: Int) -> Int {
        guard section < sectionVMs.count else { return 0 }

        return sectionVMs[section].numberOfItems()
    }

    func ingredientAt(_ row: Int, andSection section: Int) -> Ingredient? {
        guard section < sectionVMs.count else { return nil }
        return sectionVMs[section].ingredientAt(row: row)
    }

    func nabIngredientAt(_ row: Int, andSection section: Int) -> Ingredient? {
        guard section < sectionVMs.count else { return nil }
        return sectionVMs[section].nabIngredientAt(row: row)
    }
}

class SectionViewModel {
    var items: [Ingredient]
    private var isOpen = true

    init(items: [Ingredient]) {
        self.items = items
    }

    func toggle() {
        isOpen = !isOpen
    }

    func numberOfItems() -> Int {
        return isOpen ? items.count : 0
    }

    func nabIngredientAt(row index: Int) -> Ingredient? {
        guard index < items.count else { return nil }
        return items[index].takeOneForPrep()
    }

    func ingredientAt(row index: Int) -> Ingredient? {
        guard index < items.count else { return nil }
        return items[index]
    }
}
