import UIKit
import Speech
class ViewController: UIViewController,SFSpeechRecognizerDelegate {

   
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var mainView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
}

