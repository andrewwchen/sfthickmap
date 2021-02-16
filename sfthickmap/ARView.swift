//
//  ARView.swift
//  ImageDetectionTest
//
//  Created by DEV Studio on 1/28/21.
//

import Foundation
import ARKit
import SwiftUI

// MARK: - ARViewIndicator
struct ARViewIndicator: UIViewControllerRepresentable {
    typealias UIViewControllerType = ARView
    @Binding var ar_result: String
    @Binding var page: String
    @Binding var showPano: Bool
    @Binding var currentLandmark: Landmark?
    @Binding var landmarks: [Landmark]
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(ar_result: $ar_result, page: $page, showPano: $showPano, currentLandmark: $currentLandmark, landmarks: $landmarks)
    }
    
    func makeUIViewController(context: Context) -> ARView {
        let arview = ARView()
        arview.arView.delegate = context.coordinator
        arview.landmarks = landmarks
        return arview
    }
    
    func updateUIViewController(_ uiViewController: ARViewIndicator.UIViewControllerType, context: UIViewControllerRepresentableContext<ARViewIndicator>) { }
}

class Coordinator: NSObject, ARSCNViewDelegate {
    @Binding var ar_result: String
    @Binding var page: String
    @Binding var showPano: Bool
    @Binding var currentLandmark: Landmark?
    @Binding var landmarks: [Landmark]
    
    init(ar_result: Binding<String>, page: Binding<String>, showPano: Binding<Bool>, currentLandmark: Binding<Landmark?>, landmarks: Binding<[Landmark]>) {
        _ar_result = ar_result
        _page = page
        _showPano = showPano
        _currentLandmark = currentLandmark
        _landmarks = landmarks
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        ar_result = imageAnchor.referenceImage.name ?? ""
            for l in self.landmarks {
                if ar_result != "" && l.code != nil && l.code! == ar_result {
                    ar_result = ""
                    DispatchQueue.main.async {
                        self.currentLandmark = l
                    }
                    self.showPano = true
                }
            }
            ar_result = ""
        page = "Result"
    }
}

// MARK: - ARView
class ARView: UIViewController {
    var landmarks: [Landmark]?
    var referenceImages: Set<ARReferenceImage> = Set<ARReferenceImage>()
    
    var arView: ARSCNView {
        return self.view as! ARSCNView
    }
    
    override func loadView() {
        self.view = ARSCNView(frame: .zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arView.scene = SCNScene()
    }
    
    func resetTracking() {
        print("tracking was reset")
        /*
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }*/
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1;
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func reloadReferenceImages() {
        print(landmarks!.count)
        
        if landmarks != nil {
            for l in landmarks! {
                if l.trigger != nil {
                    let referenceImage = ARReferenceImage(l.trigger!, orientation: CGImagePropertyOrientation.up, physicalWidth: 1)
                    referenceImage.name = l.code
                    referenceImages.insert(referenceImage)
                    print("inserted 1 image")
                }
            }
        }
    }
    
    // MARK: - Functions for standard AR view handling
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadReferenceImages()
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arView.session.pause()
    }
}
