import Foundation
import RealmSwift

public class RealmEntity: Object {
    
    public static let IDKey       = "id"
    public static let NameKey     = "name"
    public static let CreatedKey  = "created"
    public static let ModifiedKey = "modified"
    
    public dynamic var id : Int = 0 // = RealmEntity.IDKey
    public dynamic var entityName : String = "" // = RealmEntity.Name
    public dynamic var created = Date() // = RealmEntity.CreatedKey
    public dynamic var modified = Date() // = RealmEntity.ModifiedKey
    
    public override static func primaryKey() -> String? {
        return RealmEntity.IDKey
    }
}
