//
//  MapView.swift
//  sfthickmap
//
//  Created by Andrew Chen on 9/6/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI
import MapKit


struct MapView: UIViewRepresentable {
    @EnvironmentObject var selections: Selections
    var locationManager = CLLocationManager()
    func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
    }
    func makeUIView(context: Context) -> MKMapView {
        setupManager()
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.mapType = .satelliteFlyover
    
        // SAMPLE REGION
        let mapCenter = CLLocationCoordinate2DMake(43.702634, -72.286260)
        let mapRegion = MKCoordinateRegion(center: mapCenter, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapRegion, animated: true)
        mapView.showsCompass = true
        mapView.showsScale = true
        
        // SAMPLE LANDMARKS
        let landmarks = [selections.landmark1, selections.landmark2]
        var nextID = 0
        for l in landmarks {
            let annotation = UpdatablePointAnnotation()
            annotation.title = l.title
            //annotation.subtitle = l.desc
            annotation.coordinate = l.coordinate
            annotation.id = nextID
            nextID += 1
            //annotation.calloutEnabled = true
            mapView.addAnnotation(annotation)
        }
    return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
}
