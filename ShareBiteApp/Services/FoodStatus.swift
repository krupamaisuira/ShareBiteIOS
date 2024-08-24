//
//  FoodStatus.swift
//  ShareBiteApp
//
//  Created by Vivek Patel on 2024-08-24.
//

import Foundation
enum FoodStatus: Int {
    case available = 1
    case requested = 2
    case donated = 3
    case expired = 4
    case cancelled = 5

    static func getByIndex(_ index: Int) -> FoodStatus? {
        return FoodStatus(rawValue: index)
    }

    func toString() -> String {
        switch self {
        case .available: return "Available"
        case .requested: return "Requested"
        case .donated: return "Donated"
        case .expired: return "Expired"
        case .cancelled: return "Cancelled"
        }
    }
}
