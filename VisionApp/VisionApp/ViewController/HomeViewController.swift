import UIKit
import Speech
import MapKit
import Vision
class HomeViewController: UIViewController,SFSpeechRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,VisionDelegate
{
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var mainView: UIImageView!
    internal var localLocationList = [LocationModel]()
    internal var locationSelectionCounter = 0
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    var searchEditingSemaphor = true
    override func viewDidLoad()
    {
        super.viewDidLoad()
       AppDelegate.locationManager.appleMap = mapView
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        localLocationList = RealmManager.getLocationList()
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
        resignFirstResponder()
    }
   
   
    func filterLocationList(filterInput: String)
    {
        if (filterInput == "")
        {
            selectDestination()
            return
        }
        else
        {
             localLocationList = localLocationList.filter { $0.locationName.contains(filterInput) }
            if(localLocationList.count==0)
            {
                AppDelegate.locationManager.searchLocationList(locationInput: filterInput) {
                    (returnedlocationList:[LocationModel])
                    in
                    self.localLocationList = returnedlocationList
                    self.locationTableView.reloadData()
                    self.selectDestination()
                }
            }
            else
            {
                locationTableView.reloadData()
                selectDestination()
            }
        }
       
    }
    
    func selectDestination()
    {
        if(locationSelectionCounter<0 || locationSelectionCounter>localLocationList.count-1)
        {
            AppDelegate.speechManager.voiceOutput(message: "No more location available")
            locationSelectionCounter=0
            return
        }
        AppDelegate.speechManager.voiceOutput(message: localLocationList[locationSelectionCounter].locationName)
    }
    
    func NavigateToVision(isLocalLocation:Bool=false)
    {
        let visionViewController = VisionViewController()
        if !isLocalLocation
        {
            visionViewController.destinationLocation = localLocationList[locationSelectionCounter];
        }
        performSegue(withIdentifier: "VisionIdentifier", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localLocationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LocationTableCell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath) as! LocationTableCell
        cell.initCell(locName: localLocationList[indexPath.row].locationName)
        return cell
    }

}

func testRealm()
{
    let loc1:LocationModel = LocationModel()
    loc1.locationName = "Stairs"
    loc1.locatoinLatitude = 30.484872
    loc1.locationLongitude = 49.0092393
    RealmManager.saveLocation(locationDetails: loc1)
    
    let loc2:LocationModel = LocationModel()
    loc2.locationName = "Lobby"
    loc2.locatoinLatitude = 70.484872
    loc2.locationLongitude = 59.0092393
    RealmManager.saveLocation(locationDetails: loc2)
    
    let loc3:LocationModel = LocationModel()
    loc3.locationName = "Main door"
    loc3.locatoinLatitude = 40.484872
    loc3.locationLongitude = 69.0092393
    RealmManager.saveLocation(locationDetails: loc3)
    
    let loc4:LocationModel = LocationModel()
    loc4.locationName = "Office"
    loc4.locatoinLatitude = 10.484872
    loc4.locationLongitude = 39.0092393
    RealmManager.saveLocation(locationDetails: loc4)
}
