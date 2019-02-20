import UIKit
import ARKit
import SceneKit
import CoreLocation
import MapKit

class MyEyesARViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate
{
    var locationManager = CLLocationManager()
    @IBOutlet weak var routeMap: MKMapView!
    var currentLocation:CLLocation = CLLocation();
    var destinationLocation:CLLocation = CLLocation();
    var destinationLat:Double = Double()
    var destinationLong:Double = Double()
    @IBOutlet weak var lblInfoTwo: UILabel!
    @IBOutlet weak var lblInfoOne: UILabel!
    var moveCount:Int = Int.max
    var messageToSiri:String = String()
    
    let request = MKDirections.Request()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configuration()
        initRoute()
    }
    
    func configuration() {
        routeMap.delegate = self
        routeMap.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func initRoute()
    {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.transportType = MKDirectionsTransportType.walking
        let destinationCoordinat = CLLocationCoordinate2D.init(latitude: destinationLat, longitude: destinationLong)
        let desitnationPlaceMark = MKPlacemark.init(coordinate: destinationCoordinat)
        
        request.destination = MKMapItem.init(placemark: desitnationPlaceMark)
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculate(completionHandler: {(response, error) in
            
            if error != nil {
                print("Error getting directions")
            } else {
                self.showRoute(response!)
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        currentLocation = locations[0] as CLLocation
        markMe()
        takeMeThere()
    }
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor
        overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func takeMeThere() {
        
        request.source = MKMapItem.forCurrentLocation()
        let destinationCoordinat = CLLocationCoordinate2D.init(latitude: destinationLat, longitude: destinationLong)
        let desitnationPlaceMark = MKPlacemark.init(coordinate: destinationCoordinat)
        request.destination = MKMapItem.init(placemark: desitnationPlaceMark)
        
        request.requestsAlternateRoutes = false
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: {(response, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let response = response {
                    self.showRoute(response)
                }
            }
        })
    }
    
    func showRoute(_ response: MKDirections.Response) {
        var nowMoveCount = 0;
        var audioMessage:String = String();
        for route in response.routes {
            
            routeMap.addOverlay(route.polyline,
                                level: MKOverlayLevel.aboveRoads)
            for step in route.steps
            {
                if(audioMessage.isEmpty)
                {
                    audioMessage = step.instructions
                }
                nowMoveCount = nowMoveCount + 1;
            }
            if(moveCount>nowMoveCount || moveCount<nowMoveCount)
            {
                moveCount = nowMoveCount
                speakSiri(message: audioMessage)
            }
        }
    }
    
    func markMe()
    {
        let centre = currentLocation.coordinate
        let region = MKCoordinateRegion(center: centre, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.0))
        self.routeMap.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentLocation.coordinate
        annotation.title = "I am here"
        self.routeMap.addAnnotation(annotation)
    }
    
    func whereAmI()
    {
       let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarksArray, error) in
            
            if (placemarksArray?.count)! > 0 {
                let pm = placemarksArray![0]
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                self.speakSiri(message: addressString)
            }
        }
    }
    
    func speakSiri(message:String)
    {
        print(message)
    }
    
}


