import Foundation
import RxSwift

class ItemPresenter {
    fileprivate let subject = PublishSubject<[Item]>()

    var items: Observable<[Item]> { return subject }
    var myItems = [Item]()

    func add() {
        let r = arc4random() % 3
        let name: String
        switch r {
        case 0:
            name = "桃太郎"
        case 1:
            name = "金太郎"
        default:
            name = "浦島太郎"
        }
        myItems.append(Item(name: name))
        subject.onNext(myItems)
    }
    
    func removeAll() {
        myItems = [Item]()
        subject.onNext(myItems)
    }
}
