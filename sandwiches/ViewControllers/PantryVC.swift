import UIKit

class PantryVC : UIViewController {
    var ingredients: [Ingredient]?
    var ingredientService = IngredientService()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        ingredientService.getAllIngredients { [weak self] ingredients in
            self?.ingredients = ingredients
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PantryVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        if let ingredients = ingredients {
            let ingredient = ingredients[indexPath.row]
            cell.textLabel?.text = ingredient.name
            cell.detailTextLabel?.text = "Amount: \(ingredient.amount)"
        }
        
        return cell
    }
}
