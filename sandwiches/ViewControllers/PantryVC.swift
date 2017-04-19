import UIKit

typealias Pantry = [Food: [Ingredient]]

class PantryVC: UIViewController {
    var selectedIngredients: [Ingredient] = []
    var pantry: Pantry = [:]
    var ingredientService = IngredientService()
    fileprivate var closeSection = [false, false, false, false, false]

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SectionHeaderView.nib, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        tableView.tableFooterView = UIView()

        ingredientService.getAllIngredients { response in
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
        guard !closeSection[section],
            let food = Food.forSection(section) else { return 0 }
        return pantry[food]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let food = Food.forSection(section),
            let header = self.tableView.dequeueReusableHeaderFooterView(
                withIdentifier: SectionHeaderView.identifier)
                as? SectionHeaderView
            else { return nil }
        header.isOpen = !closeSection[section]
        header.section = section
        header.titleLabel.text = "\(food.rawValue.uppercased()) - \(pantry[food]?.count ?? 0) ITEMS"
        header.delegate = self
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row

        guard let food = Food.forSection(section),
            let ingredients = pantry[food],
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
            if parent.sharedItems[selectedFoodType] != nil {
                parent.sharedItems[selectedFoodType]!.append(prepIngredient)
            } else {
                parent.sharedItems[selectedFoodType] = [prepIngredient]
            }
            tableView.reloadData()
        }
    }
}

extension PantryVC: SectionHeaderDelegate {
    func didTapHeader(in section: Int, shouldClose: Bool) {
        closeSection[section] = shouldClose
        let sectionIndexSet = IndexSet(arrayLiteral: section)
        tableView.reloadSections(sectionIndexSet, with: .automatic)
    }
}
