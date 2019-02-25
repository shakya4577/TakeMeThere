import UIKit
import ARKit
import SceneKit
import CoreLocation
import MapKit

class ExplorerViewController: UIViewController
{
    @IBOutlet weak var routeMap: MKMapView!
    @IBOutlet weak var lblInfoTwo: UILabel!
    @IBOutlet weak var lblInfoOne: UILabel!
    
   
    @IBOutlet weak var arViewBottonConstraint: NSLayoutConstraint!
    var destinationLat:Double = Double()
    var destinationLong:Double = Double()
    var isWalk = Bool()
    var locationManager:LocationManager? = nil
    
    override func viewDidLoad()
    {
        locationManager = LocationManager(iRouteMap: routeMap, iDestLat: destinationLat, iDestLong: destinationLong)
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


