//
//  ContentView.swift
//  sfthickmap
//
//  Created by Andrew Chen on 8/26/20.
//  Copyright © 2020 Dartmouth DEV Studio. All rights reserved.
//

import SwiftUI
import SceneKit
import Combine
import MapKit
import PartialSheet
import CoreData

class Selections: ObservableObject {
    @Published var currentLandmark: Landmark?
    @Published var currentButton: PanoButton?
    @Published var currentAnnotation: SFAnnotation?
    @Published var currentAudio: URL?
    @Published var showButtonDetail: Bool = false
}


extension AnyTransition {
    static var fadeAndSlide: AnyTransition {
        AnyTransition.opacity.combined(with: .move(edge: .top))
    }
}


struct ContentView: View {
    @State private var showWelcome = !UserDefaults.standard.bool(forKey: "onboarded")
    @State private var showAnnoDetail = false
    @State private var centerCoordinate = CLLocationCoordinate2D()
    @State private var resetAnnotations = false
    @State private var resetRegion = false
    @State private var annotations = [SFAnnotation]()
    @State private var landmarks = [Landmark]()
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    @EnvironmentObject var selections: Selections
    @EnvironmentObject var settings: Settings
    
    @State private var torchIsOn = false
    @State private var showPano = false

    @State private var loading: Bool = false
    @State private var unloading: Bool = false
    @State private var syncing: Bool = false
    @State private var unsyncing: Bool = false
    @State private var erroring: Bool = false
    @State private var showAlerts: Bool = false
    
    @State private var page : String = "Home"
    @State private var ar_result : String = ""
    
    
    var body: some View {
        
        return ZStack(alignment: .leading) {
            Color(white: 0.8, opacity: 1)
                .edgesIgnoringSafeArea(.all)
            TabView {
                ZStack {
                    MapView(centerCoordinate: $centerCoordinate, showAnnoDetail: $showAnnoDetail, resetAnnotations: $resetAnnotations, resetRegion: $resetRegion, annotations: annotations)
                        .edgesIgnoringSafeArea([.all])
                        .partialSheet(isPresented: $showAnnoDetail) {
                            AnnoDetailView(showAnnoDetail: $showAnnoDetail)
                        }
                    Circle()
                        .fill(Color.blue)
                        .opacity(0.3)
                        .frame(width: 16, height: 16)
                    VStack {
                        Spacer()
                            .frame(height: 20)
                        HStack {
                            Spacer()
                            Button(action: {
                                resetRegion = true
                            }) {
                                Image(systemName: "location.circle")
                                    .squareIconButton()
                            }.padding(.trailing)
                        }
                        Spacer()
                        /// test annotation adder button for debugging
                        /*
                        HStack {
                            Spacer()
                            Button(action: {
                                let newLocation = SFAnnotation()
                                newLocation.coordinate = self.centerCoordinate
                                newLocation.title = "User-added test annotation"
                                newLocation.desc = "test annotation added by the use of the '+' button"
                                self.annotations.append(newLocation)
                                resetAnnotations = true
                            }) {
                                Image(systemName: "plus")
                                    .circleIconButton()
                                    .padding(20)
                            }
                        }
                        */
                    }
                }
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map")
                    }
                ZStack {
                    if showPano {
                        ZStack{
                            PanoView(landmark: $selections.currentLandmark, showButtonDetail: $selections.showButtonDetail)
                                .edgesIgnoringSafeArea([.all])
                                .partialSheet(isPresented: $selections.showButtonDetail) {
                                    ButtonDetailView(showButtonDetail: $selections.showButtonDetail)
                                }
                            VStack {
                                if self.selections.currentLandmark != nil {
                                    if self.selections.currentLandmark!.title != nil {
                                        Text(self.selections.currentLandmark!.title!)
                                            .font(Font.system(.headline))
                                            .padding()
                                    }
                                } else {
                                    Text("No Landmark")
                                        .font(Font.system(.headline))
                                        .padding()
                                }
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        self.showPano = false
                                        }) {
                                        Image(systemName: "multiply")
                                            .frame(width: 8, height: 8)
                                            .padding()
                                            .font(.title)
                                            .foregroundColor(Color(.label).opacity(1))
                                            .background(Color(.tertiarySystemGroupedBackground).opacity(1).blur(radius: 0.50))
                                            .clipShape(Circle())
                                    }
                                    .padding(.trailing)
                                    .padding(.top)
                                }
                                Spacer()
                            }
                        }
                    } else {
                        /// IMAGE RECOGNITION MODE
                        ARViewIndicator(ar_result: $ar_result, page: $page, showPano: $showPano, currentLandmark: $selections.currentLandmark, landmarks: $landmarks)
                            .edgesIgnoringSafeArea(.all)
                        /// QR CODE SCANNER MODE
                        /*
                        CBScanner(
                            supportBarcode: .constant([.qr]), //Set type of barcode you want to scan
                            torchLightIsOn: $torchIsOn,
                            scanInterval: .constant(self.settings.scanInterval),
                            cameraPosition: $settings.cameraPosition
                        ){
                            //When the scanner found a barcode
                            print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
                            for l in self.landmarks {
                                if l.code != nil && l.code! == $0.value{
                                    self.selections.currentLandmark = l
                                    self.showPano = true
                                }
                            }
                        }
                            .edgesIgnoringSafeArea(.all)
                        HStack {
                            Spacer()
                            VStack {
                                Spacer()
                                    .frame(height: 20)
                                Button(action: {
                                    if self.settings.cameraPosition == .back {
                                        self.torchIsOn.toggle()
                                    }
                                }) {
                                    Image(systemName: self.torchIsOn ? "bolt.fill" : "bolt.slash.fill")
                                        .squareIconButton(trigger: self.torchIsOn, highlightColor: Color.yellow)
                                        .animation(.easeInOut)
                                }.padding(.bottom)
                                Button(action: {
                                    if settings.cameraPosition == .back {
                                        self.torchIsOn = false
                                        self.settings.cameraPosition = .front
                                        settings.defaults.set(true, forKey: "frontCamera")
                                    } else {
                                        self.settings.cameraPosition = .back
                                        settings.defaults.set(false, forKey: "frontCamera")
                                    }
                                    
                                    
                                }) {
                                    Image(systemName: (settings.cameraPosition == .back) ? "camera.rotate" : "camera.rotate.fill")
                                        .squareIconButton()
                                        .animation(.easeInOut)
                                }
                                Spacer()
                            }
                        }.padding(.trailing)
                        */
                    }
                }
                    .tabItem {
                        Image(systemName: "camera")
                        Text("Scanner")
                }
            }.onAppear(perform: startView)
            HStack {
                VStack {
                    Spacer()
                        .frame(height: 20)
                    Button(action: {
                        sync()
                    }) {
                        Image(systemName: "arrow.clockwise.circle")
                            .squareIconButton()
                    }.padding(.bottom)
                    Button(action: {
                        self.showWelcome = true
                    }) {
                        Image(systemName: self.showWelcome ? "questionmark.circle.fill" : "questionmark.circle")
                            .squareIconButton()
                    }
                    Spacer()
                }.padding(.leading)
            }
            if true/*showAlerts*/ { /// DEV Note: Figure out how to get this working without the binding variable workaround
                VStack {
                    if loading {
                        AlertView(text: "Loading app data: please wait.", color: Config.noteColor, showAlerts: $showAlerts).transition(.asymmetric(insertion: .fadeAndSlide, removal: .fadeAndSlide))
                        Spacer()
                    }
                }
                .onAppear {
                    self.animateAndDelayWithSeconds(0.5) { self.loading = true }
                    self.animateAndDelayWithSeconds(1.5) { self.loading = false }
                }
                VStack {
                    if unloading {
                        AlertView(text: "Successfully loaded app data.", color: Config.noteColor, showAlerts: $showAlerts).transition(.asymmetric(insertion: .fadeAndSlide, removal: .fadeAndSlide))
                        Spacer()
                    }
                }
                .onAppear {
                    self.animateAndDelayWithSeconds(0.5) { self.unloading = true }
                    self.animateAndDelayWithSeconds(1.5) { self.unloading = false }
                }
                VStack {
                    if syncing {
                        AlertView(text: "Syncing app data with server...", color: Config.noteColor, showAlerts: $showAlerts).transition(.asymmetric(insertion: .fadeAndSlide, removal: .fadeAndSlide))
                        Spacer()
                    }
                }
                .onAppear {
                    self.animateAndDelayWithSeconds(0.5) { self.syncing = true }
                    self.animateAndDelayWithSeconds(1.5) { self.syncing = false }
                }
                VStack {
                    if unsyncing {
                        AlertView(text: "Successfully synced with server.", color: Config.noteColor, showAlerts: $showAlerts).transition(.asymmetric(insertion: .fadeAndSlide, removal: .fadeAndSlide))
                        Spacer()
                    }
                }
                .onAppear {
                    self.animateAndDelayWithSeconds(0.5) { self.unsyncing = true }
                    self.animateAndDelayWithSeconds(1.5) { self.unsyncing = false }
                }
                VStack {
                    if erroring {
                        AlertView(text: "An error occurred. Try again.", color: Config.alertColor, showAlerts: $showAlerts).transition(.asymmetric(insertion: .fadeAndSlide, removal: .fadeAndSlide))
                        Spacer()
                    }
                }
                .onAppear {
                    self.animateAndDelayWithSeconds(0.5) { self.erroring = true }
                    self.animateAndDelayWithSeconds(1.5) { self.erroring = false }
                }
            }
            
        }
        .sheet(isPresented: $showWelcome) {
            WelcomeView(showWelcome: $showWelcome)
        }
        .addPartialSheet(style: PartialSheetStyle(
            background: .blur(.systemMaterial),
            handlerBarColor: Color(UIColor.systemGray2),
            enableCover: true,
            coverColor: Color.black.opacity(0.4),
            blurEffectStyle: .dark,
            cornerRadius: 10,
            minTopDistance: 110)
        )
    }
    
    func startView() {
        if settings.onboarded {
            print("already onboarded, loading data")
            load()
        } else {
            settings.defaults.set(true, forKey: "onboarded")
            print("never onboarded, syncing data")
            sync()
        }
    }
    func load() {
        self.loading = true
        withAnimation {
            self.loading = true
        }
        let loadedData = loadData()
        if loadedData != nil {
            (annotations, landmarks) = loadData()!
            resetAnnotations = true
            withAnimation {
                self.loading = false
                self.unloading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.unloading = false
                }
            }
        } else {
            withAnimation {
                self.loading = false
                self.erroring = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.erroring = false
                }
            }
        }
    }
    func sync() {
        if !loading && !syncing {
            showAlerts = true
            withAnimation {
                self.syncing = true
            }
            getDocs(collNames: ["annotations", "buttons", "landmarks"]) { (docs, error) in
                if (error == nil && docs != nil && docs!["annotations"] != nil && docs!["buttons"] != nil && docs!["landmarks"] != nil ) {
                    let decodedDocs = decodeDocs(docs: docs!)
                    if decodedDocs != nil {
                        (annotations, landmarks) = contextualizeAndGetData(decodedDocs: decodedDocs!)
                        resetAnnotations = true
                        if saveData() != nil { // failure case
                            print("error saving documents")
                            withAnimation {
                                self.syncing = false
                                self.erroring = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    self.erroring = false
                                }
                            }
                        } else { // success case
                            print("data saved")
                            withAnimation {
                                self.syncing = false
                                self.unsyncing = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    self.unsyncing = false
                                }
                            }
                        }
                    } else { // failure case
                        withAnimation {
                            self.syncing = false
                            self.erroring = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.erroring = false
                            }
                        }
                        print("error decoding documents")
                    }
                } else { // failure case
                    withAnimation {
                        self.syncing = false
                        self.erroring = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.erroring = false
                        }
                    }
                    print("Error in retrieving documents", error as Any)
                }
            }
        }
    }
    
    func animateAndDelayWithSeconds(_ seconds: TimeInterval, action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            withAnimation {
                action()
            }
        }
    }
}
