import UIKit

class PrepVC: UIViewController {
    fileprivate var selectedIndexPaths: [IndexPath] = []
    fileprivate var prepIngredients: Pantry = [:]

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let parent = parent as? ParentVC {
            prepIngredients = parent.sharedItems
            selectedIndexPaths = []
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
