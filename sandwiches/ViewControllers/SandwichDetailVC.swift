import UIKit

class SandwichDetailVC: UIViewController {
    var sandwich: Sandwich?
    fileprivate let ingredientsPerRow = CGFloat(4)
    fileprivate let insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

    @IBOutlet weak var ingredientCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        title = sandwich?.name
    }
}

extension SandwichDetailVC: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sandwich?.ingredients.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let ingredients = sandwich?.ingredients,
            ingredients.count > indexPath.row,
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ingredientCell", for: indexPath)
            as? IngredientCell
            else { return UICollectionViewCell()}

        cell.nameLabel?.text = ingredients[indexPath.row].name
        return cell
    }
}

extension SandwichDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = insets.left * (ingredientsPerRow + 1)
        let width = view.frame.width - padding
        let widthPerIngredient = width / ingredientsPerRow
        return CGSize(width: widthPerIngredient, height: widthPerIngredient)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insets.left
    }
}
