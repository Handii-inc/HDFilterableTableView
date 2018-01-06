import UIKit

/**
 Fileterable table view controller.
 This controller already have search bar and table.
 */
open class HDFilterableTableViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UITableViewDataSource, TableViewCellFactory {
    //MARK:- Properties
    /**
     You can set height of search bar through this property. (default: 45)
     */
    public var searchBarHeight: CGFloat {
        get {
            return self.layout.searchBarHeight
        }
        set {
            self.layout.searchBarHeight = newValue
            self.updateLayout()
        }
    }

    open weak var delegate: HDFilterableTableViewDelegate?
    open weak var dataSource: HDFilterableTableViewDataSource?

    //MARK:- Sub components
    private lazy var searchBar: UISearchBar = UISearchBar()
    private lazy var table: UITableView = UITableView()
    
    //MARK:- Methods
    open func deselect()
    {
        guard let selected = self.table.indexPathForSelectedRow else {
            return  //do nothing.
        }
        self.table.deselectRow(at: selected, animated: true)
    }

    //MARK:- Life cycle events
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.searchBar)
        self.searchBar.delegate = self
        
        self.view.addSubview(self.table)
        self.table.delegate = self
        self.table.dataSource = self
        self.table.register(UITableViewCell.self,
                            forCellReuseIdentifier: self.cellId)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()        
        self.updateLayout()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.deselect()
    }

    //MARK:- UITableViewDataSource
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = self.dataSource else {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId,
                                                     for: indexPath as IndexPath)
            cell.textLabel?.text = "Fail to load this cell."
            return cell
        }
        return viewModel.tableView(cellForRowAt: indexPath, createdBy: self)
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.tableView(numberOfRowsInSection: section) ?? 0
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource?.numberOfSections?() ?? 1
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dataSource?.tableView?(titleForHeaderInSection: section) ?? nil
    }
    
    //MARK:- UITableViewDelegate
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = self.dataSource else {
            return  //do nothing
        }

        self.delegate?.tableView(didSelectRowAt: indexPath, from: viewModel)
    }
    
    //MARK:- UISearchBarDelegate
    open func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.dataSource?.filter(by: searchText)
        self.table.reloadData()
        return
    }
    
    //MARK:- TableViewCellFactory
    open func createCell(for indexPath: IndexPath) -> UITableViewCell {
        return self.table.dequeueReusableCell(withIdentifier: self.cellId,
                                              for: indexPath)
    }
    
    //MARK:- Privates
    private let cellId = String(describing: type(of: HDFilterableTableViewController.self))

    private lazy var layout: Layout = Layout(base: self.view);
    private class Layout {
        private unowned let base: UIView
        
        init(base: UIView) {
            self.base = base
        }
        
        var searchBarHeight: CGFloat = 45
        var searchBarFrame: CGRect {
            get {
                return CGRect(x: 0,
                              y: 0,
                              width: self.base.frame.width,
                              height: self.searchBarHeight)
            }
        }
        
        var tableFrame: CGRect {
            get {
                return CGRect(x: 0,
                              y: self.searchBarHeight,
                              width: self.base.frame.width,
                              height: self.base.frame.height - self.searchBarHeight)
            }
        }
    }
    
    private func updateLayout()
    {
        self.searchBar.frame = self.layout.searchBarFrame
        self.table.frame = self.layout.tableFrame
    }
}
