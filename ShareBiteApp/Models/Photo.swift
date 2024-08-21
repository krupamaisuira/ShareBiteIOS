//
//  Photo.swift
//  ShareBiteApp
//
//  Created by User on 2024-08-06.
//

import Foundation
import UIKit
import Firebase

class Photos {
    var photoId: String?
    var donationId: String
    var imagePath: String?
    var order: Int
    var saveImage: [UIImage]?
    // Designated initializer
    init( donationId: String, imagePath: String, order: Int) {
       
        self.donationId = donationId
        self.imagePath = imagePath
        self.order = order
    }
    init( donationId: String, saveImage: [UIImage], order: Int) {
       
        self.donationId = donationId
        self.saveImage = saveImage
        self.order = order
    }

    // Initializer using DataSnapshot
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
              let donationId = dict["donationId"] as? String,
              let imagePath = dict["imagePath"] as? String,
              let order = dict["order"] as? Int else {
            return nil
        }
        // The photoId will be the key of the snapshot
        self.photoId = snapshot.key
        self.donationId = donationId
        self.imagePath = imagePath
        self.order = order
    }
    func toDictionary() -> [String: Any] {
           return [
               "donationId": donationId,
               "imagePath": imagePath,
               "order": order,
               "photoId": photoId as Any
           ]
       }
}

