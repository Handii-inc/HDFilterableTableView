import UIKit
import HDFilterableTableView

class FruitsData: HDFilterableTableViewDataSource {
    //MARK:- Properties
    private lazy var data: [(String, [String])] = SelfType.toDictionary(source: self.rawData)
    
    //MARK:- Method
    func getElement(indexPath: IndexPath) -> String
    {
        let (_, group) = self.data[indexPath.section]
        return group[indexPath.row]
    }
    
    //MARK:- HDFilterableTableViewDataSource
    func filter(by keyword: String?) {
        let filtered = self.rawData.filter { e in
            guard let w = keyword else {
                return true
            }
            
            return w == ""
                ? true  //Return ok when key word is null or empty.
                : e.lowercased().contains(w.lowercased())
        }
        self.data = SelfType.toDictionary(source: filtered)
    }
    
    func tableView(cellForRowAt indexPath: IndexPath, createdBy cellFactory: TableViewCellFactory) -> UITableViewCell {
        let cell = cellFactory.createCell(for: indexPath)
        if let label = cell.textLabel {
            label.text = self.getElement(indexPath: indexPath)
        }

        return cell
    }
    
    func tableView(numberOfRowsInSection section: Int) -> Int {
        let (_, group) = self.data[section]
        return group.count
    }
    
    func tableView(titleForHeaderInSection section: Int) -> String? {
        let (initial, _) = self.data[section]
        return initial
    }
    
    func numberOfSections() -> Int {
        return self.data.count
    }
    
    //MARK:- Privates
    private typealias SelfType = FruitsData
    
    private static func toDictionary(source: [String]) -> [(String, [String])]
    {
        let initials = source
            .map{ e in e[e.startIndex]}
            .map{ e in String(e)}
        let result = Array(Set(initials)).sorted()
            .map{ e in (e, source.filter{ x in x.starts(with: e) })}
        return result
    }
    
    //MARK:- Data
    private let rawData: [String] = [
        "Apple",
        "Apricot",
        "Avocado",
        "Banana",
        "Bilberry",
        "Blackberry",
        "Blackcurrant",
        "Blueberry",
        "Boysenberry",
        "Crab apples",
        "Currant",
        "Cherry",
        "Cherimoya",
        "Chico fruit",
        "Cloudberry",
        "Coconut",
        "Cranberry",
        "Cucumber",
        "Custard apple",
        "Damson",
        "Date",
        "Dragonfruit",
        "Durian",
        "Elderberry",
        "Feijoa",
        "Fig",
        "Goji berry",
        "Gooseberry",
        "Grape",
        "Grapefruit",
        "Guava",
        "Honeyberry",
        "Huckleberry",
        "Jabuticaba",
        "Jackfruit",
        "Jambul",
        "Jujube",
        "Juniper berry",
        "Kiwano",
        "Kiwifruit",
        "Kumquat",
        "Lemon",
        "Lime",
        "Loquat",
        "Longan",
        "Lychee",
        "Mango",
        "Mangosteen",
        "Marionberry",
        "Melon",
        "Miracle fruit",
        "Mulberry",
        "Nectarine",
        "Nance",
        "Olive",
        "Orange",
        "Papaya",
        "Passionfruit",
        "Peach",
        "Pear",
        "Persimmon",
        "Plantain",
        "Plum",
        "Pineapple",
        "Plumcot",
        "Pomegranate",
        "Pomelo",
        "Purple mangosteen",
        "Quince",
        "Raspberry",
        "Rambutan",
        "Redcurrant",
        "Salal berry",
        "Salak",
        "Satsuma",
        "Soursop",
        "Star fruit",
        "Gonzoberry",
        "Strawberry",
        "Tamarillo",
        "Tamarind",
        "Ugli fruit",
        "Yuzu",
    ]
}
