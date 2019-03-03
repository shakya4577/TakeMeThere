import UIKit
import Speech
import MapKit
import Vision
class HomeViewController: UIViewController,SFSpeechRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,PrimeDelegate
{
    
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var mainView: UIImageView!
    
    private var localLocationList = [LocationModel]()
    private var isWalkMode = true
    internal var isSelection = false
    internal var locationSelectionCounter = 0
    @IBOutlet weak var txtLocationSearch: UITextField!
    
    let visionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisionViewController") as! VisionViewController
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
     //  testRealm()
        locationTableView.delegate = self
        locationTableView.dataSource = self
        AppDelegate.primeDelegate = self
        AppDelegate.locationManager.appleMap = mapView
        txtLocationSearch.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
       localLocationList = RealmManager.getLocationList()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
        resignFirstResponder()
    }
   
    func whereAmI()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            AppDelegate.locationManager.getUserLocatoin { (location: String) in
                AppDelegate.speechManager.voiceOutput(message:"You are at " + location)
            }
        })
    }
    
    @objc func textFieldDidChange(textField: UITextField)
    {
        let searchText = textField.text!
        localLocationList = RealmManager.getLocationList()
        if(searchText != "")
        {
            localLocationList = localLocationList.filter { $0.locationName.contains(searchText) }
            if(localLocationList.count==0)
            {
                AppDelegate.locationManager.searchLocationList(locationInput: textField.text!) {
                    (returnedlocationList:[LocationModel])
                    in
                    self.localLocationList = returnedlocationList
                    self.locationTableView.reloadData()
                }
            }
        }
        else
        {
            localLocationList = RealmManager.getLocationList()
        }
        locationTableView.reloadData()
    }
    
    func filterLocationList(filterInput: String)
    {
        isSelection = true
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
    
    func letsWalk() {
        self.navigationController?.pushViewController(visionViewController, animated: true)
    }
    
    func takeMetoDestination()
    {
        visionViewController.isLocalDestination = RealmManager.isLocationExists(locationName:  localLocationList[locationSelectionCounter].locationName)
        visionViewController.destinationLocation = localLocationList[locationSelectionCounter];
        self.navigationController?.pushViewController(visionViewController, animated: true)
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localLocationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LocationTableCell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath) as! LocationTableCell
        cell.initCell(locName: localLocationList[indexPath.row].locationName)
        return cell
    }
    
    func saveThisLocation()
    {
        AppDelegate.locationManager.saveCurrentLocation { (isSuccess:Bool) in
            if(isSuccess)
            {
                AppDelegate.speechManager.voiceOutput(message: "Location Saved successfully ")
            }
            else
            {
                AppDelegate.speechManager.voiceOutput(message: "Couldn't save location")
            }
        }
    }
}





//
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
