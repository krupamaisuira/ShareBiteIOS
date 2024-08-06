//
//  Location.swift
//  ShareBiteApp
//
//  Created by User on 2024-08-06.
//

import Foundation
import CoreLocation

struct Location {
    var address: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var locationdeleted = false
    var createdon = Date()
}
