protocol ViewModel {
    associatedtype Section: SectionViewModel
    var pantry: Pantry { get }
    var sectionVMs: [Section] { get }
    var numberOfTypesOfFood: Int { get }

    func sectionHeaderTitle(for food: Food, in section: Int) -> String
    func visableRowsIn(_ section: Int) -> Int
    func ingredientAt(_ row: Int, andSection section: Int) -> Ingredient?
    func isOpenAt(_ section: Int) -> Bool
    func toggleAtSection(_ section: Int)
    func numberOfItemsIn(_ section: Int) -> Int
}

extension ViewModel {
    var numberOfTypesOfFood: Int {
        return Food.all().count
    }

    func sectionHeaderTitle(for food: Food, in section: Int) -> String {
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

    func isOpenAt(_ section: Int) -> Bool {
        return sectionVMs[section].isOpen
    }

    func toggleAtSection(_ section: Int) {
        sectionVMs[section].toggle()
    }

    func numberOfItemsIn(_ section: Int) -> Int {
        guard section < sectionVMs.count else { return 0 }
        return sectionVMs[section].numberOfItems()
    }
}

protocol SectionViewModel {
    var isOpen: Bool { get }
    func ingredientAt(row index: Int) -> Ingredient?
    func toggle()
    func numberOfItems() -> Int
}
