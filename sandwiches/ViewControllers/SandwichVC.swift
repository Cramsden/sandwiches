import UIKit

class SandwichVC: UIViewController {
    fileprivate var sandwiches: [Sandwich] = []

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = true
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let parent = parent?.parent as? ParentVC {
            sandwiches = parent.sharedSandwiches
            sandwiches.sort(by: { $0.isNastierThan($1) })
            tableView.reloadData()
        }
    }
}

extension SandwichVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if sandwiches.isEmpty {
            addNoSammiesLabel()
            return 0
        }

        tableView.backgroundView = nil
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sandwiches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard sandwiches.count > indexPath.row else { return UITableViewCell() }

        let sandwichForRow = sandwiches[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "\(sandwichForRow.name)")
        cell.textLabel?.text = sandwichForRow.name
        cell.textLabel?.textColor = setColorFor(sandwich: sandwichForRow)
        return cell
    }

    private func setColorFor(sandwich: Sandwich) -> UIColor {
        if sandwich.isExpired() {
            return UIColor.red
        }

        if sandwich.expiresSoon() {
            return UIColor.orange
        }

        return UIColor.blue
    }

    private func addNoSammiesLabel() {
        let noSammiesLabel = UILabel(
            frame: CGRect(
                x: 0,
                y: 0,
                width: tableView.bounds.width,
                height: tableView.bounds.height
            )
        )
        noSammiesLabel.text = "😭\nNo sandwiches!\n You should make some, eh?\n🤔"
        noSammiesLabel.textColor = UIColor.gray
        noSammiesLabel.textAlignment = .center
        noSammiesLabel.numberOfLines = 4
        tableView.backgroundView = noSammiesLabel
    }
}

extension SandwichVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Eat"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "goToSandwich", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSandwich",
            let destination = segue.destination as? SandwichDetailVC,
            let selectedSandwichRow = tableView.indexPathForSelectedRow?.row {
            destination.sandwich = sandwiches[selectedSandwichRow]
        }
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            sandwiches.remove(at: indexPath.row)
            (parent?.parent as? ParentVC)?.sharedSandwiches.remove(at: indexPath.row)

            sandwiches.count == 0 ?
                tableView.reloadData()
                :
                tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
