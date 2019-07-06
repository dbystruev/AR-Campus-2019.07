//
//  ViewController.swift
//  Campus
//
//  Created by Denis Bystruev on 06/07/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let campus = loadModel(named: "Campus.scnassets/Campus.scn")!
        campus.position = SCNVector3(-3, 0, -3)
        sceneView.scene.rootNode.addChildNode(campus)
        
        let computedCampus = createCampus()
        computedCampus.position = SCNVector3(3, 0.5, -3)
        sceneView.scene.rootNode.addChildNode(computedCampus)
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func loadModel(named name: String) -> SCNNode? {
        guard let scene = SCNScene(named: name) else { return nil }
        return scene.rootNode.clone()
    }
    
    func createCampus() -> SCNNode {
        let bricks = UIImage(named: "Campus.scnassets/bricks.jpg")!
        let colors: [Any] = [bricks, #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)]
        let materials = colors.map { color -> SCNMaterial in
            let material = SCNMaterial()
            material.diffuse.contents = color
            return material
        }
        let box = SCNBox(width: 3, height: 1, length: 1, chamferRadius: 0)
        box.materials = materials
        let building = SCNNode(geometry: box)
        
        let grass = SCNPlane(width: 5, height: 2)
        grass.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        let grassNode = SCNNode(geometry: grass)
        grassNode.eulerAngles.x = -.pi / 2
        grassNode.position.y = -0.501
        building.addChildNode(grassNode)
        
        for x in stride(from: -2.0, through: 3, by: 4) {
            for y in stride(from: -0.75, through: 0.75, by: 0.75) {
                print(#line, #function, x, y)
                let tree = createTree()
                tree.position = SCNVector3(x, y, 0.251)
                grassNode.addChildNode(tree)
            }
        }
        
        
        
        
        return building
    }
    
    func createTree() -> SCNNode {
        let stall = SCNCylinder(radius: 0.05, height: 1)
        stall.firstMaterial?.diffuse.contents = UIColor.brown
        let node = SCNNode(geometry: stall)
        
        let crown = SCNSphere(radius: 0.35)
        crown.firstMaterial?.diffuse.contents = UIColor.green
        let crownNode = SCNNode(geometry: crown)
        crownNode.position.y = 0.5
        node.addChildNode(crownNode)
        
        node.eulerAngles.x = .pi / 2
        node.scale = SCNVector3(0.5, 0.5, 0.5)
        return node
    }
}

