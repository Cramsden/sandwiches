import UIKit

typealias Pantry = [Food: [Ingredient]]

class PantryVC: UIViewController {
    var ingredientService = IngredientService()
    var pantryVM: PantryViewModel?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SectionHeaderView.nib, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        tableView.tableFooterView = UIView()

        ingredientService.getAllIngredients { response in
            self.pantryVM = PantryViewModel(pantry: response)
            self.tableView.reloadData()
        }
    }
}

extension PantryVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return pantryVM?.numberOfTypesOfFood ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pantryVM?.visableRowsIn(section) ?? 0
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
        header.isOpen = pantryVM?.isOpenAt(section) ?? false
        header.section = section
        header.titleLabel.text = "\(food.rawValue.uppercased()) - \(pantryVM?.numberOfItemsIn(section) ?? 0) ITEMS"
        header.delegate = self
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ingredient = pantryVM?.ingredientAt(indexPath.row, andSection: indexPath.section) else {
            return UITableViewCell()
        }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "\(ingredient.name)")
        cell.selectionStyle = .gray
        cell.textLabel?.text = ingredient.name
        cell.detailTextLabel?.text = "Amount: \(ingredient.amount)"
        return cell
    }
}

extension PantryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFoodType = Food.all()[indexPath.section]
        guard let parent = parent as? ParentVC
            else { return }

        if let prepIngredient = pantryVM?.nabIngredientAt(indexPath.row, andSection: indexPath.section) {
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
        pantryVM?.toggleAtSection(section)
        let sectionIndexSet = IndexSet(arrayLiteral: section)
        tableView.reloadSections(sectionIndexSet, with: .automatic)
    }
}
