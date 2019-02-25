import UIKit
import Speech
class HomeViewController: UIViewController,SFSpeechRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,VisionDelegate
{
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var mainView: UIImageView!
    private var localLocationList = ["Australia","Australia one","Australia two","Australia three","four Australia me","France","France one","France two","France three","USA","South Africa","Canada","India"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTableView.delegate = self
        locationTableView.dataSource = self
        AppDelegate.visioinDelegate = self
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
    
    @IBAction func panDetected(_ sender: UIPanGestureRecognizer)
    {
        
    }
    
    func youAreAt(location: String) {
        
    }
    
    func letsWalk() {
        let exploreViewController = self.storyboard!.instantiateViewController(withIdentifier: "ExplorerViewController") as? ExplorerViewController
        exploreViewController?.isWalk = true
        navigationController!.pushViewController(exploreViewController!, animated: true)
    }
    
    func filterLocationInput(filterInput: String)
    {
        localLocationList = localLocationList.filter { $0.contains(filterInput) }
        locationTableView.reloadData()
    }
    
    
    func takeMetoDestination(destination:String)
    {
        let exploreViewController = self.storyboard!.instantiateViewController(withIdentifier: "ExplorerViewController") as? ExplorerViewController
        exploreViewController?.isWalk = false
        navigationController!.pushViewController(exploreViewController!, animated: true)
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

