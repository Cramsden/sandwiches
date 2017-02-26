import UIKit

class PrepVC: UIViewController {
    var selectedSandwichIngredients: [Ingredient]?
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let parent = parent as? ParentVC {
            selectedSandwichIngredients = parent.selectedIngredients
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PrepVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = selectedSandwichIngredients?[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSandwichIngredients?.count ?? 0
    }
}
