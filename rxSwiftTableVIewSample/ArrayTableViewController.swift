import UIKit
import RxSwift
import RxCocoa

class ArrayTableViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textView: UITextView! // 配列の内容を表示する

    fileprivate let disposeBag = DisposeBag()
    fileprivate let presenter = ItemPresenter()
    fileprivate let dataSource = ItemDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // navigationItem の設定
        tabBarController?.navigationItem.leftBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presenter.removeAll()
                self?.textView.text = "ここに配列の中身を表示します"
            })
            .disposed(by: disposeBag)

        tabBarController?.navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presenter.add()
            })
            .disposed(by: disposeBag)
        
        
        // 配列に変更があったら textView を更新
        presenter.items
            .subscribe(onNext: { [weak self] items in
                var text: String = ""
                for n in items {
                    text = text + "\(n.name)\n"
                }
                self?.textView.text = text
            })
            .disposed(by: disposeBag)

        // 配列の Observable を tableView に bind する
        presenter.items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell")) { _, element, cell in
                cell.textLabel?.text = element.name
            }
            .addDisposableTo(disposeBag)
        
        
        // 配列の Observable を tableView に bind する (closure の引数に tableView を受け取るパターン)
//        presenter.items
//            .bind(to: tableView.rx.items) { tableView, row, element in
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//                cell?.textLabel?.text = element.name
//                return cell ?? UITableViewCell()
//            }
//            .addDisposableTo(disposeBag)


        // 配列の Observable を tableView に bind する (dataSource を指定するパターン)
//        presenter.items
//            .bind(to: tableView.rx.items(dataSource: dataSource))
//            .addDisposableTo(disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
