//
//  InvitationManager.swift
//  Alibaba
//
//  Created by 村上晋太郎 on 2016/07/02.
//  Copyright © 2016年 S. Murakami. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class InvitationManager: NSObject {
    let host = "10.201.120.98:3000"
    
    func index(complition: ((invitations: [Invitation]) -> Void)) {
        Alamofire.request(.GET, "http://\(host)/invite")
            .responseJSON {
                response in
                guard let object = response.result.value else {
                    NSLog("failed to get JSON from server...")
                    return
                }
                let json = JSON(object)
                
                let invitations: [Invitation] = (json.array ?? []).map { elem in
                    return Invitation(
                        id: elem["id"].int!,
                        category: elem["category"].string!,
                        status: elem["status"].string!,
                        lon: elem["lon"].double!,
                        lat: elem["lat"].double!,
                        limit: elem["limit"].int,
                        created_at: elem["created_at"].string!,
                        updated_at: elem["updated_at"].string!
                    )
                }
                
                complition(invitations: invitations)
        }
    }
    
    func create(category: String, lat: Double, lon: Double, complition: (() -> Void)? = nil) {
        Alamofire.request(
            .POST,
            "http://\(host)/invite",
            parameters: [
                "category": category,
                "lat": lat,
                "lon": lon
            ]).responseJSON {
                _ in
                if let c = complition {
                    complition
                }
        }
    }
    
    static let shared = InvitationManager()
}

struct Invitation {
    var id: Int
    var category: String
    var status: String
    var lon: Double
    var lat: Double
    var limit: Int?
    var created_at: String
    var updated_at: String
    
    func categoryImage() -> UIImage {
        return Invitation.imageForCategory(category)
    }
    
    static let categories = [
        "beer",
        "sushi",
        "wine",
        "cocktail",
        "karaoke",
        "juice",
        "meat",
        "donut",
        "coffee",
        ]
    
    static let categoryImageNames = [
        "icon001",
        "icon002",
        "icon003",
        "icon004",
        "icon005",
        "icon006",
        "icon007",
        "icon008",
        "icon009"
    ]
    
    static func imageForCategory(category: String) -> UIImage {
        let name: String
        if let index = categories.indexOf(category) {
            name = categoryImageNames[index]
        } else {
            name = categoryImageNames[0]
        }
        return UIImage(named: name) ?? UIImage()
    }

    
    static func mock() -> Invitation {
        return Invitation(id: 0, category: "", status: "", lon: 0, lat: 0, limit: nil, created_at: "", updated_at: "")
    }
}

