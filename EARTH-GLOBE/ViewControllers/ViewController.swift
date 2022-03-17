//
//  ViewController.swift
//  EARTH-GLOBE
//
//  Created by Oleg Rybalko on 28/07/2017.
//  Copyright © 2017 Oleg Rybalko. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var addGlobeButton: UIButton!
    @IBOutlet weak var smallGlobeButton: UIButton!
    @IBOutlet weak var normalGlobeButton: UIButton!
    @IBOutlet weak var bigGlobeButton: UIButton!
    @IBOutlet var popupView: UIView!
    @IBOutlet var dockLabel: UILabel!
    @IBOutlet var sizeSlider: UISlider!
    
    var sphere = SCNNode()
    let generator = UIImpactFeedbackGenerator(style: .medium)
    var ruButtonIsPressed = false
    var enButtonIsPressed = true
    var globeIsAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        smallGlobeButton.layer.cornerRadius = 5
        normalGlobeButton.layer.cornerRadius = 5
        bigGlobeButton.layer.cornerRadius = 5
        addGlobeButton.layer.cornerRadius = 25
        dockLabel.layer.cornerRadius = 20
        
        normalGlobeButton.backgroundColor = UIColor(displayP3Red: 234, green: 234, blue: 234, alpha: 1)
        
        popupView.layer.cornerRadius = 5
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    struct myCameraCoordinates {
        
        var x = Float()
        var y = Float()
        var z = Float()
        
    }
    
    func getCameraCoordinates(sceneView: ARSCNView) -> myCameraCoordinates {
        
        let cameraTransform = sceneView.session.currentFrame?.camera.transform
        let cameraCoordinates = MDLTransform(matrix: cameraTransform!)
        
        var cc = myCameraCoordinates()
        
        cc.x = cameraCoordinates.translation.x
        cc.y = cameraCoordinates.translation.y
        cc.z = cameraCoordinates.translation.z
        
        return cc
        
    }
    
    @IBAction func addGlobe(_ sender: Any) {
        
        let cc = getCameraCoordinates(sceneView: sceneView)
        
        sphere.position = SCNVector3Make(cc.x, cc.y, cc.z - 0.3)
        sphere.geometry = SCNSphere(radius: CGFloat(sizeSlider!.value))
        
        if enButtonIsPressed == true{
            sphere.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "worldPoliticalMapEN.jpg")
        } else if ruButtonIsPressed == true{
            sphere.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "ru_map.png")
        }
        
        if globeIsAdded == false {
            sceneView.scene.rootNode.addChildNode(sphere)
            globeIsAdded = true
        } else {
            self.sphere.removeFromParentNode()
            sceneView.scene.rootNode.addChildNode(sphere)
        }
        generator.impactOccurred()
    }
    
    @IBAction func globeSize(_ sender: UISlider) {
        
        sphere.geometry = SCNSphere(radius: CGFloat(sizeSlider.value))
        if ruButtonIsPressed == true{
            sphere.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "ru_map.png")
        } else if enButtonIsPressed == true {
            sphere.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "worldPoliticalMapEN.jpg")
        }
    }
    
    @IBAction func ruButton(_ sender: Any) {
        ruButtonIsPressed = true
        enButtonIsPressed = false
        sphere.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "ru_map.png")
        generator.impactOccurred()
    }
    
    @IBAction func enButton(_ sender: Any) {
        enButtonIsPressed = true
        ruButtonIsPressed = false
        sphere.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "worldPoliticalMapEN.jpg")
        generator.impactOccurred()
    }
    
        @IBAction func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
            
            let translation = gestureRecognizer.translation(in: gestureRecognizer.view!)
            
            let x = Float(translation.x)
            let y = Float(-translation.y)
            
            let anglePan = sqrt(pow(x,2)+pow(y,2))*(Float)(M_PI)/180.0
            
            var rotationVector = SCNVector4()

            rotationVector.y = x
            rotationVector.z = 0.0
            rotationVector.w = anglePan
            
            sphere.rotation = rotationVector
            sphere.rotation.y = rotationVector.y
            
             if(gestureRecognizer.state == UIGestureRecognizerState.ended) {
                
                
                let currentPivot = sphere.pivot
                let currentPosition = sphere.position
                let changePivot = SCNMatrix4Invert(SCNMatrix4MakeRotation(-sphere.rotation.w, -sphere.rotation.x, -sphere.rotation.y, -sphere.rotation.z))
                
                sphere.pivot = SCNMatrix4Mult(changePivot, currentPivot)
                sphere.transform = SCNMatrix4Identity
                sphere.position = currentPosition
                
                
            }
    }
    

    
    
}
