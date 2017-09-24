import UIKit
import RxSwift
import RxCocoa

class ItemDataSource: NSObject, RxTableViewDataSourceType {
    typealias Element = [Item]
    var _itemModels: Element = []
    
    // MARK: - RxTableViewDataSourceType
    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        UIBindingObserver(UIElement: self) { (dataSource, element) in
            dataSource._itemModels = element
            tableView.reloadData()
            }
            .on(observedEvent)
    }
}

extension ItemDataSource: UITableViewDataSource {

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _itemModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let element = _itemModels[indexPath.row]
        cell.textLabel?.text = element.name
        return cell
    }
}
