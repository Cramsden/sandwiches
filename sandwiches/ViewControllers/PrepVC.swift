import UIKit

class PrepVC: UIViewController {
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

    private var yesAction = UIAlertAction()
    fileprivate let dateFormatter = DateFormatter()
    fileprivate var prepList: PantryList = PantryList(pantryIngredients: [:])

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var preppedView: UIView!

    @IBAction func sammyTimeTapped(_ sender: Any) {
        if prepList.getSelectedIngredients().count > 0 || !preppedView.isHidden {
            preppedView.isHidden = !preppedView.isHidden
        }
    }

    @IBAction func cancelledSandwichTapped(_ sender: Any) {
        prepList.resetSelections()
        preppedView.isHidden = true
        tableView.reloadData()
    }

    @IBAction func madeSandwichTapped(_ sender: Any) {
        present(buildSandwichAlert(), animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let parent = parent as? ParentVC {
            prepList = PantryList(pantryIngredients: parent.sharedItems)
            preppedView.isHidden = true
            tableView.reloadData()
        }
    }

    private func buildSandwichAlert() -> UIAlertController {
        let alertController = UIAlertController(
            title: "Make A Sammy?",
            message: "Tell me a little more about your sammy!",
            preferredStyle: .alert
        )

        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Sammy Name: Required"
            textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        }

        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Sammie Description"
        }

        let surpriseMeAction = UIAlertAction(title: "Surprise Me!", style: .default) { _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            self.makeSandwichFrom(
                ingredients: self.prepList.gatherIngredientsForSandwich(),
                withName: "\(dateFormatter.string(from: Date())) \(self.yummy.rando()) \(self.sandwich.rando())"
            )
        }
        alertController.addAction(surpriseMeAction)

        yesAction = UIAlertAction(title: "Make it!", style: .default) { _ in
            let name = alertController.textFields?.first?.text ?? ""
            let detail = alertController.textFields?.last?.text ?? ""
            self.makeSandwichFrom(
                ingredients: self.prepList.gatherIngredientsForSandwich(),
                withName: name,
                andDetail: detail
            )
        }

        yesAction.isEnabled = false
        alertController.addAction(yesAction)

        return alertController
    }

    @objc private func textChanged(_ sender: UITextField) {
        yesAction.isEnabled = sender.text != ""
    }

    private func makeSandwichFrom(
        ingredients: [Ingredient],
        withName name: String,
        andDetail detail: String = ""
        ) {
        if !ingredients.isEmpty {
            let sandwich = newSandwichFrom(ingredients, withName: name, andDetail: detail)
            (parent as? ParentVC)?.sharedSandwiches.append(sandwich)
            (parent as? ParentVC)?.sharedItems = prepList.getPantry()
            tableView.reloadData()
        }
    }

    private func newSandwichFrom(
        _ ingredients: [Ingredient],
        withName name: String,
        andDetail detail: String
        ) -> Sandwich {
        return Sandwich(
            name: name,
            ingredients: ingredients,
            details: detail
        )
    }
}

extension PrepVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Food.all().count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prepList.numberOfIngredientsIn(section)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let food = Food.all()[section]
        return "\(food.rawValue.uppercased()) - \(prepList.numberOfIngredientsIn(section)) ITEMS"
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

    func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
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
        tableView.reloadSections(IndexSet(indexPath), with: .fade)
    }
}
