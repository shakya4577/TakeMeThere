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
    var destinationLat:Double = Double()
    var destinationLong:Double = Double()
    var locationManager:LocationManager? = nil
    
    override func viewDidLoad()
    {
        locationManager = LocationManager(iRouteMap: routeMap, iDestLat: destinationLat, iDestLong: destinationLong)
        whereAmI()
        super.viewDidLoad()
        
    }
    static func nextMove(step:String)
    {
        speakSiri(message: step)
    }
    static func speakSiri(message:String)
    {
        print(message)
    }
    func whereAmI()
    {
       locationManager?.whereAmI()
    }
    static func iAmAt(location:String)
    {
        print(location)
    }
    
}


