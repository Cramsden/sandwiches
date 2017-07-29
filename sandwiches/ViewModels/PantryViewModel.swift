struct PantryViewModel: ViewModel {
    var sectionVMs: [PantrySectionViewModel]

    init() {
        self.sectionVMs = Food.all.map { food in
            return PantrySectionViewModel(food: food)
        }
    }

    func nabIngredientAt(_ row: Int, andSection section: Int) {
        guard section < sectionVMs.count else { return }
        sectionVMs[section].nabIngredientAt(row: row)
    }
}
