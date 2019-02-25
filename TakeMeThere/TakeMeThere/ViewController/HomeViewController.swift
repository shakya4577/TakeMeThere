import UIKit
import Speech
class HomeViewController: UIViewController,SFSpeechRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,PrimeDelegate
{
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var mainView: UIImageView!
    
    private var localLocationList = ["Australia","Australia one","Australia two","Australia three","four Australia me","France","France one","France two","France three","USA","South Africa","Canada","India"]
    
    private var isWalkMode = true
    private var isSelection = false
    @IBOutlet weak var txtLocationSearch: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTableView.delegate = self
        locationTableView.dataSource = self
        AppDelegate.primeDelegate = self
        txtLocationSearch.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    func testRealm()
    {
        let userDetailModel:UserDetailModel = UserDetailModel()
        userDetailModel.userName = "Test User"
        userDetailModel.userEmergencyNumber = "11111"
        userDetailModel.userNumber = "2222"
        userDetailModel.userAddress = "Test Address"
        RealmManager.saveUserDetail(userDetails: userDetailModel)
    }
    
    @IBAction func longPressDetected(_ sender: UILongPressGestureRecognizer)
    {
        AppDelegate.speechManager.awakeVoiceInteractor()
    }
    
   
    @IBAction func swipeDetected(_ sender: UISwipeGestureRecognizer)
    {
        if(sender.direction == .up && !isSelection)
        {
            filterLocationInput()
        }
        else if(sender.direction == .up && isSelection)
        {
            
        }
        else if(sender.direction == .right)
        {
            letsWalk()
        }
        else if(sender.direction == .down && isSelection)
        {
            
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
        if(textField.text == "")
        {
            return
        }
        localLocationList = localLocationList.filter { $0.contains(searchText) }
        locationTableView.reloadData()
    }
    
    func filterLocationInput(filterInput: String="")
    {
        localLocationList = localLocationList.filter { $0.contains(filterInput) }
        locationTableView.reloadData()
    }
    
   func letsWalk() {
        isWalkMode = true
        performSegue(withIdentifier: "VisionSegue", sender: Data())
    }
    
    func takeMetoDestination(destination:String)
    {
        isSelection = true
        isWalkMode = false
        performSegue(withIdentifier: "VisionSegue", sender: Data())
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is VisionViewController
        {
            let visionViewController = segue.destination as? VisionViewController
            visionViewController?.isWalk = isWalkMode
            visionViewController?.destinationLat = 28.6825662
            visionViewController?.destinationLong = 77.2321066
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localLocationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LocationTableCell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath) as! LocationTableCell
        cell.initCell(locName: localLocationList[indexPath.row])
        return cell
    }
    
    
}

