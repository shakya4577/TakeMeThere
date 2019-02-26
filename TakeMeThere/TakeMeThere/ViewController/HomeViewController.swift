import UIKit
import Speech
class HomeViewController: UIViewController,SFSpeechRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,PrimeDelegate
{
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var mainView: UIImageView!
    
    private var localLocationList = [LocationModel]()
    private var isWalkMode = true
    private var isSelection = false
    private var locationSelectionCounter = 0
    @IBOutlet weak var txtLocationSearch: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTableView.delegate = self
        locationTableView.dataSource = self
        AppDelegate.primeDelegate = self
        txtLocationSearch.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
       // testRealm()
        localLocationList = RealmManager.getLocationList()
        print(UserDefaults.standard.string(forKey: Constants.UserNameKey)!)
        AppDelegate.speechManager.voiceOutput(message: "Hi " + UserDefaults.standard.string(forKey: Constants.UserNameKey)!)
    }
    
    func testRealm()
    {
        let loc1:LocationModel = LocationModel()
        loc1.locationName = "Loc1"
        loc1.locatoinLatitude = 30.484872
        loc1.locationLongitude = 49.0092393
        RealmManager.saveLocation(locationDetails: loc1)
        
        let loc2:LocationModel = LocationModel()
        loc2.locationName = "Loc2"
        loc2.locatoinLatitude = 70.484872
        loc2.locationLongitude = 59.0092393
        RealmManager.saveLocation(locationDetails: loc2)
        
        let loc3:LocationModel = LocationModel()
        loc3.locationName = "Loc2"
        loc3.locatoinLatitude = 40.484872
        loc3.locationLongitude = 69.0092393
        RealmManager.saveLocation(locationDetails: loc3)
        
        let loc4:LocationModel = LocationModel()
        loc4.locationName = "Loc3"
        loc4.locatoinLatitude = 10.484872
        loc4.locationLongitude = 39.0092393
        RealmManager.saveLocation(locationDetails: loc4)
    }
    
    @IBAction func longPressDetected(_ sender: UILongPressGestureRecognizer)
    {
        AppDelegate.speechManager.awakeVoiceInteractor()
    }
    
   
    @IBAction func swipeDetected(_ sender: UISwipeGestureRecognizer)
    {
        if(sender.direction == .up && !isSelection)
        {
            filterLocationList(filterInput: "")
        }
        else if(sender.direction == .up && isSelection)
        {
            locationSelectionCounter = locationSelectionCounter - 1
            selectDestination()
        }
        else if(sender.direction == .right && !isSelection)
        {
            letsWalk()
        }
        else if(sender.direction == .right && isSelection)
        {
           takeMetoDestination()
        }
        else if(sender.direction == .down && isSelection)
        {
            locationSelectionCounter = locationSelectionCounter + 1
            selectDestination()
        }
    }
    
    @IBAction func tapDetected(_ sender: UITapGestureRecognizer)
    {
        whereAmI()
    }
    
    func whereAmI()
    {
        let locationManager = LocationManager()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            locationManager.getUserLocatoin { (location: String) in
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
        localLocationList = localLocationList.filter { $0.locationName.contains(filterInput) }
        locationTableView.reloadData()
        selectDestination()
    }
    
    func selectDestination()
    {
        if(locationSelectionCounter<0 || locationSelectionCounter>localLocationList.count-1)
        {
            AppDelegate.speechManager.voiceOutput(message: "No more location available")
            return
        }
        AppDelegate.speechManager.voiceOutput(message: localLocationList[locationSelectionCounter].locationName)
     }
    
    func letsWalk() {
        isWalkMode = true
        performSegue(withIdentifier: "VisionSegue", sender: Data())
    }
    
    func takeMetoDestination()
    {
        isWalkMode = false
        performSegue(withIdentifier: "VisionSegue", sender: Data())
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is VisionViewController
        {
            let visionViewController = segue.destination as? VisionViewController
            visionViewController?.isWalk = isWalkMode
            if(!isWalkMode)
            {
                visionViewController?.destinationLocation = localLocationList[locationSelectionCounter]
            }
        }
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

