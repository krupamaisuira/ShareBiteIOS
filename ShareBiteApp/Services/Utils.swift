//
//  Utils.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-26.
//

import Foundation
import UIKit
import SwiftUI

struct Utils {
    static func isValidEmail(_ email: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isPasswordValid(_ password: String) -> Bool {
        
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d).{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    static func saveImageToDocumentsDirectory(image: UIImage, fileName: String) -> URL? {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
    
    static func loadImageFromDocumentsDirectory(fileName: String) -> UIImage? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }
    static func getCurrentDatetime() -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           dateFormatter.locale = Locale.current
           return dateFormatter.string(from: Date())
       }
    static func setStatusColors(for status: FoodStatus) -> (textColor: Color, backgroundColor: Color) {
        switch status {
        case .available:
            return (textColor: .white, backgroundColor: .blue)
        case .expired:
            return (textColor: .red, backgroundColor: Color.red.opacity(0.3))
        case .donated:
            return (textColor: .green, backgroundColor: Color.green.opacity(0.3))
        case .requested:
            return (textColor: .orange, backgroundColor: Color.yellow.opacity(0.3))
        case .cancelled:
            return (textColor: .gray, backgroundColor: Color.gray.opacity(0.3))
        default:
            return (textColor: .white, backgroundColor: .blue)
        }
    }
    static func isFoodExpired(bestBeforeDateStr: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        if let bestBeforeDate = dateFormatter.date(from: bestBeforeDateStr) {
            let currentDate = Date()
            
            if bestBeforeDate < currentDate {
                // The food is expired, return 0
                return 0
            } else {
                // The food is not expired, return 1
                return 1
            }
        } else {
            // If parsing the date fails, return 0
            return 0
        }
    }
}

