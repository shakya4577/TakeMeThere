import UIKit
import ARKit
import SceneKit
import CoreLocation
import MapKit

class MyEyesARViewController: UIViewController
{
    @IBOutlet weak var routeMap: MKMapView!
    @IBOutlet weak var lblInfoTwo: UILabel!
    @IBOutlet weak var lblInfoOne: UILabel!
    
    @IBOutlet weak var arSceneHeightContraint: NSLayoutConstraint!
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
            arSceneHeightContraint.constant = self.view.frame.height
        }
    }
    static func nextMove(step:String)
    {
       AppDelegate.speechManager.voiceOutput(message: step)
    }
    
    static func speakSiri(message:String)
    {
        print(message)
    }
    
    static func iAmAt(location:String)
    {
        print(location)
    }
    
    @IBAction func btnTestClick(_ sender: Any)
    {
        locationManager?.whereAmI()
    }
}


