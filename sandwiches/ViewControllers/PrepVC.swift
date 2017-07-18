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
    fileprivate var closeSection = [false, false, false, false, false]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var preppedView: UIView!
    @IBOutlet weak var sammyTime: UIButton!
    @IBAction func sammyTimeTapped(_ sender: Any) {
        preppedView.isHidden = !preppedView.isHidden
    }

    @IBAction func cancelledSandwichTapped(_ sender: Any) {
        prepList.resetSelections()
        sammyTime.isEnabled = false
        preppedView.isHidden = true
        tableView.reloadData()
    }

    @IBAction func madeSandwichTapped(_ sender: Any) {
        present(buildSandwichAlert(), animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sammyTime.isEnabled = false
        tableView.tableFooterView = UIView()
        tableView.register(SectionHeaderView.nib, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
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
            self.sammyTime.isEnabled = false
            self.preppedView.isHidden = true
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
            self.sammyTime.isEnabled = false
            self.preppedView.isHidden = true
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
        guard !closeSection[section] else { return 0 }
        return prepList.numberOfIngredientsIn(section)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let food = Food.forSection(section) else { return "" }
        return "\(food.rawValue.uppercased()) - \(prepList.numberOfIngredientsIn(section)) ITEMS"
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let food = Food.forSection(section),
            let header = self.tableView.dequeueReusableHeaderFooterView(
                withIdentifier: SectionHeaderView.identifier)
                as? SectionHeaderView
            else { return nil }
        header.isOpen = !closeSection[section]
        header.section = section
        header.titleLabel.text = "\(food.rawValue.uppercased()) - \(prepList.numberOfIngredientsIn(section)) ITEMS"
        header.delegate = self
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ingredientForRow = prepList.ingredientFor(indexPath) else { return UITableViewCell() }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "\(ingredientForRow.name)")
        cell.textLabel?.text = ingredientForRow.name
        cell.selectionStyle = .none
        cell.accessoryType = prepList.ingredientSelectedAt(indexPath) ? .checkmark : .none
        return cell
    }
}

extension PrepVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        prepList.toggleSelectionAt(indexPath)
        let isSammyTime = !prepList.getSelectedIngredients().isEmpty
        sammyTime.isEnabled = isSammyTime ? true : false
        tableView.cellForRow(at: indexPath)?.accessoryType = prepList.ingredientSelectedAt(indexPath) ? .checkmark : .none
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        prepList.toggleSelectionAt(indexPath)
        let isSammyTime = !prepList.getSelectedIngredients().isEmpty
        sammyTime.isEnabled = isSammyTime ? true : false
        tableView.cellForRow(at: indexPath)?.accessoryType = prepList.ingredientSelectedAt(indexPath) ? .checkmark : .none
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
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
    }
}

extension PrepVC: SectionHeaderDelegate {
    func didTapHeader(in section: Int, shouldClose: Bool) {
        closeSection[section] = shouldClose
        let sectionIndexSet = IndexSet(arrayLiteral: section)
        tableView.reloadSections(sectionIndexSet, with: .automatic)
    }
}
