//
//  MapView.swift
//  sfthickmap
//
//  Created by Andrew Chen on 9/6/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

var deselect = false

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    @Binding var showAnnoDetail: Bool
    @Binding var resetAnnotations: Bool
    @Binding var resetRegion: Bool
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var annotations: [SFAnnotation]
    var locationManager = CLLocationManager()
    
    func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        setupManager()
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.delegate = context.coordinator
        // MAP CONFIG
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.mapType = .satelliteFlyover
        mapView.showsCompass = true
        mapView.showsScale = true
    
        // DEFAULT REGION
        let mapRegion = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapRegion, animated: true)
        
    return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if deselect && !showAnnoDetail{
            uiView.deselectAnnotation(appDelegate.getAnnotation(), animated: true)
            deselect = false
        }
        if showAnnoDetail {
            deselect = true
        }
        if resetAnnotations {
            resetAnnotations = false
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
        }
        if resetRegion && uiView.annotations.count > 0 {
            resetRegion = false
            let mapRegion = MKCoordinateRegion(center: uiView.annotations[0].coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            uiView.setRegion(mapRegion, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            let selectedAnnotation = view.annotation as? SFAnnotation
            parent.appDelegate.updateAnnotation(currentAnnotation: selectedAnnotation)
            parent.showAnnoDetail = true
        }
    }
}

