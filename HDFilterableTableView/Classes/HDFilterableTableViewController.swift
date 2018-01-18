import UIKit

/**
 Fileterable table view controller.
 This controller already have search bar and table.
 */
open class HDFilterableTableViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, TableViewCellFactory {
    //MARK:- Properties
    /**
     You can set Y of search bar through this property. (default: 0)
     */
    public var searchBarY: CGFloat {
        get {
            return self.layouter.searchBarY
        }
        set {
            self.layouter.searchBarY = newValue
            self.layouter.update(self.components)
        }
    }
    
    /**
     You can set height of search bar through this property. (default: 45)
     */
    public var searchBarHeight: CGFloat {
        get {
            return self.layouter.searchBarHeight
        }
        set {
            self.layouter.searchBarHeight = newValue
            self.layouter.update(self.components)
        }
    }
    
    /**
     You can set search bar accessary of through this property.
     */
    public var searchBarInputAccessoryView: UIView? {
        get {
            return self.components.searchBar.inputAccessoryView
        }
        set {
            self.components.searchBar.inputAccessoryView = newValue
        }
    }

    open var delegate: UITableViewDelegate? {
        get {
            return self.components.table.delegate
        }
        set {
            self.components.table.delegate = newValue
        }
    }
    open weak var dataSource: HDFilterableTableViewDataSource? {
        didSet {
            self.components.table.dataSource = self
        }
    }
    
    //MARK:- Sub components
    private lazy var components: Components = Components()
    private class Components {
        lazy var searchBar: UISearchBar = UISearchBar()
        lazy var table: UITableView = UITableView()
        
        func deselect() {
            if let selected = self.table.indexPathForSelectedRow {
                self.table.deselectRow(at: selected, animated: true)
            }
            return
        }
        
        func didLoaded(by controller: HDFilterableTableViewController)
        {
            controller.view.addSubview(self.searchBar)
            self.searchBar.delegate = controller
            
            controller.view.addSubview(self.table)
        }
        
        func registerCell(forCellReuseIdentifier identifier: String)
        {
            self.table.register(UITableViewCell.self,
                                forCellReuseIdentifier: identifier)
            return
        }
    }
    
    //MARK:- Methods
    open func deselect()
    {
        self.components.deselect()
    }

    //MARK:- Life cycle events
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.components.didLoaded(by: self)
        self.components.registerCell(forCellReuseIdentifier: self.cellId)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.layouter.update(self.components)
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
    
    //MARK:- UISearchBarDelegate
    open func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.dataSource?.filter(by: searchText)
        self.components.table.reloadData()
        return
    }
    
    //MARK:- TableViewCellFactory
    open func createCell(for indexPath: IndexPath) -> UITableViewCell {
        return self.components.table.dequeueReusableCell(withIdentifier: self.cellId,
                                                         for: indexPath)
    }
    
    //MARK:- Privates
    private let cellId = String(describing: type(of: HDFilterableTableViewController.self))

    private lazy var layouter: Layout = Layout(base: self.view)
    private class Layout {
        private unowned let base: UIView
        
        init(base: UIView) {
            self.base = base
        }
        
        func update(_ components: Components) {
            components.searchBar.frame = self.searchBarFrame
            components.table.frame = self.tableFrame
            return
        }
        
        var searchBarY: CGFloat = 0
        var searchBarHeight: CGFloat = 45
        var searchBarFrame: CGRect {
            return CGRect(x: 0,
                          y: self.searchBarY,
                          width: self.base.frame.width,
                          height: self.searchBarHeight)
        }
        
        var tableFrame: CGRect {
            let y: CGFloat = self.searchBarFrame.maxY
            return CGRect(x: 0,
                          y: y,
                          width: self.base.frame.width,
                          height: self.base.frame.height - y)
        }
    }
}
