import UIKit
import Speech
class HomeViewController: UIViewController,SFSpeechRecognizerDelegate,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var mainView: UIImageView!
    var tempDataSource = ["Australia","France","USA","South Africa","Canada","India"]
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTableView.delegate = self
        locationTableView.dataSource = self
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
    
    func takeMetoDestination()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let exploreViewController = storyboard.instantiateViewController(withIdentifier: "ExplorerViewController") as? ExplorerViewController
        exploreViewController?.isWalk = false
        let navigationController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
        navigationController.pushViewController(exploreViewController!, animated: true)
    }
    
    func letsWalk()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let exploreViewController = storyboard.instantiateViewController(withIdentifier: "ExplorerViewController") as? ExplorerViewController
        exploreViewController?.isWalk = true
        let navigationController = UIApplication.shared.keyWindow?.rootViewController as! UINavigationController
        navigationController.pushViewController(exploreViewController!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LocationTableCell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath) as! LocationTableCell
        cell.initCell(locName: tempDataSource[indexPath.row])
        return cell
    }
    
    
}

