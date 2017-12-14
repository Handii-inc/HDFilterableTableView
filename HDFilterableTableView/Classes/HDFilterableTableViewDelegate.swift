import UIKit

public protocol HDFilterableTableViewDelegate: class {
    /**
     Compatible with [UITableViewDelegate.tableView](https://developer.apple.com/documentation/uikit/uitableviewdelegate/1614877-tableview).
     - parameter didSelectRowAt: Selected index.
     - parameter from: Datasource object.
     */
    func tableView(didSelectRowAt indexPath: IndexPath, from viewModel: HDFilterableTableViewDataSource)
}

