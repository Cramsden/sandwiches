import UIKit

typealias Pantry = [Food: [Ingredient]]

class PantryVC : UIViewController {
    var pantry: Pantry?
    var ingredientService = IngredientService()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        ingredientService.getAllIngredients {  [weak self] response in
            self?.pantry = response
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PantryVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return pantry?.keys.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let food = Food.all()[section]
        return pantry?[food]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let section = indexPath.section
        let row = indexPath.row
        let food = Food.all()[section]

        guard let pantry = pantry,
            let ingredients = pantry[food],
            ingredients.count > row else { return cell }

        let ingredientForRow = ingredients[row]
        cell.textLabel?.text = ingredientForRow.name
        cell.detailTextLabel?.text = "Amount: \(ingredientForRow.amount)"
        return cell
    }
}
