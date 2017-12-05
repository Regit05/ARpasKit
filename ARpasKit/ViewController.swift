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


class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        /*let cubeNode2 = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        cubeNode2.position = SCNVector3(0,0,-0.2)
        sceneView.scene.rootNode.addChildNode(cubeNode2)*/
        
        
        let myObjectNode = SCNNode()
        
        struct myCameraCoordinates{
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
        }
        
        
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
        sceneView.scene.rootNode.addChildNode(nodeCranial)
        
        
        
        
        
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
        
    }
    
    /*var focusSquare: FocusSquare?
    
    func setupFocusSquare() {
        focusSquare?.isHidden = true
        focusSquare?.removeFromParentNode()
        focusSquare = FocusSquare()
        sceneView.scene.rootNode.addChildNode(focusSquare!)
        
        textManager.scheduleMessage("TRY MOVING LEFT OR RIGHT", inSeconds: 5.0, messageType: .focusSquare)
    }*/

    
    /*@IBAction func button(_ sender: Any) {
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        cubeNode.position = SCNVector3(0,0,-0.2)
        sceneView.scene.rootNode.addChildNode(cubeNode)
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

