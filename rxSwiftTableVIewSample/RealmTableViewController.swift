import UIKit
import RxSwift
import RxRealm
import RealmSwift

class RealmTableViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    fileprivate let disposeBag = DisposeBag()
    let accessor = RealmItemAccessor()

    override func viewDidLoad() {
        super.viewDidLoad()

        // navigationItem の設定
        tabBarController?.navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: { [weak self] in
            _ = self?.accessor.create()
        })
            .disposed(by: disposeBag)
        
        tabBarController?.navigationItem.leftBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.accessor.deleteAll()
            })
            .disposed(by: disposeBag)
        
        // Realm の変更を subscribe する
        Observable.changeset(from: accessor.entities())
            .subscribe(onNext: {[unowned self] results, changes in
                if let changes = changes {
                    self.tableView.applyChangeset(changes)
                } else {
                    self.tableView.reloadData()
                }
            })
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }   
}

extension RealmTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessor.entities().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entity = accessor.entities()[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = entity.entityName
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
}

extension RealmTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Observable.from([accessor.entities()[indexPath.row]])
            .subscribe(Realm.rx.delete())
            .addDisposableTo(disposeBag)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

extension UITableView {
    func applyChangeset(_ changes: RealmChangeset) {
        beginUpdates()
        deleteRows(at: changes.deleted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        insertRows(at: changes.inserted.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        reloadRows(at: changes.updated.map { IndexPath(row: $0, section: 0) }, with: .automatic)
        endUpdates()
    }
}
