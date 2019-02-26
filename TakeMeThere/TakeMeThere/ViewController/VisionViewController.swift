import UIKit
import ARKit
import SceneKit
import CoreLocation
import MapKit

class VisionViewController: UIViewController
{
    @IBOutlet weak var routeMap: MKMapView!
    @IBOutlet weak var lblInfoTwo: UILabel!
    @IBOutlet weak var lblInfoOne: UILabel!
    
   
    @IBOutlet weak var arViewBottonConstraint: NSLayoutConstraint!
    var destinationLocation:LocationModel = LocationModel()
    var isWalk = Bool()
    var locationManager:LocationManager? = nil
    
    override func viewDidLoad()
    {
        locationManager = LocationManager(iRouteMap: routeMap, iDestLat: destinationLocation.locatoinLatitude, iDestLong: destinationLocation.locationLongitude)
        super.viewDidLoad()
        if(isWalk)
        {
            arViewBottonConstraint.constant = 0
            routeMap.isHidden = true
        }
    }
    static func nextMove(step:String)
    {
       AppDelegate.speechManager.voiceOutput(message: step)
    }
    
    func whereAmI(location:String)
    {
        locationManager!.getUserLocatoin { (location:String) in
            AppDelegate.speechManager.voiceOutput(message: location)
        }
    }
}


