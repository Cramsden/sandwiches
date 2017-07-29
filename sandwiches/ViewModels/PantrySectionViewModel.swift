class PantrySectionViewModel: SectionViewModel {
    private let service: Service
    private let food: Food
    private (set) var isOpen = true

    init(food: Food, service: Service = Service.shared()) {
        self.food = food
        self.service = service
    }

    func toggle() {
        isOpen = !isOpen
    }

    func numberOfItems() -> Int {
        return service.ingredientsInPantry(for: food).count
    }

    func removeIngredientAt(row index: Int) {
        service.removePantryIngredient(for: food, at: index)
    }

    func nabIngredientAt(row index: Int) {
        service.selectForPrep(from: food, at: index)
    }

    func ingredientAt(row index: Int) -> Ingredient? {
        return service.ingredientInPantry(for: food, at: index)
    }
}
