import UIKit
import ARKit
import SceneKit
import CoreLocation
import MapKit

class VisionViewController: UIViewController,VisionDelegate,ARSCNViewDelegate
{
    @IBOutlet weak var routeMap: MKMapView!
    @IBOutlet weak var lblInfoTwo: UILabel!
    @IBOutlet weak var lblInfoOne: UILabel!
    @IBOutlet weak var arViewBottonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var arSceneView: ARSCNView!
    var destinationLocation:LocationModel = LocationModel()
    var isWalk = Bool()
    var locationManager:LocationManager? = nil
    static var sharedInstance = VisionViewController()
   
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.title = destinationLocation.locationName
        AppDelegate.visionDelegate = self
        AppDelegate.locationManager.appleMap = routeMap
        AppDelegate.locationManager.destinationCoordinate = CLLocationCoordinate2D(latitude: destinationLocation.locatoinLatitude, longitude: destinationLocation.locationLongitude)
        if(isWalk)
        {
            arViewBottonConstraint.constant = 0
            routeMap.isHidden = true
        }
        arSceneView.delegate = self
        arSceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Create ARWorldTrackingConfiguration object and load your garrey asset group.
        //You can add multiple ARObject file into ar asset group,
        let configuration = ARWorldTrackingConfiguration()
        guard let referenceObjects = ARReferenceObject.referenceObjects(inGroupNamed: "gallery", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        configuration.detectionObjects = referenceObjects
        arSceneView.session.run(configuration)
        
    }
    
    func nextMove(step:String){
        AppDelegate.speechManager.voiceOutput(message: step)
    }
    
    func whereAmI(location:String)
    {
        AppDelegate.locationManager.getUserLocatoin { (location:String) in
            AppDelegate.speechManager.voiceOutput(message: location)
        }
    }
    
    @IBAction func swipeDetected(_ sender: UISwipeGestureRecognizer)
    {
        AppDelegate.speechManager.voiceOutput(message: "Taking you to home Screen")
        sleep(2)
        navigationController?.popViewController(animated: false)
    }

    @IBAction func tapDetected(_ sender: UITapGestureRecognizer)
    {
        AppDelegate.locationManager.getUserLocatoin { (location: String) in
            AppDelegate.speechManager.voiceOutput(message:"You are at " + location)
        }
    }

    func longPressDetected(_ sender: Any)
    {
        AppDelegate.speechManager.awakeVoiceInteractor()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let objectAnchor = anchor as? ARObjectAnchor {
            let translation = objectAnchor.transform.columns.3
            let pos = float3(translation.x, translation.y, translation.z)
            let nodeArrow = getArrowNode()
            nodeArrow.position = SCNVector3(pos)
            arSceneView.scene.rootNode.addChildNode(nodeArrow)
        }
    }
    
    func getArrowNode() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: "arrow_yellow", withExtension: "scn", subdirectory: "art.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        return referenceNode
    }
    
}


