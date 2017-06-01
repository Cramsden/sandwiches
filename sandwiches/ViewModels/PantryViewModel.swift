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

    func sectionHeaderLabel(for food: Food, in section: Int) -> String {
        return "\(food.rawValue.uppercased()) - \(numberOfItemsIn(section)) ITEMS"
    }

    func visableRowsIn(_ section: Int) -> Int {
        guard section < sectionVMs.count,
            sectionVMs[section].isOpen
            else { return 0 }

        return numberOfItemsIn(section)
    }

    func ingredientAt(_ row: Int, andSection section: Int) -> Ingredient? {
        guard section < sectionVMs.count else { return nil }
        return sectionVMs[section].ingredientAt(row: row)
    }

    func nabIngredientAt(_ row: Int, andSection section: Int) -> Ingredient? {
        guard section < sectionVMs.count else { return nil }
        return sectionVMs[section].nabIngredientAt(row: row)
    }

    func isOpenAt(_ section: Int) -> Bool {
        return sectionVMs[section].isOpen
    }

    func toggleAtSection(_ section: Int) {
        sectionVMs[section].toggle()
    }

    private func numberOfItemsIn(_ section: Int) -> Int {
        guard section < sectionVMs.count else { return 0 }
        return sectionVMs[section].numberOfItems()
    }
}

class SectionViewModel {
    var items: [Ingredient]
    private (set) var isOpen = true

    init(items: [Ingredient]) {
        self.items = items
    }

    func toggle() {
        isOpen = !isOpen
    }

    func numberOfItems() -> Int {
        return items.count
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
