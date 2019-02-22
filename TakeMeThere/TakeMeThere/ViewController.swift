import UIKit
import Speech
class ViewController: UIViewController,SFSpeechRecognizerDelegate {

   
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var mainView: UIImageView!
    private var isWalkFlag = true;
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is MyEyesARViewController
        {
            let arVC = segue.destination as? MyEyesARViewController
            arVC?.isWalk = isWalkFlag
            arVC?.destinationLat = 28.6825662
            arVC?.destinationLong = 77.2321066
            
        }
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
       isWalkFlag = true
       performSegue(withIdentifier: "segueExplore", sender: Data())
    }
    
    func letsWalk()
    {
       performSegue(withIdentifier: "segueExplore", sender: Data())
    }
}

