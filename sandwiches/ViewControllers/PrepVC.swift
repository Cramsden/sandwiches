import UIKit

class PrepVC: UIViewController {
    fileprivate let dateFormatter = DateFormatter()
    fileprivate var selectedIndexPaths: [IndexPath] = []
    fileprivate var prepIngredients: Pantry = [:]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var preppedView: UIView!

    @IBAction func sammyTimeTapped(_ sender: Any) {
        let previously = preppedView.isHidden
        preppedView.isHidden = previously ? false : true
    }

    @IBAction func madeSandwichTapped(_ sender: Any) {
        makeSandwich()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "HH:mm"
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let parent = parent as? ParentVC {
            prepIngredients = parent.sharedItems
            selectedIndexPaths = []
            preppedView.isHidden = true
            tableView.reloadData()
        }
    }

    private func makeSandwich() {
        var sandwichIngredients: [Ingredient] = []

        selectedIndexPaths.forEach { selection in
            let foodType = Food.all()[selection.section]
            if let ingredient = prepIngredients[foodType]?[selection.row] {
                sandwichIngredients.append(ingredient)
            }
        }

        if !sandwichIngredients.isEmpty {
            let sandwich = newSandwichFrom(sandwichIngredients)
            (parent as? ParentVC)?.sharedSandwiches.append(sandwich)
        }

        resetInventory()
        tableView.reloadData()
    }

    private func newSandwichFrom(_ ingredients: [Ingredient]) -> Sandwich {
        return Sandwich(
            name: "\(dateFormatter.string(from: Date())) Sandwich",
            ingredients: ingredients,
            details: ""
        )
    }

    private func resetInventory() {
        selectedIndexPaths.forEach { selection in
            let foodType = Food.all()[selection.section]
            (parent as? ParentVC)?.sharedItems[foodType]?.remove(at: selection.row)
            self.prepIngredients[foodType]?.remove(at: selection.row)
        }

        selectedIndexPaths = []
    }
}

extension PrepVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Food.all().count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let food = Food.all()[section]
        return prepIngredients[food]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let food = Food.all()[section]
        return "\(food.rawValue.uppercased()) - \(prepIngredients[food]?.count ?? 0) ITEMS"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let food = Food.all()[section]

        guard let ingredients = prepIngredients[food],
            ingredients.count > row else { return UITableViewCell() }

        let ingredientForRow = ingredients[row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "\(ingredientForRow.name)")
        cell.textLabel?.text = ingredientForRow.name
        cell.selectionStyle = .none
        cell.isSelected = selectedIndexPaths.contains(indexPath)
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        return cell
    }
}

extension PrepVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPaths.append(indexPath)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let matchingIndex = selectedIndexPaths.index(of: indexPath) {
            selectedIndexPaths.remove(at: matchingIndex)
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
}
