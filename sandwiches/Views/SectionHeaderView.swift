import UIKit

protocol SectionHeaderDelegate: class {
    func didTapHeader(in section: Int, shouldClose: Bool)
}

class SectionHeaderView: UITableViewHeaderFooterView, UIGestureRecognizerDelegate {
    static let identifier = "SectionHeaderView"
    static let nib = UINib(nibName: identifier, bundle: nil)

    weak var delegate: SectionHeaderDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var containingView: UIView!

    var section: Int?
    var isOpen = true {
        didSet {
            rotateArrow()
        }
    }

    override func awakeFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        tap.delegate = self
        containingView.addGestureRecognizer(tap)
    }

    func headerTapped() {
        guard let section = section else { return }
        delegate?.didTapHeader(in: section, shouldClose: isOpen)
        isOpen = !isOpen
    }

    private func rotateArrow() {
        let angle = isOpen ? CGFloat(0) : -CGFloat(Double.pi/2)

        arrow.transform = CGAffineTransform(rotationAngle: angle)
    }
}
