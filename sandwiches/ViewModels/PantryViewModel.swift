struct PantryViewModel {
    var pantry: Pantry
    var sectionVMs: [SectionViewModel]

    init(pantry: Pantry) {
        self.pantry = pantry
        self.sectionVMs = pantry.map { (food: Food, items: [Ingredient]) in
            return SectionViewModel(items: items)
        }
    }

    var numberOfTypesOfFood: Int {
        return Food.all().count
    }

    func numberOfItemsIn(_ section: Int) -> Int {
        guard section < sectionVMs.count else { return 0 }

        return sectionVMs[section].numberOfItems()
    }
}

class SectionViewModel {
    let items: [Ingredient]

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
}
