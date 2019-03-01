import RealmSwift

class LocationModel : Object
{
    @objc dynamic var locationID = UUID().uuidString
    @objc dynamic var locationName = ""
    @objc dynamic var locationPlacemark = ""
    @objc dynamic var locatoinLatitude:Double = Double()
    @objc dynamic var locationLongitude:Double = Double()
    @objc dynamic var locationAltitude:Double = Double()
}
