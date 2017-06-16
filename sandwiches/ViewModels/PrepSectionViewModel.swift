class PrepSectionViewModel: SectionViewModel {
    typealias SelectableIngredient = (isSelected: Bool, ingredent: Ingredient)

    var items: [SelectableIngredient]
    private (set) var selectedItemCount: Int
    private (set) var isOpen: Bool

    init(items: [Ingredient]) {
        self.selectedItemCount = 0
        self.isOpen = true
        self.items = items.map {
            (isSelected: false, ingredient: $0)
        }
    }

    func toggle() {
        isOpen = !isOpen
    }

    func getItems() -> [Ingredient] {
        return items.map { $0.ingredent }
    }

    func numberOfItems() -> Int {
        return items.count
    }

    func removeIngredientAt(row index: Int) {
        items.remove(at: index)
    }

    func nabIngredientAt(row index: Int) -> Ingredient? {
        guard index < items.count else { return nil }
        return items[index].ingredent.takeOneForPrep()
    }

    func ingredientAt(row index: Int) -> Ingredient? {
        guard index < items.count else { return nil }
        return items[index].ingredent
    }

    func toggleSelectionIngredientAt(row index: Int) {
        guard index < items.count else { return }
        items[index].isSelected = !items[index].isSelected
        updateCountForSelectionAt(index)
    }

    func isIngredientSelectedAt(row index: Int) -> Bool {
        guard index < items.count else { return false }
        return items[index].isSelected
    }

    func gatherSelectedIngredients() -> [Ingredient] {
        return items
            .filter { $0.isSelected }
            .flatMap { selectableIngredient in
                let ingredientToGather = selectableIngredient.ingredent
                if let index = items.index(where: { selectableIngredient.ingredent.name == $0.ingredent.name }) {
                    items.remove(at: index)
                    return ingredientToGather
                }
                return nil
        }
    }

    func deselectAllIngredients() {
        guard items.count > 0 else { return }

        for i in 0...items.count-1 {
            items[i].isSelected = false
        }

        selectedItemCount = 0
    }

    private func updateCountForSelectionAt(_ index: Int) {
        isIngredientSelectedAt(row: index) ?
            (selectedItemCount += 1) :
            (selectedItemCount -= 1)
    }
}
