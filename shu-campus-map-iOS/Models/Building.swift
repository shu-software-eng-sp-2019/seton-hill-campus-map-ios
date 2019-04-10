//
//  Building.swift
//  shu-campus-map-iOS
//
//  Created by Coltin Kifer on 4/8/19.
//  Copyright © 2019 Coltin Kifer. All rights reserved.
//

import Foundation
import FirebaseFirestore.FIRGeoPoint

enum CodingKeys: CodingKey {
    case name
    case description
    case iconName
    case hasClassrooms
    case levels
    case type
    case coordinates
}

struct Building {
    
    var name: String
    var description: String // Could become an enum
    var iconName: String
    var hasClassrooms: Bool // from 1-3; could also be an enum
    var levels: Int // numRatings
    var type: String
    var coordinates: CustomGeoPoint
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "description": description,
            "iconName": iconName,
            "hasClassrooms": hasClassrooms,
            "levels": levels,
            "type": type,
            "coordinates": coordinates,
        ]
    }
}

extension Building: Encodable {
    
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let iconName = dictionary["iconName"] as? String,
            let hasClassrooms = dictionary["hasClassrooms"] as? Bool,
            let levels = dictionary["levels"] as? Int,
            let type = dictionary["type"] as? String else { return nil }
            let coordinates = dictionary["coordinates"] as? GeoPoint
        
        self.init(name: name, description: description, iconName: iconName, hasClassrooms: hasClassrooms,
                  levels: levels, type: type, coordinates: CustomGeoPoint(latitude: coordinates!.latitude, longitude: coordinates!.longitude))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name,  forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(iconName, forKey: .iconName)
        try container.encode(hasClassrooms, forKey: .hasClassrooms)
        try container.encode(levels, forKey: .levels)
        try container.encode(type, forKey: .type)
        try container.encode(coordinates, forKey: .coordinates)
    }
}
