class PrepSectionViewModel: SectionViewModel {
    typealias SelectableIngredient = (selected: Bool, ingredient: Ingredient)

    private var ingredients: [SelectableIngredient]
    private (set) var isOpen = true
    let food: Food

    var selectedCount: Int {
        return ingredients.filter { $0.selected == true }.count
    }

    init(food: Food, ingredients: [Ingredient]) {
        self.isOpen = true
        self.food = food
        self.ingredients = ingredients.map {
            (selected: false, ingredient: $0)
        }
    }

    func toggle() {
        isOpen = !isOpen
    }

    func numberOfItems() -> Int {
        return ingredients.count
    }

    func removeIngredientAt(row index: Int) {
        ingredients.remove(at: index)
    }

    func ingredientAt(row index: Int) -> Ingredient? {
        guard let selectable = ingredients.elementMaybeAt(index) else { return nil }
        return selectable.ingredient
    }

    func toggleSelectionIngredientAt(row: Int) {
        guard row > 0 && row < ingredients.count else { return }
        ingredients[row].selected = !ingredients[row].selected
    }

    func isIngredientSelectedAt(row index: Int) -> Bool {
        guard let selectable = ingredients.elementMaybeAt(index) else { return false }
        return selectable.selected
    }

    func gatherSelectedIngredients() -> [Ingredient] {
        return ingredients.filter { $0.selected }
            .map { $0.ingredient }
    }

    func deselectAllIngredients() {
        for i in 0..<ingredients.count {
            ingredients[i].selected = false
        }
    }
}
