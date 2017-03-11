import UIKit

typealias Pantry = [Food: [Ingredient]]

class PantryVC: UIViewController {
    var selectedIngredients: [Ingredient] = []
    var pantry: Pantry = [:]
    var ingredientService = IngredientService()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        tableView.tableFooterView = UIView()

        ingredientService.getAllIngredients {response in
            self.pantry = response
            self.tableView.reloadData()
        }
    }
}

extension PantryVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Food.all().count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let food = Food.all()[section]
        return pantry[food]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let food = Food.all()[section]
        return "\(food.rawValue.uppercased()) - \(pantry[food]?.count ?? 0) ITEMS"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let food = Food.all()[section]

        guard let ingredients = pantry[food],
            ingredients.count > row else { return UITableViewCell() }

        let ingredientForRow = ingredients[row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "\(ingredientForRow.name)")
        cell.selectionStyle = .gray
        cell.textLabel?.text = ingredientForRow.name
        cell.detailTextLabel?.text = "Amount: \(ingredientForRow.amount)"
        return cell
    }
}

extension PantryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let selectedFoodType = Food.all()[section]
        guard let parent = parent as? ParentVC
            else { return }

        if let prepIngredient = self.pantry[selectedFoodType]?[row].takeOneForPrep() {
            if let _ = parent.sharedItems[selectedFoodType] {
                parent.sharedItems[selectedFoodType]!.append(prepIngredient)
            } else {
                parent.sharedItems[selectedFoodType] = [prepIngredient]
            }
            tableView.reloadData()
        }
    }
}
