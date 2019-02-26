
import Foundation
import CoreLocation
import MapKit

class LocationManager : NSObject,CLLocationManagerDelegate,MKMapViewDelegate
{
    var locationManager = CLLocationManager()
    weak var appleMap: MKMapView!
    var currentLocation:CLLocation = CLLocation();
    var moveCount:Int = Int.max
    var messageToSiri:String = String()
    let request = MKDirections.Request()
    var destinationCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var addressString : String = ""
    let geocoder = CLGeocoder()
    var isMapAvailable = false;
    
    init(iRouteMap:MKMapView, iDestLat:Double,iDestLong:Double)
    {
        super.init()
        self.appleMap = iRouteMap
        self.destinationCoordinate = CLLocationCoordinate2D(latitude: iDestLat, longitude: iDestLong)
        isMapAvailable = true
        self.configureLocationManager()
        self.configureMap()
    }
    
    override init()
    {
        super.init()
        self.configureLocationManager()
    }
    
    func configureLocationManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func configureMap()
    {
        appleMap.delegate = self
        appleMap.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        currentLocation = locations[0] as CLLocation
        if(isMapAvailable)
        {
            takeMeThere()
            markMe()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        AppDelegate.visionDelegate?.nextMove(step:"I lost my sense. I am sorry")
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
        let region = MKCoordinateRegion(center: centre, span: MKCoordinateSpan(latitudeDelta: 0.0001, longitudeDelta: 0.0))
        self.appleMap.setRegion(region, animated: true)
    }
    
    func takeMeThere() {
        request.source = MKMapItem.forCurrentLocation()
        let desitnationPlaceMark = MKPlacemark.init(coordinate: destinationCoordinate)
        request.destination = MKMapItem.init(placemark: desitnationPlaceMark)
        request.requestsAlternateRoutes = false
        request.transportType = MKDirectionsTransportType.walking
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
        var counter:Int = 0;
        var audioMessage:String = String();
        for route in response.routes {
            
            appleMap.addOverlay(route.polyline,
                                level: MKOverlayLevel.aboveRoads)
            
            print("move count \(moveCount)")
            print("Steo count \(route.steps.count)")
            if (moveCount>route.steps.count || moveCount<route.steps.count)
            {
                moveCount = route.steps.count
                while(audioMessage.isEmpty)
                {
                    audioMessage = route.steps[counter].instructions
                   if let notice = route.steps[counter].notice
                   {
                      print("Notice:-  \(notice)")
                   }
                   print("distance:-  \(route.steps[counter].distance)")
                   counter = counter+1;
                }
                AppDelegate.visionDelegate?.nextMove(step:audioMessage)
            }
        }
    }
    
   func getUserLocatoin(completion: @escaping (_ location: String) -> Void)
    {
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarksArray, error) in
            if (placemarksArray?.count)! > 0 {
                let pm = placemarksArray![0]
                
                if pm.subLocality != nil {
                    self.addressString = self.addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    self.addressString = self.addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    self.addressString = self.addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    self.addressString = self.addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    self.addressString = self.addressString + pm.postalCode! + " "
                }
                completion(self.addressString);
            }
        }
    }
    
    func searchLocationList(locationInput:String,completion: @escaping (_ locationList: [LocationModel]) -> Void)
    {
        var locationSearchList = [LocationModel]()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = locationInput
        request.region =  appleMap.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            for mapItem in response.mapItems
            {
                let locationModelObj = LocationModel()
                locationModelObj.locationName = mapItem.name!
                locationModelObj.locationPlacemark = mapItem.placemark.title!
                locationModelObj.locatoinLatitude = mapItem.placemark.coordinate.latitude
                locationModelObj.locationLongitude = mapItem.placemark.coordinate.longitude
                locationSearchList.append(locationModelObj)
            }
            completion(locationSearchList)
            print( response.mapItems)
        }
    }
//    func searchLocationOnMap(locationInput:String)->[LocationModel]
//    {
//        var locationSearchList = [LocationModel]()
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = locationInput
//        request.region =  appleMap.region
//        let search = MKLocalSearch(request: request)
//        search.start { response, _ in
//            guard let response = response else {
//                return
//            }
//            for mapItem in response.mapItems
//            {
//                var locationModelObj = LocationModel()
//                locationModelObj.locationName = mapItem.name!
//                locationModelObj.locationPlacemark = mapItem.placemark.title!
//                locationModelObj.locatoinLatitude = mapItem.placemark.coordinate.latitude
//                locationModelObj.locationLongitude = mapItem.placemark.coordinate.longitude
//            }
//            print( response.mapItems)
//
//            // self.tableView.reloadData()
//        }
//    }
    
}
