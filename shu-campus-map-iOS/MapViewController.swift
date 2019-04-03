//
//  MapViewController.swift
//  shu-campus-map-iOS
//
//  Created by Coltin Kifer on 2/20/19.
//  Copyright © 2019 Coltin Kifer. All rights reserved.
//

import Mapbox
import Pulley

class MapViewController: UIViewController, MGLMapViewDelegate {
    
    private var SetonHillBounds: MGLCoordinateBounds!
    private var SetonHillCoords: CLLocationCoordinate2D!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.pulleyViewController?.displayMode = .automatic
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetonHillCoords = CLLocationCoordinate2D(latitude: 40.308959, longitude: -79.555997)
        
        let styleURL = URL(string: "mapbox://styles/ck108860/cjrjllu0r06rt2sl9y702tkbe")
        let mapView = MGLMapView(frame: view.bounds,
                                 styleURL: styleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.camera = MGLMapCamera(lookingAtCenter: SetonHillCoords, altitude: 4500, pitch: 45, heading: 300)
        mapView.minimumZoomLevel = 12
        mapView.showsHeading = false
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(SetonHillCoords, zoomLevel: 15, animated: false)
        
        // Set the delegate property of our map view to `self` after instantiating it.
        mapView.delegate = self
        
        // Seton Hill bounds
        let northeast = CLLocationCoordinate2D(latitude: 40.336966, longitude: -79.525452)
        let southwest = CLLocationCoordinate2D(latitude: 40.28413, longitude: -79.598397)
        SetonHillBounds = MGLCoordinateBounds(sw: southwest, ne: northeast)
        mapView.showsUserLocation = true
        
        view.addSubview(mapView)
    }

    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        var service = FeatureService.init(dataSetUrl: "")
        var features = service.GetFeatures()
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

extension MapViewController: PulleyPrimaryContentControllerDelegate {
    func makeUIAdjustmentsForFullscreen(progress: CGFloat, bottomSafeArea: CGFloat) {
        // do something
    }
    
    func drawerChangedDistanceFromBottom(drawer: PulleyViewController, distance: CGFloat, bottomSafeArea: CGFloat){
        // do something
    }
}
