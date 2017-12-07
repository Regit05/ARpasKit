//
//  ViewController.swift
//  ARpasKit
//
//  Created by admin on 04/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import ARKit
import SceneKit


class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    
    let nodeName = "cherub"
    
    var on = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
        // Set the view's delegate
        
        sceneView.delegate = self
        
        
        
        // Show statistics such as fps and timing information
        
        sceneView.showsStatistics = true
        
        //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        sceneView.antialiasingMode = .multisampling4X
        
        
        
        // Create a new scene
        
        let scene = SCNScene()
        
        
        
        // Set the scene to the view
        
        sceneView.scene = scene
        
        
        
        /*let modelScene = SCNScene(named:
            
            "Wolf_dae.dae")!
        
        
        
        nodeModel =  modelScene.rootNode.childNode(withName: nodeName, recursively: true)*/
        
    }
    
    func createNodeObject() -> SCNNode? {
        let modelScene = SCNScene(named:"animation_voiture.scn")!
        
        let nodeModel =  modelScene.rootNode.childNode(withName: "TechnicLEGO_CAR_1", recursively: true)
        //nodeModel?.rotation = SCNVector4Make(1, 0, 0, -Float.pi / 2.0)
        
        return nodeModel
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        
        
        // Create a session configuration
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        
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
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let location = touches.first!.location(in: sceneView)
        
        
        
        // Let's test if a 3D Object was touch
        
        var hitTestOptions = [SCNHitTestOption: Any]()
        
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        
        
        
        let hitResults: [SCNHitTestResult]  = sceneView.hitTest(location, options: hitTestOptions)
        
        
        
        /*if let hit = hitResults.first {
            
            if let node = getParent(hit.node) {
                
                node.removeFromParentNode()
                
                return
                
            }
            
        }*/
        
        
        
        // No object was touch? Try feature points
        
        let hitResultsFeaturePoints: [ARHitTestResult]  = sceneView.hitTest(location, types: .featurePoint)
        
        
        
        if let hit = hitResultsFeaturePoints.first {
            if let currentFrame = sceneView.session.currentFrame {
                // Create a transform with a translation of 0.2 meters in front
                // of the camera
                var translation = matrix_identity_float4x4
                translation.columns.3.z = -0.2
                let transform = simd_mul(
                    currentFrame.camera.transform,
                    translation
                )
                // Add a new anchor to the session
                // let anchor = ARAnchor(transform: transform)
                let anchor = ARAnchor(transform: hit.worldTransform)
                sceneView.session.add(anchor: anchor)
                
                /*print(anchor)
                if let planeAnchor = anchor as? ARAnchor{
                    print(planeAnchor.transform)
                } else {
                    print("not good")
                }*/
            }
            
            
            /*
            // Get the rotation matrix of the camera
            
            //let rotate = simd_float4x4(SCNMatrix4MakeRotation(sceneView.session.currentFrame!.camera.eulerAngles.y, 0, 1, 0))
            
            // Combine the matrices
            
            //let finalTransform = simd_mul(hit.worldTransform, rotate)
            
            // sceneView.session.add(anchor: ARAnchor(transform: finalTransform))
            
            sceneView.session.add(anchor: ARAnchor(transform: hit.worldTransform))
            */
            
        }
    }
    
    
    
    func getParent(_ nodeFound: SCNNode?) -> SCNNode? {
        
        if let node = nodeFound {
            
            if node.name == nodeName {
                
                return node
                
            } else if let parent = node.parent {
                
                return getParent(parent)
                
            }
            
        }
        
        return nil
        
    }
    
    
    
    // MARK: - ARSCNViewDelegate
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // Si on detecte le plan on incremente
        // si on touche et que le plan detecte alors on place objet
        var planeDetection = 0
        if let plane = anchor as? ARPlaneAnchor {
            
            planeDetection = planeDetection + 1
        //recuperer la position du node associe a une ancre
       // if let anchorNode = sceneView.node(for: anchor) {
                //let plane = anchor as! ARPlaneAnchor
                //print(anchor.transform)
                
                // DispatchQueue.main.async {
                    
                    //let modelClone = self.nodeModel.clone()
            if on != true { 
                    if let modelClone = self.createNodeObject() {
                        on = true
                        let c = modelClone.clone()
                        c.position = node.position
                        c.rotation = SCNVector4Make(0, 1.0, 0.0, -Float.pi)
                    
                    // Add model as a child of the node
                        print(c.rotation)
                        node.addChildNode(c)
                        //node.rotation = SCNVector4Make(1, 0.0, 0.0, -Float.pi / 2.0)
                        print(node.rotation)
                //    }
            }
                    
                
          }
            
            
            /*let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
            let planeNode = SCNNode(geometry: plane)
            planeNode.simdPosition = float3(anchor.center.x, 0, anchor.center.z)
            
            /*
             `SCNPlane` is vertically oriented in its local coordinate space, so
             rotate the plane to match the horizontal orientation of `ARPlaneAnchor`.
             */
            planeNode.eulerAngles.x = -.pi / 2
            
            // Make the plane visualization semitransparent to clearly show real-world placement.
            planeNode.opacity = 0.25
            
            /*
             Add the plane visualization to the ARKit-managed node so that it tracks
             changes in the plane anchor as plane estimation continues.
             */
            node.addChildNode(planeNode)*/
            
            
            
        }
        
}



/*
 


    //@IBOutlet weak var sceneView: ARSCNView!
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        let object = SCNNode()
        //let cc = getCameraCoordinates(sceneView: sceneView)
        //object.position = SCNVector3(cc.x, cc.y, cc.z)
        object.position = SCNVector3(0,0,-0.2)
        
        guard let virtualObjectScene = SCNScene(named : "test.scn")
            else {
                return
        }
        
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            wrapperNode.addChildNode(child)
        }
        object.addChildNode(wrapperNode)
        
        
        sceneView.scene.rootNode.addChildNode(object)
        
      
        
        /*let myObjectNode = SCNNode()*/
        
        
        
        /*
        let cc = getCameraCoordinates(sceneView: sceneView)
        myObjectNode.position = SCNVector3(cc.x, cc.y, cc.z)
        
        guard let virtualObjectScene = SCNScene(named: "/*fichier*/", inDirectory:"/*directory*/")
            else{
                return
        }
        
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes{
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            wrapperNode.addChildNode(child)
        }
        myObjectNode.addChildNode(wrapperNode)
        
        sceneView.scene.rootNode.addChildNode(myObjectNode)
        
        
        
        
        
        let bundle = Bundle.main
        guard let url = bundle.url(forResource: "Cranial", withExtension: "obj") else{
            fatalError("Failed to find model file")
        }
        
        let asset = MDLAsset(url:url)
        guard let object = asset.object(at: 0) as? MDLMesh else {
            fatalError("Failed to get mesh from asset")
        }
        
        let scene = SCNScene()
        let nodeCranial = SCNNode.init(MDLObject: object)
        nodeCranial.simdPosition = float3(0, 0, 0.5)
        sceneView.scene.rootNode.addChildNode(nodeCranial)*/
        
        
        
        
        
        /*let session = ARSession()
        
        var focusSquare: FocusSquare?
        //var textManager: TextManager?
        //textManager = TextManager()
        
        focusSquare?.isHidden = true
        focusSquare?.removeFromParentNode()
        focusSquare = FocusSquare()
        sceneView.scene.rootNode.addChildNode(focusSquare!)
        
        //textManager.scheduleMessage("TRY MOVING LEFT OR RIGHT", inSeconds: 5.0, messageType: .focusSquare)
        */
        
        
        /*var focusSquare: FocusSquare?
        focusSquare = FocusSquare()
        sceneView.scene.rootNode.addChildNode(focusSquare!)
        */
 
        /*let session = ARSession()
        setupFocusSquare()
        
        guard let cameraTransform = session.currentFrame?.camera.transform, let focusSquarePosition = focusSquare.lastPosition else {
            //statusViewController.showMessage("Cannot place object")
            return
        }
        
        virtualObjectInteraction.selectedObject = cubeNode2
        cubeNode2.simdConvertPosition(focusSquarePosition, relativeTo : cameraTransform, smoothMovement: false)
        
        updateQueue.async {
            self.sceneView.scene.rootNode.addChildNode(cubeNode2)
        }*/
        
    }*/
    
    
    /*struct myCameraCoordinates{
        var x = Float()
        var y = Float()
        var z = Float()
    }
    
    func getCameraCoordinates(sceneView: ARSCNView)->myCameraCoordinates{
        let cameraTransform = sceneView.session.currentFrame?.camera.transform
        let cameraCoordinates = MDLTransform(matrix : cameraTransform!)
        
        var cc = myCameraCoordinates()
        cc.x = cameraCoordinates.translation.x
        cc.y = cameraCoordinates.translation.y
        cc.z = cameraCoordinates.translation.z
        return cc
    }*/
    
    
    /*var focusSquare: FocusSquare?
    
    func setupFocusSquare() {
        focusSquare?.isHidden = true
        focusSquare?.removeFromParentNode()
        focusSquare = FocusSquare()
        sceneView.scene.rootNode.addChildNode(focusSquare!)
        
        textManager.scheduleMessage("TRY MOVING LEFT OR RIGHT", inSeconds: 5.0, messageType: .focusSquare)
    }*/

    
    /*@IBAction func button(_ sender: Any) {
        /*let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        cubeNode.position = SCNVector3(0,0,-0.2)
        sceneView.scene.rootNode.addChildNode(cubeNode)*/
        
        /*guard let currentFrame = sceneView.session.currentFrame,
            let lightEstimate = currentFrame.lightEstimate else {
                return
        }
        print(lightEstimate)*/
        
        if let currentFrame = sceneView.session.currentFrame {
            // Create a transform with a translation of 0.2 meters in front
            // of the camera
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.2
            let transform = simd_mul(
                currentFrame.camera.transform,
                translation
            )
            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
            
            print(anchor)
            if let planeAnchor = anchor as? ARAnchor{
                print(planeAnchor.transform)
            } else {
                print("not good")
            }
        }
        
        

    }*/
    
    /*func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Zero // Position of `planeNode`, related to `node`
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1.0, 0.0, 0.0)
        node.addChildNode(planeNode)
    }*/
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }*/
    
    


}

