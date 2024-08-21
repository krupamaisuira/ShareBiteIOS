import Foundation
import UIKit

enum FoodStatus: Int {
    case available = 1
    case requested = 2
    case donated = 3

    static func getByIndex(_ index: Int) -> FoodStatus? {
        return FoodStatus(rawValue: index)
    }

    func toString() -> String {
        switch self {
        case .available: return "Available"
        case .requested: return "Requested"
        case .donated: return "Donated"
        }
    }
}

class DonateFood {
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
    var location: Location
    var imageUris: [URL]
    var uploadedImageUris: [URL]?
    var requestedBy: RequestFood?
    var saveImage: [UIImage]?

    init(donatedBy: String, title: String, description: String, bestBefore: String, price: Double, location: Location, imageUris: [URL], status: Int = FoodStatus.available.rawValue,saveImage : [UIImage]) {
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

    func getFoodStatus() -> String? {
        return FoodStatus.getByIndex(status)?.toString()
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



