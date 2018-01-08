import UIKit
import HDFilterableTableView

class ViewController: HDFilterableTableViewController, UITableViewDelegate {
    private let viewModel = FruitsData()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.dataSource = self.viewModel
        self.delegate = self
    }

    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews()
        
        self.view.frame = UIScreen.main.bounds
        return
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
}

