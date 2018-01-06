import UIKit
import HDFilterableTableView

class ViewController: HDFilterableTableViewController, HDFilterableTableViewDelegate {
    private let viewModel = FruitsData()
    
    private lazy var button: UIButton = {
        let component = UIButton(type: .roundedRect)
        component.addTarget(self,
                            action: #selector(self.toggleSearchBarHeight(sender:)),
                            for: .touchUpInside)
        component.backgroundColor = .black
        
        let title = NSAttributedString(string: "<>",
                                       attributes: [ .font: UIFont.boldSystemFont(ofSize: 15),
                                                     .foregroundColor: UIColor.white])
        component.setAttributedTitle(title, for: .normal)
        return component
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.addSubview(self.button)
        
        self.dataSource = self.viewModel
        self.delegate = self
    }

    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        
        self.view.frame = UIScreen.main.bounds
        self.button.frame = CGRect(x: self.view.frame.width - 60,
                                   y: self.view.frame.height - 60,
                                   width: 45,
                                   height: 45)
        self.button.layer.cornerRadius = 22.5
        
        return
    }
    
    func tableView(didSelectRowAt indexPath: IndexPath,
                   from viewModel: HDFilterableTableViewDataSource)
    {
        if self.viewModel !== viewModel {
            return  //do nothing.
        }
        
        let alert = UIAlertController(title: nil, 
                                      message: "Selected " + self.viewModel.getElement(indexPath: indexPath),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close",
                                      style: .default,
                                      handler: { e in self.deselect()}))
        self.present(alert,
                     animated: true,
                     completion: nil)
    }
    
     @objc private func toggleSearchBarHeight(sender: UIButton) {
        self.searchBarHeight = (self.searchBarHeight) == 45 ? 90 : 45
        return
    }
}

