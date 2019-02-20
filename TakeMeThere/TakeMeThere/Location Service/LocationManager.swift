
import Foundation
import CoreLocation
import MapKit

class LocationManager : NSObject,CLLocationManagerDelegate,MKMapViewDelegate
{
    var locationManager = CLLocationManager()
    weak var routeMap: MKMapView!
    var currentLocation:CLLocation = CLLocation();
    var moveCount:Int = Int.max
    var messageToSiri:String = String()
    let request = MKDirections.Request()
    var destinationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    
    init(iRouteMap:MKMapView, iDestLat:Double,iDestLong:Double)
    {
        super.init()
        
        self.routeMap = iRouteMap
        self.destinationCoordinate = CLLocationCoordinate2D(latitude: iDestLat, longitude: iDestLong)
        self.configuration()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        currentLocation = locations[0] as CLLocation
        markMe()
        takeMeThere()
        whereAmI()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
       MyEyesARViewController.nextMove(step: "I lost my sense. I am sorry")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor
        overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func initRoute()
    {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.transportType = MKDirectionsTransportType.walking
        let desitnationPlaceMark = MKPlacemark.init(coordinate: destinationCoordinate)
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
    
    func takeMeThere() {
        
        request.source = MKMapItem.forCurrentLocation()
        
        let desitnationPlaceMark = MKPlacemark.init(coordinate: destinationCoordinate)
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
                //print(step.instructions)
            }
            if(moveCount>nowMoveCount || moveCount<nowMoveCount)
            {
                moveCount = nowMoveCount
                MyEyesARViewController.nextMove(step: audioMessage)
            }
        }
    }
    
    func whereAmI()->String
    {
        var addressString : String = ""
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarksArray, error) in
            if (placemarksArray?.count)! > 0 {
                let pm = placemarksArray![0]
                
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
            }
        }
        print(addressString)
        return  addressString
    }
    
}
