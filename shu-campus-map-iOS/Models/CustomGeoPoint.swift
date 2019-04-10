//
//  CustomGeoPoint.swift
//  shu-campus-map-iOS
//
//  Created by Coltin Kifer on 4/8/19.
//  Copyright © 2019 Coltin Kifer. All rights reserved.
//

import Foundation
import FirebaseFirestore.FIRGeoPoint

struct CustomGeoPoint : Codable {
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "_latitude"
        case longitude = "_longitude"
    }
}
