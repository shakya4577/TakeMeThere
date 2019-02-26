import UIKit
import ARKit
import SceneKit
import CoreLocation
import MapKit

class VisionViewController: UIViewController,VisionDelegate
{
    @IBOutlet weak var routeMap: MKMapView!
    @IBOutlet weak var lblInfoTwo: UILabel!
    @IBOutlet weak var lblInfoOne: UILabel!
    
   
    @IBOutlet weak var arViewBottonConstraint: NSLayoutConstraint!
    var destinationLocation:LocationModel = LocationModel()
    var isWalk = Bool()
    var locationManager:LocationManager? = nil
    static var sharedInstance = VisionViewController()
   
    override func viewDidLoad()
    {
        AppDelegate.visionDelegate = self
        locationManager = LocationManager(iRouteMap: routeMap, iDestLat: destinationLocation.locatoinLatitude, iDestLong: destinationLocation.locationLongitude)
        super.viewDidLoad()
        self.navigationController?.title = destinationLocation.locationName
        if(isWalk)
        {
            arViewBottonConstraint.constant = 0
            routeMap.isHidden = true
        }
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
}


