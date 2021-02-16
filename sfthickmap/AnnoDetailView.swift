//
//  AnnoDetailView.swift
//  sfthickmap
//
//  Created by devstudio on 11/6/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI
import PartialSheet
import MapKit

struct AnnoDetailView: View {
    @EnvironmentObject var selections: Selections
    @Binding var showAnnoDetail: Bool
    @State private var showDetails = false
    @State private var width = UIScreen.main.bounds.width
    @State private var height = UIScreen.main.bounds.height
    
    
    let locationManager = CLLocationManager()
    //let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
    //@State private var vURL = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")
    
    var body: some View {
        // vars for customizing the partialsheet
        let annotation = selections.currentAnnotation
        var annoTitle:String?
        var annoDist:String?
        var annoDesc:String?
        let annoCoords:(String, String)?
        let annoImgs:[UIImage]?
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        
        if annotation != nil {
            // getting user's current location and finding distance
            if
               CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
               CLLocationManager.authorizationStatus() ==  .authorizedAlways
            {
                currentLocation = locManager.location
                let distMeters = currentLocation.distance(from: CLLocation(latitude: annotation!.coordinate.latitude, longitude: annotation!.coordinate.longitude))
                if distMeters >= 1609 {
                    annoDist = "\(round(distMeters / 1609)) mi"
                } else {
                    annoDist = "\(round(distMeters)) m"
                }
            }
            
            
            if annotation!.title != nil {
                annoTitle = annotation!.title!
            }
            if annotation!.desc != nil {
                annoDesc = annotation!.desc!
            }
            
            annoCoords = (String(round(1000000 * annotation!.coordinate.latitude) / 1000000), String(round(1000000 * annotation!.coordinate.longitude) / 1000000))
            annoImgs = annotation!.imgs
        } else {
            if
               CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
               CLLocationManager.authorizationStatus() ==  .authorizedAlways
            {
                currentLocation = locManager.location
                annoCoords = (String(round(1000000 * currentLocation.coordinate.latitude) / 1000000), String(round(1000000 * currentLocation.coordinate.longitude) / 1000000))
            } else {
                annoCoords = nil
            }
            annoTitle = nil
            annoDesc = nil
            annoImgs = nil
        }
        
        return VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    if annoTitle != nil {
                        Text(annoTitle!)
                            .font(.headline)
                    }
                    if annoDist != nil {
                        Text(annoDist!)
                            .font(.body)
                    }
                }
                    .padding(.leading)
                Spacer()
                Button(action: {
                    withAnimation {
                        showDetails.toggle()
                    }
                    }) {
                    Image(systemName: "chevron.right")
                        .circleIconButton()
                        .rotationEffect(.degrees(showDetails ? 90 : 0))
                }
                .padding(.trailing)
                Button(action: {
                    self.showAnnoDetail = false
                    }) {
                    Image(systemName: "multiply")
                        .circleIconButton()
                }
                .padding(.trailing)
            }
            if showDetails {
                VStack(spacing: 0) {
                    if true {
                        Divider()
                        if annoImgs != nil {
                            ScrollView(.horizontal, showsIndicators: true) {
                                HStack(spacing: 20) {
                                    ForEach(0..<annoImgs!.count) {
                                        Image(uiImage: annoImgs![$0])
                                            .resizable()
                                            .aspectRatio(annoImgs![$0].size, contentMode: .fit)
                                            .frame(maxHeight: height / 4)
                                    }
                                }
                            }
                        }
                    }
                    if annoDesc != nil {
                        Divider()
                        ScrollView(.vertical, showsIndicators: true) {
                            Text(annoDesc!)
                                .font(.body)
                                .padding()
                                .animation(.easeInOut(duration: 1.0))
                        }.frame(maxHeight: self.height / 4)
                    }
                    if annoCoords != nil {
                        Divider()
                        HStack(spacing: 0) {
                            HStack {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Latitude")
                                        .foregroundColor(Color(.secondaryLabel))
                                    Text("\(annoCoords!.0)")
                                }
                                    .padding(.leading)
                                Spacer()
                            }
                            .frame(width: self.width / 2)
                            HStack {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Longitude")
                                        .foregroundColor(Color(.secondaryLabel))
                                    Text("\(annoCoords!.1)")
                                }
                                    .padding(.leading)
                                Spacer()
                            }
                            .frame(width: self.width / 2)
                        }.padding(.top)
                    }
                }
            }
        }.animation(.spring(response: 0.10, dampingFraction: 0.90, blendDuration: 0))
    }
}
