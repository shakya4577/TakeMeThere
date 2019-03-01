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


