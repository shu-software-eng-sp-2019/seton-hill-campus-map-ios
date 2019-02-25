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
        mapView.setCamera(camera, animated: false)
        mapView.minimumZoomLevel = 12
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 40.30728689571579, longitude: -79.55396962433622), zoomLevel: 16, animated: false)
        view.addSubview(mapView)
        
        // Set the delegate property of our map view to `self` after instantiating it.
        mapView.delegate = self
        
        // Declare the marker `hello` and set its coordinates, title, and subtitle.
        let shu = MGLPointAnnotation()
        shu.coordinate = CLLocationCoordinate2D(latitude: 40.30728689571579, longitude: -79.55396962433622)
        shu.title = "Seton Hill University"
        shu.subtitle = "SHU Admin Building"
        
        // Add marker `shu` to the map.
        mapView.addAnnotation(shu)
    }
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
