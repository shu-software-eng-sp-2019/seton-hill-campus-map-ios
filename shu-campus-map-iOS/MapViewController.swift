//
//  MapViewController.swift
//  shu-campus-map-iOS
//
//  Created by Coltin Kifer on 2/20/19.
//  Copyright © 2019 Coltin Kifer. All rights reserved.
//

import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let camera = mapView.camera
        camera.pitch = 60
        mapView.zoomLevel = 2
        mapView.setCamera(camera, animated: false)
        mapView.minimumZoomLevel = 2
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.30728689571579, longitude: -79.55396962433622), zoomLevel: 16, animated: false)
        view.addSubview(mapView)
        
        // Set the delegate property of our map view to `self` after instantiating it.
        mapView.delegate = self
        
        // Declare the marker `hello` and set its coordinates, title, and subtitle.
        let coordinate = CLLocationCoordinate2D(latitude: 40.30728689571579, longitude: -79.55396962433622)
        let shu = CustomMarker(coordinate: coordinate, title: "Seton Hill University", subtitle: "SHU Admin Building")
        shu.reuseIdentifier = "shuMarker"
        shu.color = .blue
        shu.image = UIImage(named: "first")

        // Add marker `shu` to the map.
        mapView.addAnnotation(shu)
    }
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if let point = annotation as? CustomMarker,
            let image = point.image,
            let reuseIdentifier = point.reuseIdentifier {
            
            if let annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: reuseIdentifier) {
                // The annotatation image has already been cached, just reuse it.
                return annotationImage
            } else {
                // Create a new annotation image.
                return MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
            }
        }
        
        // Fallback to the default marker image.
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
