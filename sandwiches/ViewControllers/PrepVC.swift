import UIKit

class PrepVC: UIViewController {
    private var yesAction = UIAlertAction()
    fileprivate var prepVM = PrepViewModel()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var preppedView: UIView!
    @IBOutlet weak var sammyTime: UIButton!
    @IBAction func sammyTimeTapped(_ sender: Any) {
        preppedView.isHidden = !preppedView.isHidden
    }

    @IBAction func cancelledSandwichTapped(_ sender: Any) {
        prepVM.resetSelections()
        sammyTime.isEnabled = prepVM.hasSelectedIngredients
        preppedView.isHidden = true
        tableView.reloadData()
    }

    @IBAction func madeSandwichTapped(_ sender: Any) {
        present(buildSandwichAlert(), animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        sammyTime.isEnabled = prepVM.hasSelectedIngredients
        tableView.tableFooterView = UIView()
        tableView.register(SectionHeaderView.nib, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        prepVM = PrepViewModel()
        preppedView.isHidden = true
        tableView.reloadData()
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
            textField.placeholder = "Sammy Description"
        }

        let surpriseMeAction = UIAlertAction(title: "Surprise Me!", style: .default) { _ in
            self.prepVM.makeSandwich()

            self.sammyTime.isEnabled = self.prepVM.hasSelectedIngredients
            self.preppedView.isHidden = true
        }
        alertController.addAction(surpriseMeAction)

        yesAction = UIAlertAction(title: "Make it!", style: .default) { _ in
            let name = alertController.textFields?.first?.text ?? "Name"
            let detail = alertController.textFields?.last?.text ?? "Detail"

            self.prepVM.makeSandwich(name, detail)

            self.sammyTime.isEnabled = self.prepVM.hasSelectedIngredients
            self.preppedView.isHidden = true
        }

        yesAction.isEnabled = false
        alertController.addAction(yesAction)

        return alertController
    }

    @objc private func textChanged(_ sender: UITextField) {
        yesAction.isEnabled = sender.text != ""
    }
}

extension PrepVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return prepVM.numberOfTypesOfFood
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prepVM.visableRowsIn(section)
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
        header.isOpen = prepVM.isOpenAt(section)
        header.section = section
        header.titleLabel.text = prepVM.sectionHeaderTitle(for: food, in: section)
        header.delegate = self
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ingredientForRow = prepVM.ingredientAt(indexPath.row, andSection: indexPath.section) else { return UITableViewCell() }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "\(ingredientForRow.name)")
        cell.textLabel?.text = ingredientForRow.name
        cell.selectionStyle = .none
        cell.accessoryType = prepVM.ingredientSelectedAt(indexPath) ? .checkmark : .none
        return cell
    }
}

extension PrepVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        prepVM.toggleSectionAt(indexPath)
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = prepVM.ingredientSelectedAt(indexPath) ? .checkmark : .none
        }
        sammyTime.isEnabled = prepVM.hasSelectedIngredients
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        prepVM.toggleSectionAt(indexPath)
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = prepVM.ingredientSelectedAt(indexPath) ? .checkmark : .none
        }
        sammyTime.isEnabled = prepVM.hasSelectedIngredients
    }

    func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Toss"
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        if prepVM.removeIngredientAt(indexPath) {
            tableView.deleteRows(at: [indexPath], with: .fade)
            sammyTime.isEnabled = prepVM.hasSelectedIngredients
        }

        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
    }
}

extension PrepVC: SectionHeaderDelegate {
    func didTapHeader(in section: Int, shouldClose: Bool) {
        prepVM.toggleAtSection(section)
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        let sectionHeaderRect = tableView.rectForHeader(inSection: section)
        tableView.scrollRectToVisible(sectionHeaderRect, animated: true)
    }
}
