# Smith Pond Shaker Forest thick map iOS app

by Andrew Chen and Daniel Akili (Dartmouth DEV Studio)
https://devstudio.dartmouth.edu/wordpress/people/

Includes:
*  Map view of user and landmarks locations and basic information
*  Camera view for recognizing visual triggers for landmark details
*  360 degree image views of landmark details with embedded buttons for additional information

> This project is still a work-in-progress. Here is a video of current progress on features: https://drive.google.com/file/d/1UoU750iFwqpvYcrVU1zAXfXqUu3goSHC/view?usp=sharing


>A prototype for "Digital Pilgrims: Thick-Mapping the Smith Pond Shaker Forest"
https://neukom.dartmouth.edu/research/compx-faculty-grant-program/2020-grant-recipients


### Description


The Shaker Forest thick map app relies on https://github.com/scihant/CTPanoramaView, which takes spherical panoramic images and projects them onto the inside of a hollow sphere in SceneKit. The camera is placed at the center of the sphere, and is rotated using the phone's orientation.

The app piggybacks onto the swift files and SceneKit scene created by CTPanoramaView with additional code that manages the creation and usage of buttons inside the SceneKit scene. Each individual button is an object of a custom "PanoButton" class, which stores information including the description of the button, the name of the button, and a SceneView node. The node is unparented and is a plane set to always face the camera using SCNBillboardConstraint with the button image as its material and appropriate coordinates relative to the panoramic image it is associated with.

When viewing a panoramic image using CTPanoramaView, an array of PanoButtons is sent as a parameter alongside the panoramic image file. The modified CTPanoramaView then parents all the PanoButtons to the main scene with the panoramic image sphere. Using the modified CTPanoramaView "handleTap" function, CTPanoramaView performs a sceneView.hitTest to find the tapped node. If the tapped node is a button, CTPanoramaView returns the corresponding PanoButton to the SwiftUI View containing the entire CTPanoramaView SceneKit UIView. The outer SwiftUI View then uses the PanoButton name and description to create a dismissable NavigationView displaying the button's information.

>App view hierarchy plan:
https://www.figma.com/file/796UPjy5W2bFuSahZh0QmT/sfthickmap-App-Hierarchy?node-id=0%3A1