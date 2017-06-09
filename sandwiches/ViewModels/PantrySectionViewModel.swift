class PantrySectionViewModel: SectionViewModel {
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
