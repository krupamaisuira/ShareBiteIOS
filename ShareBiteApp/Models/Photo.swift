//
//  Photo.swift
//  ShareBiteApp
//
//  Created by User on 2024-08-06.
//

import Foundation

struct Photos: Identifiable, Codable {
    var id: UUID
    var donationId: String
    var photoPath: String
    var profileDeleted: Bool
    var createdOn: Date

    init(id: UUID = UUID(), donationId: String, photoPath: String, profileDeleted: Bool = false, createdOn: Date = Date()) {
        self.id = id
        self.donationId = donationId
        self.photoPath = photoPath
        self.profileDeleted = profileDeleted
        self.createdOn = createdOn
    }
}
