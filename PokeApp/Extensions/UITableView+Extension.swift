import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cell type: T.Type) {
        register(type, forCellReuseIdentifier: String(describing: T.self))
    }
}
