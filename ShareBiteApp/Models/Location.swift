import Foundation

class Location  : Decodable{
    var locationId: String?
    var donationId: String?
    var address: String
    var latitude: Double
    var longitude: Double
    var createdOn: String?
    var updatedOn: String?
    

    init(donationId: String, address: String, latitude: Double, longitude: Double) {
        self.donationId = donationId
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.createdOn = Utils.getCurrentDatetime()
    } 
    init(locationId : String, donationId: String, address: String, latitude: Double, longitude: Double) {
        self.locationId = locationId
        self.donationId = donationId
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.createdOn = Utils.getCurrentDatetime()
    } 
    init(address: String, latitude: Double, longitude: Double) {
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }

    func toMapUpdate() -> [String: Any] {
        var result: [String: Any] = [:]
        result["address"] = address
        result["longitude"] = longitude
        result["latitude"] = latitude
        result["updatedOn"] = updatedOn
        
        return result
    }
    func toMap() -> [String: Any] {
        var result: [String: Any] = [:]
        result["locationId"] = locationId
        result["donationId"] = donationId
        result["address"] = address
        result["longitude"] = longitude
        result["latitude"] = latitude
        result["createdOn"] = createdOn
        return result
    }
}


