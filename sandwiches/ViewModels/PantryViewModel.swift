struct PantryViewModel: ViewModel {
    var pantry: Pantry
    var sectionVMs: [SectionViewModel]

    init(pantry: Pantry) {
        self.pantry = pantry
        self.sectionVMs = Food.all().map { food in
            let itemsForFood = pantry[food] ?? []
            return SectionViewModel(items: itemsForFood)
        }
    }

    func nabIngredientAt(_ row: Int, andSection section: Int) -> Ingredient? {
        guard section < sectionVMs.count else { return nil }
        return sectionVMs[section].nabIngredientAt(row: row)
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

    func removeIngredientAt(row index: Int) {
        items.remove(at: index)
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
