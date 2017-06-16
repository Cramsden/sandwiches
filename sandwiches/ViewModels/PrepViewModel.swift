import Foundation

struct PrepViewModel: ViewModel {
    private let yummy = ["Hearty", "Tasty", "So Good", "Nommable",
                         "Ideal", "Great", "p amzng", "😍", "💣",
                         "Saucy", "Dope", "✨", "Special"
    ]
    private let sandwich = ["Hero", "Sandwich", "Sub", "Hoagie",
                            "Club", "Open-Faced", "Grinder", "Roll",
                            "Finger Sammy", "Burrito", "Gyro", "Panini",
                            "Slider", "Burger", "Special", "Footlong",
                            "Po'boy", "Hot Mess", "Taco", "Wrap", "Bahnmi"
    ]

    var pantry: Pantry
    var sectionVMs: [PrepSectionViewModel]

    init(pantry: Pantry) {
        self.pantry = pantry
        self.sectionVMs = Food.all().map { food in
            let itemsForFood = pantry[food] ?? []
            return PrepSectionViewModel(items: itemsForFood)
        }
    }

    var tldr: Pantry {
        var current: Pantry = [:]
        Food.all().enumerated().forEach { (index, food) in
            current[food] = sectionVMs[index].getItems()
        }

        return current
    }

    func generateRandomSammyName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return "\(dateFormatter.string(from: Date())) \(yummy.rando()) \(sandwich.rando())"
    }

    func removeIngredientAt(_ indexPath: IndexPath) -> Bool {
        deselectIngredientAt(indexPath)
        sectionVMs[indexPath.section].removeIngredientAt(row: indexPath.row)
        return true
    }

    func selectIngredientAt(_ indexPath: IndexPath) {
        sectionVMs[indexPath.section].toggleSelectionIngredientAt(row: indexPath.row)
    }

    func deselectIngredientAt(_ indexPath: IndexPath) {
        sectionVMs[indexPath.section].toggleSelectionIngredientAt(row: indexPath.row)
    }

    func ingredientSelectedAt(_ indexPath: IndexPath) -> Bool {
        return sectionVMs[indexPath.section].isIngredientSelectedAt(row: indexPath.row)
    }

    func gatherIngredientsForSandwich() -> [Ingredient] {
        var ingredients: [Ingredient] = []
        sectionVMs.forEach { sectionVM in
            ingredients.append(contentsOf: sectionVM.gatherSelectedIngredients())
        }
        return ingredients
    }

    func resetSelections() {
        sectionVMs.forEach {
            $0.deselectAllIngredients()
        }
    }

    var hasSelectedIngredients: Bool {
        return sectionVMs.reduce(0, { $0 + $1.selectedItemCount }) > 0
    }
}
