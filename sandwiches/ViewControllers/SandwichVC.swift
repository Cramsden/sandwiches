import UIKit

class SandwichVC: UIViewController, Eater {
    fileprivate var viewModel = SandwichesViewModel()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = true
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    func eat(_ sandwich: Sandwich) {
        viewModel.remove(sandwich)
    }
}

extension SandwichVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.hasSandwiches {
            tableView.backgroundView = nil
            return 1
        } else {
            addNoSammiesLabel()
            return 0
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfSandwiches
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sandwich = viewModel.sandwich(at: indexPath.row) else { return UITableViewCell() }

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "\(sandwich.name)")
        cell.textLabel?.text = sandwich.name
        cell.textLabel?.textColor = viewModel.colorFor(sandwich)
        return cell
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
        noSammiesLabel.text = viewModel.noSammiesText
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
            let selectedSandwichRow = tableView.indexPathForSelectedRow?.row,
            let sandwich = viewModel.sandwich(at: selectedSandwichRow) {
            destination.sandwich = sandwich
            destination.delegate = self
        }
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        if let sammie = viewModel.sandwich(at: indexPath.row) {
            viewModel.remove(sammie)
        }

        viewModel.hasSandwiches
            ? tableView.deleteRows(at: [indexPath], with: .fade)
            : tableView.reloadData()
    }
}
