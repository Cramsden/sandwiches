import UIKit

protocol SectionHeaderDelegate: class {
    func didTapHeader(in section: Int, shouldClose: Bool)
}

class SectionHeaderView: UITableViewHeaderFooterView {
    weak var delegate: SectionHeaderDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrow: UIImageView!

    var section: Int?
    var isOpen = true {
        didSet {
            rotateArrow()
        }
    }

    @IBAction func headerTapped(_ sender: Any) {
        guard let section = section else { return }
        self.delegate?.didTapHeader(in: section, shouldClose: isOpen)
        isOpen = !isOpen
    }

    private func rotateArrow() {
        let angle = isOpen ? CGFloat(0) : -CGFloat(Double.pi/2)

        arrow.transform = CGAffineTransform(rotationAngle: angle)
    }
}
