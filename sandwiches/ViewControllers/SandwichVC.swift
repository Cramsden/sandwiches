import UIKit

class SandwichVC: UIViewController {
    fileprivate var sandwiches: [Sandwich] = []

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let parent = parent as? ParentVC {
            sandwiches = parent.sharedSandwiches
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
        noSammiesLabel.text = "😭\nNo sandwiches!\n You should make some, eh?\n🤔"
        noSammiesLabel.textColor = UIColor.gray
        noSammiesLabel.textAlignment = .center
        noSammiesLabel.numberOfLines = 4
        tableView.backgroundView = noSammiesLabel
    }
}
