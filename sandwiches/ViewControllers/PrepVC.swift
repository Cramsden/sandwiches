import UIKit

class PrepVC: UIViewController {
    private let yummy = ["Hearty", "Tasty", "So Good", "Nommable", "Ideal", "Great", "p amzng", "😍", "💣"]
    fileprivate let dateFormatter = DateFormatter()
    fileprivate var prepList: PantryList = PantryList(pantryIngredients: [:])

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var preppedView: UIView!

    @IBAction func sammyTimeTapped(_ sender: Any) {
        let previously = preppedView.isHidden
        preppedView.isHidden = previously ? false : true
    }

    @IBAction func cancelledSandwichTapped(_ sender: Any) {
        prepList.resetSelections()
        preppedView.isHidden = true
        tableView.reloadData()
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
            prepList = PantryList(pantryIngredients: parent.sharedItems)
            preppedView.isHidden = true
            tableView.reloadData()
        }
    }

    private func makeSandwich() {
        let sandwichIngredients = prepList.gatherIngredientsForSandwich()

        if !sandwichIngredients.isEmpty {
            let sandwich = newSandwichFrom(sandwichIngredients)
            (parent as? ParentVC)?.sharedSandwiches.append(sandwich)
            (parent as? ParentVC)?.sharedItems = prepList.getPantry()
            tableView.reloadData()
        }
    }

    private func newSandwichFrom(_ ingredients: [Ingredient]) -> Sandwich {
        return Sandwich(
            name: "\(dateFormatter.string(from: Date())) \(yummy.rando()) Sandwich",
            ingredients: ingredients,
            details: ""
        )
    }
}

extension PrepVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Food.all().count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prepList.numberOfIngredientsInSection(section)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let food = Food.all()[section]
        return "\(food.rawValue.uppercased()) - \(prepList.numberOfIngredientsInSection(section)) ITEMS"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ingredientForRow = prepList.ingredientFor(indexPath) else { return UITableViewCell() }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "\(ingredientForRow.name)")
        cell.textLabel?.text = ingredientForRow.name
        cell.selectionStyle = .none
        cell.isSelected = prepList.ingredientSelectedAt(indexPath)
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        return cell
    }
}

extension PrepVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        prepList.selectIngredientAt(indexPath)
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        prepList.deselectIngredientAt(indexPath)
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Toss"
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if prepList.removeIngredientAt(indexPath) {
                (parent as? ParentVC)?.sharedItems = prepList.getPantry()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}
