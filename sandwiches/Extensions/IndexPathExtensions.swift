import UIKit

extension IndexPath {
    func greaterThanInSection(_ indexPath: IndexPath) -> Bool {
        return (self.section == indexPath.section) && (self.row > indexPath.row)
    }
}
