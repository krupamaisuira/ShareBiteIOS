//
//  RequestFood.swift
//  ShareBiteApp
//
//  Created by User on 2024-08-20.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class RequestFood : Decodable {
    var requestId: String?
    var requestforId: String?
    var requestedBy: String?
    var requestedon: String?
    var requestedUserDetail: Users?
    var cancelby: String?
    var cancelon: String?
    
    init(requestforId: String?, requestedBy: String?, cancelBy: String?, cancelon: String?) {
        self.requestforId = requestforId
        self.requestedBy = requestedBy
        self.cancelby = cancelBy
        self.cancelon = cancelon
        self.requestedon = Utils.getCurrentDatetime()
    }
    init?(snapshot: DataSnapshot) {
           guard let value = snapshot.value as? [String: Any] else {
               return nil
           }
           
           self.requestId = value["requestId"] as? String
           self.requestforId = value["requestforId"] as? String
           self.requestedBy = value["requestedBy"] as? String
           self.cancelon = value["cancelon"] as? String
           self.cancelby = value["cancelby"] as? String
          
       }
    // Default initializer
    init() {}
    

    func toMapUpdate() -> [String: Any] {
        var result: [String: Any] = [
            "requestId": requestId,
            "requestforId": requestforId,
            "requestedBy":requestedBy,
            "requestedon":requestedon
        ]
        return result
    }
}

