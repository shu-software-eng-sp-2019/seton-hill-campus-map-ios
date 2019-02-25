//
//  CustomMarker.swift
//  shu-campus-map-iOS
//
//  Created by Coltin Kifer on 2/20/19.
//  Copyright © 2019 Coltin Kifer. All rights reserved.
//

import Mapbox

class CustomMarker: NSObject, MGLAnnotation {
    // As a reimplementation of the MGLAnnotation protocol, we have to add mutable coordinate and (sub)title properties ourselves.
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    // Custom properties that we will use to customize the annotation's image.
    var image: UIImage?
    var reuseIdentifier: String?
    
    var color: UIColor?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
