struct PantryViewModel: ViewModel {
    var pantry: Pantry
    var sectionVMs: [PantrySectionViewModel]

    init(pantry: Pantry) {
        self.pantry = pantry
        self.sectionVMs = Food.all.map { food in
            let itemsForFood = pantry[food] ?? []
            return PantrySectionViewModel(items: itemsForFood)
        }
    }

    func nabIngredientAt(_ row: Int, andSection section: Int) -> Ingredient? {
        guard section < sectionVMs.count else { return nil }
        return sectionVMs[section].nabIngredientAt(row: row)
    }
}
