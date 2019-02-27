//
//  MapViewController.swift
//  shu-campus-map-iOS
//
//  Created by Coltin Kifer on 2/20/19.
//  Copyright © 2019 Coltin Kifer. All rights reserved.
//

import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate {
    
    private var SetonHillBounds: MGLCoordinateBounds!
    private var SetonHillCoords: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetonHillCoords = CLLocationCoordinate2D(latitude: 40.30728689571579, longitude: -79.55396962433622)
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let camera = mapView.camera
        camera.pitch = 50
        mapView.isPitchEnabled = false
        mapView.setCamera(camera, animated: true)
        mapView.minimumZoomLevel = 12
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(SetonHillCoords, zoomLevel: 14, animated: false)
        
        // Set the delegate property of our map view to `self` after instantiating it.
        mapView.delegate = self
        
        let shu = CustomMarker(coordinate: SetonHillCoords, title: "Seton Hill University", subtitle: "SHU Admin Building")
        shu.reuseIdentifier = "shuMarker"
        shu.color = .blue
        shu.image = UIImage(named: "first")
        
        // Seton Hill bounds
        let northeast = CLLocationCoordinate2D(latitude: 40.336966, longitude: -79.525452)
        let southwest = CLLocationCoordinate2D(latitude: 40.28413, longitude: -79.598397)
        
        
        SetonHillBounds = MGLCoordinateBounds(sw: southwest, ne: northeast)
        
        view.addSubview(mapView)
        
        mapView.addAnnotation(shu)
    }
    
    // Use my marker
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
    
    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
        
        // Get the current camera to restore it after.
        let currentCamera = mapView.camera
        
        // From the new camera obtain the center to test if it’s inside the boundaries.
        let newCameraCenter = newCamera.centerCoordinate
        
        // Set the map’s visible bounds to newCamera.
        mapView.camera = newCamera
        let newVisibleCoordinates = mapView.visibleCoordinateBounds
        
        // Revert the camera.
        mapView.camera = currentCamera
        
        // Test if the newCameraCenter and newVisibleCoordinates are inside self.SetonHill.
        let inside = MGLCoordinateInCoordinateBounds(newCameraCenter, self.SetonHillBounds)
        let intersects = MGLCoordinateInCoordinateBounds(newVisibleCoordinates.ne, self.SetonHillBounds) && MGLCoordinateInCoordinateBounds(newVisibleCoordinates.sw, self.SetonHillBounds)
        
        return inside && intersects
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
