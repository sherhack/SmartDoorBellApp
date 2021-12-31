//
//  Ocr3DViewController.swift
//  SmartDoorBellApp
//
//  Created by Rafael Batista on 20/12/2021.
//

import UIKit
import ARKit

class Ocr3DViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var arkitView: ARSCNView!
    
    var textFromOcr: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraNode = arkitView.pointOfView
        
        arkitView.delegate = self
        arkitView.backgroundColor = .black
        
        let text = SCNText(string: textFromOcr, extrusionDepth: 0.0)
    
      
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        text.font = UIFont(name: "Times New Roman", size: 10)
        text.materials = [material]
    
        
        let node = SCNNode()
        //node.position = SCNVector3(x: 0, y: 0, z: -0.3)
        node.scale = SCNVector3(x: 0.09, y: 0.09, z: 0.02)
        
     
        
        //center(node: node)
        
      
        /*let dir = calculateCameraDirection(cameraNode: cameraNode!)
        let pos = pointInFrontOfPoint(point: cameraNode!.position, direction:dir, distance: 10)
        node.position = pos
        node.orientation = cameraNode!.orientation*/
        
        node.geometry = text
        node.position = SCNVector3Make(0, 0, -20)
        
        cameraNode!.addChildNode(node)
        
        arkitView.scene.rootNode.addChildNode(node)
        arkitView.autoenablesDefaultLighting = true

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        arkitView.session.run(configuration)
    }
    
    
    /*
    func pointInFrontOfPoint(point: SCNVector3, direction: SCNVector3, distance: Float) -> SCNVector3 {
        var x = Float()
        var y = Float()
        var z = Float()

        x = point.x + distance * direction.x
        y = point.y + distance * direction.y
        z = point.z + distance * direction.z

        let result = SCNVector3Make(x, y, z)
        return result
    }

    func calculateCameraDirection(cameraNode: SCNNode) -> SCNVector3 {
        let x = -cameraNode.rotation.x
        let y = -cameraNode.rotation.y
        let z = -cameraNode.rotation.z
        let w = cameraNode.rotation.w
        let cameraRotationMatrix = GLKMatrix3Make(cos(w) + pow(x, 2) * (1 - cos(w)),
                                                  x * y * (1 - cos(w)) - z * sin(w),
                                                  x * z * (1 - cos(w)) + y*sin(w),

                                                  y*x*(1-cos(w)) + z*sin(w),
                                                  cos(w) + pow(y, 2) * (1 - cos(w)),
                                                  y*z*(1-cos(w)) - x*sin(w),

                                                  z*x*(1 - cos(w)) - y*sin(w),
                                                  z*y*(1 - cos(w)) + x*sin(w),
                                                  cos(w) + pow(z, 2) * ( 1 - cos(w)))

        let cameraDirection = GLKMatrix3MultiplyVector3(cameraRotationMatrix, GLKVector3Make(0.0, 0.0, -1.0))
        return SCNVector3FromGLKVector3(cameraDirection)

    }*/
    
    

}
