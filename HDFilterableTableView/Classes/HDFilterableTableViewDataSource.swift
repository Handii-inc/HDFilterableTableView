import UIKit

/**
 DataSource protocol. Please implement this protcol as view model.
 */
@objc public protocol HDFilterableTableViewDataSource: class {
    /**
     Filter data by input keyword. It may changes returning value from other methods after calling me.
     - note: This method is allowed to give itself side-effect.
     */
    func filter(by keyword: String?)
    
    /**
     Compatible with [UITableViewDataSource.tableView](https://developer.apple.com/documentation/uikit/uitableviewdatasource/1614861-tableview).
     */
    func tableView(cellForRowAt indexPath: IndexPath, createdBy cellFactory: TableViewCellFactory) -> UITableViewCell

    /**
     Compatible with [UITableViewDataSource.tableView](https://developer.apple.com/documentation/uikit/uitableviewdatasource/1614931-tableview).
     - Returns: Number of rows in input section.
     */
    func tableView(numberOfRowsInSection section: Int) -> Int

    /**
     Compatible with [UITableViewDataSource.numberOfSections](https://developer.apple.com/documentation/uikit/uitableviewdatasource/1614860-numberofsections).
     */
    @objc optional func numberOfSections() -> Int
    
    /**
     Compatible with [UITableViewDataSource.tableView](https://developer.apple.com/documentation/uikit/uitableviewdatasource/1614850-tableview).
     - Returns: Section header title.
     */
    @objc optional func tableView(titleForHeaderInSection section: Int) -> String?
}

