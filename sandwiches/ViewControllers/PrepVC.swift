import UIKit

class PrepVC: UIViewController {
    var selectedSandwichIngredients: [Ingredient]?
    var prepIngredients: Pantry?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let parent = parent as? ParentVC {
            prepIngredients = parent.sharedItems
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PrepVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Food.all().count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let food = Food.all()[section]
        return prepIngredients?[food]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let food = Food.all()[section]
        return "\(food.rawValue.uppercased()) - \(prepIngredients?[food]?.count ?? 0) ITEMS"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let food = Food.all()[section]

        guard let prepIngredients = prepIngredients,
            let ingredients = prepIngredients[food],
            ingredients.count > row else { return UITableViewCell() }

        let ingredientForRow = ingredients[row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "\(ingredientForRow.name)")
        cell.textLabel?.text = ingredientForRow.name
        return cell
    }
}
