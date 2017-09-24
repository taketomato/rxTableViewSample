import RxSwift
import RxDataSources

class RealmSectionViewController: UIViewController, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate let presenter = ItemPresenter()
    fileprivate let accessor = RealmItemAccessor()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // navigationItem の設定
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                _ = self?.accessor.create()
            })
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.accessor.deleteAll()
            })
            .disposed(by: disposeBag)
        
        dataSource.configureCell = { dataSource, tableView, indexPath, element in
            let cell = UITableViewCell()
            guard dataSource.sectionModels.count != 0 else { return cell }
            cell.textLabel?.text = dataSource.sectionModels[indexPath.section].items[indexPath.row]
            return cell
        }

        accessor.observableItems?
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard dataSource.sectionModels.count != 0 else { return nil }
        let view = UITableViewHeaderFooterView()
        view.textLabel?.text = dataSource.sectionModels[section].model
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }   
}
