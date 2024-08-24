import Foundation
import UIKit
import Firebase


extension DonateFood: Identifiable {
    var id: String {
        donationId ?? UUID().uuidString // Use donationId if available, otherwise generate a UUID
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
    var location: Location?
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
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any] else {
            print("Failed to cast snapshot value to dictionary: \(snapshot.value ?? "No value")")
            return nil
        }

        let donatedBy = dict["donatedBy"] as? String ?? "Unknown donor"
        let title = dict["title"] as? String ?? "Untitled"
        let description = dict["description"] as? String ?? "No description"
        let bestBefore = dict["bestBefore"] as? String ?? "N/A"
        let price = dict["price"] as? Double ?? 0.0
        let foodDeleted = dict["foodDeleted"] as? Bool ?? false
        let createdOn = dict["createdOn"] as? String ?? "Unknown date"
        let status = dict["status"] as? Int ?? 0

        var location: Location? = nil
        if let locationDict = dict["location"] as? [String: Any],
           let address = locationDict["address"] as? String,
           let latitude = locationDict["latitude"] as? Double,
           let longitude = locationDict["longitude"] as? Double {
            location = Location(address: address, latitude: latitude, longitude: longitude)
        } else {
            print("Location data is missing or incomplete. Proceeding without location.")
        }

        let imageUrisStrings = dict["imageUris"] as? [String] ?? []

        self.donatedBy = donatedBy
        self.title = title
        self.description = description
        self.bestBefore = bestBefore
        self.price = price
        self.foodDeleted = foodDeleted
        self.createdOn = createdOn
        self.status = status
        self.location = location
        self.imageUris = imageUrisStrings.compactMap { URL(string: $0) }
        self.uploadedImageUris = nil
        self.saveImage = nil
        self.donationId = snapshot.key
    }
//    init?(snapshot: DataSnapshot) {
//           guard let dict = snapshot.value as? [String: Any],
//                 let donatedBy = dict["donatedBy"] as? String,
//                 let title = dict["title"] as? String,
//                 let description = dict["description"] as? String,
//                 let bestBefore = dict["bestBefore"] as? String,
//                 let price = dict["price"] as? Double,
//                 let foodDeleted = dict["foodDeleted"] as? Bool,
//                 let createdOn = dict["createdOn"] as? String,
//                 let status = dict["status"] as? Int,
//                 let locationDict = dict["location"] as? [String: Any],
//               
//                 let address = locationDict["address"] as? String,
//                 let latitude = locationDict["latitude"] as? Double,
//                 let longitude = locationDict["longitude"] as? Double,
//                 let imageUrisStrings = dict["imageUris"] as? [String] else {
//               return nil
//           }
//        self.donatedBy = donatedBy
//               self.title = title
//               self.description = description
//               self.bestBefore = bestBefore
//               self.price = price
//               self.foodDeleted = foodDeleted
//               self.createdOn = createdOn
//               self.status = status
//               self.location = Location(address: address, latitude: latitude, longitude: longitude)
//               self.imageUris = imageUrisStrings.compactMap { URL(string: $0) }
//               self.uploadedImageUris = nil  // Default to nil unless populated later
//               self.saveImage = nil  // Default to nil unless populated later
//               self.donationId = snapshot.key
//    }

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



