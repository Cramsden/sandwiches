import Foundation

class PrepViewModel: ViewModel {
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
    private let service: Service
    private (set) var sectionVMs: [PrepSectionViewModel]

    init(service: Service = Service.shared()) {
        self.service = service
        self.sectionVMs = Food.all.map { food in
            return PrepSectionViewModel(food: food, ingredients: service.ingredientsInPrep(for: food))
        }
    }

    var hasSelectedIngredients: Bool {
        return sectionVMs.reduce(0, { $0 + $1.selectedCount }) > 0
    }

    func generateRandomSammyName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return "\(dateFormatter.string(from: Date())) \(yummy.rando()) \(sandwich.rando())"
    }

    func removeIngredientAt(_ indexPath: IndexPath) -> Bool {
        guard let food = Food.forSection(indexPath.section) else { return false }
        service.removePrepIngredient(for: food, at: indexPath.row)
        sectionVMs[indexPath.section].removeIngredientAt(row: indexPath.row)
        return true
    }

    func toggleSectionAt(_ indexPath: IndexPath) {
        sectionVMs[indexPath.section].toggleSelectionIngredientAt(row: indexPath.row)
    }

    func ingredientSelectedAt(_ indexPath: IndexPath) -> Bool {
        return sectionVMs[indexPath.section].isIngredientSelectedAt(row: indexPath.row)
    }

    func makeSandwich(_ name: String? = nil, _ detail: String = "") {
        let sammyName = name ?? generateRandomSammyName()
        var sandwichStuff: Pantry = [:]
        sectionVMs.forEach { sectionVM in
            sandwichStuff[sectionVM.food] = sectionVM.gatherSelectedIngredients()
        }

        service.makeSandwichFrom(sandwichStuff, with: sammyName, and: detail)
        sectionVMs = Food.all.map { food in
            return PrepSectionViewModel(food: food, ingredients: service.ingredientsInPrep(for: food))
        }
    }

    func resetSelections() {
        sectionVMs.forEach {
            $0.deselectAllIngredients()
        }
    }
}
