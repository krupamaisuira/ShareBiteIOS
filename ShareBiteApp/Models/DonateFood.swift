import Foundation
import UIKit
import Firebase

class DonateFood: Decodable, Identifiable {
    var donationId: String?
    var donatedBy: String
    var title: String
    var description: String
    var bestBefore: String
    var price: Double
    var foodDeleted: Bool
    var createdOn: String
    var updatedOn: String?
    var status: Int
    var location: Location?
    var imageUris: [URL]?
    var uploadedImageUris: [URL]?
    var requestedBy: RequestFood?
    var saveImage: [UIImage]?

    var id: String {
        donationId ?? UUID().uuidString
    }

    init(donatedBy: String, title: String, description: String, bestBefore: String, price: Double, location: Location, imageUris: [URL], status: Int = FoodStatus.available.rawValue, saveImage: [UIImage]) {
        self.donatedBy = donatedBy
        self.title = title
        self.description = description
        self.bestBefore = bestBefore
        self.price = price
        self.foodDeleted = false
        self.status = (status > 0 ? status : FoodStatus.available.rawValue)
        self.createdOn = Utils.getCurrentDatetime()
        self.location = location
        self.imageUris = imageUris
        self.saveImage = saveImage
    }

    init?(from dict: [String: Any]) {
        guard let donatedBy = dict["donatedBy"] as? String,
              let title = dict["title"] as? String,
              let description = dict["description"] as? String,
              let bestBefore = dict["bestBefore"] as? String,
              let price = dict["price"] as? Double,
              let foodDeleted = dict["foodDeleted"] as? Bool,
              let createdOn = dict["createdOn"] as? String,
              let status = dict["status"] as? Int else {
            return nil
        }

        self.donatedBy = donatedBy
        self.title = title
        self.description = description
        self.bestBefore = bestBefore
        self.price = price
        self.foodDeleted = foodDeleted
        self.createdOn = createdOn
        self.status = status
        self.updatedOn = dict["updatedOn"] as? String
        
        if let locationDict = dict["location"] as? [String: Any],
           let address = locationDict["address"] as? String,
           let latitude = locationDict["latitude"] as? Double,
           let longitude = locationDict["longitude"] as? Double {
            self.location = Location(address: address, latitude: latitude, longitude: longitude)
        } else {
            self.location = nil
        }

        let imageUrisStrings = dict["imageUris"] as? [String] ?? []
        self.imageUris = imageUrisStrings.compactMap { URL(string: $0) }
        self.uploadedImageUris = nil
        self.saveImage = nil
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.donationId = try? container.decode(String.self, forKey: .donationId)
        self.donatedBy = try container.decode(String.self, forKey: .donatedBy)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.bestBefore = try container.decode(String.self, forKey: .bestBefore)
        self.price = try container.decode(Double.self, forKey: .price)
        self.foodDeleted = try container.decode(Bool.self, forKey: .foodDeleted)
        self.createdOn = try container.decode(String.self, forKey: .createdOn)
        self.updatedOn = try? container.decode(String.self, forKey: .updatedOn)
        self.status = try container.decode(Int.self, forKey: .status)
        self.location = try? container.decode(Location.self, forKey: .location)
        self.imageUris = try? container.decode([String].self, forKey: .imageUris).compactMap { URL(string: $0) }
        self.uploadedImageUris = nil
        self.saveImage = nil
    }

    private enum CodingKeys: String, CodingKey {
        case donationId, donatedBy, title, description, bestBefore, price, foodDeleted, createdOn, updatedOn, status, location, imageUris
    }

    func getFoodStatus() -> String {
        return FoodStatus.getByIndex(status)?.toString() ?? "Expired"
    }

    func toMap() -> [String: Any] {
        var result: [String: Any] = [:]
        result["donationId"] = donationId
        result["donatedBy"] = donatedBy
        result["title"] = title
        result["description"] = description
        result["bestBefore"] = bestBefore
        result["price"] = price
        result["foodDeleted"] = foodDeleted
        result["createdOn"] = createdOn
        result["status"] = status
        result["updatedOn"] = updatedOn
        return result
    }

    func toMapUpdate() -> [String: Any] {
        var result: [String: Any] = [:]
        result["title"] = title
        result["description"] = description
        result["bestBefore"] = bestBefore
        result["price"] = price
        result["updatedOn"] = updatedOn
        return result
    }
}
