import UIKit
import RxSwift
import RealmSwift
import RxRealm
import RxDataSources

public class RealmAccessor<T: RealmEntity> {
    public typealias Entity = T

    fileprivate let disposeBag = DisposeBag()
    fileprivate var sectionModels: [SectionModel<String, String>] = []
    var observableItems: BehaviorSubject<[SectionModel<String, String>]>!

    
    public var realm: Realm { return try! Realm() }
    
    public init() {
        // observable を作成しているが、RealmSectionTableView の更新が上手くいかず再起動しないと TableView に反映されない
        observableItems = BehaviorSubject(value: sectionModels)
        Observable.from(optional: realm.objects(T.self))
            .subscribe(onNext: { [weak self] _ in
                self?.updateSectionModels()
            })
            .disposed(by: disposeBag)

        updateSectionModels()
    }

    public func entities() -> Results<T> {
        return realm.objects(T.self)
    }
    
    public func updateSectionModels() {
        var section0 = [String]()
        var section1 = [String]()
        var section2 = [String]()
        
        for i in 0..<entities().count {
            switch entities()[i].entityName {
            case "桃太郎": section0.append(entities()[i].entityName)
            case "金太郎": section1.append(entities()[i].entityName)
            case "浦島太郎": section2.append(entities()[i].entityName)
            default: break
            }
        }
        
        let models = [
            SectionModel(model: "桃太郎セクション", items: section0),
            SectionModel(model: "金太郎セクション", items: section1),
            SectionModel(model: "浦島太郎セクション", items: section2)]
        
        sectionModels = models
        observableItems.onNext(sectionModels)
    }
}

// MARK: - CRUD

extension RealmAccessor {
    
    public func create(withID id: Int? = nil) -> Entity {
        let ret = Entity()
        ret.id = id ?? autoIncrementedID
        
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

        ret.entityName = name
        
        try! realm.write {
            realm.add(ret, update: true)
        }
        return ret
    }

    public func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}

// MARK: - Utility

extension RealmAccessor {
    public var autoIncrementedID: Int {
        guard let max = realm.objects(Entity.self).sorted(byKeyPath: RealmEntity.IDKey, ascending: false).first else {
            return 0
        }
        return max.id + 1
    }
}

