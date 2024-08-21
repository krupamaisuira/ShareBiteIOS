//
//  Utils.swift
//  ShareBiteApp
//
//  Created by User on 2024-06-26.
//

import Foundation
import UIKit

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
}

