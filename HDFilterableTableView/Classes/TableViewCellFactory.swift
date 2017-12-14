import Foundation

@objc public protocol TableViewCellFactory {
    func createCell(for indexPath: IndexPath) -> UITableViewCell
}
