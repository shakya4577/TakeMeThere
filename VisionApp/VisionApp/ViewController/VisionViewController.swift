import UIKit
import ARKit
import SceneKit
import CoreLocation
import MapKit

class VisionViewController: UIViewController,VisionDelegate,ARSKViewDelegate, ARSessionDelegate
{
    @IBOutlet weak var routeMap: MKMapView!
    @IBOutlet weak var lblInfoTwo: UILabel!
    @IBOutlet weak var sceneViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblInfoOne: UILabel!
    
    
    @IBOutlet weak var sceneView: ARSKView!
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
            sceneViewBottomConstraint.constant = -1 * routeMap.frame.height
            routeMap.isHidden = true
        }
        let overlayScene = SKScene()
        overlayScene.scaleMode = .aspectFill
        sceneView.delegate = self
        sceneView.presentScene(overlayScene)
        sceneView.session.delegate = self
        
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
    
    func nextMove(step:String){
        AppDelegate.speechManager.voiceOutput(message: step)
    }
    
    func whereAmI(location:String)
    {
        AppDelegate.locationManager.getUserLocatoin { (location:String) in
            AppDelegate.speechManager.voiceOutput(message: location)
        }
    }
    
    func saveThisLocation()
    {
        
    }

}


