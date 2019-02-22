import UIKit
import Speech
class ViewController: UIViewController,SFSpeechRecognizerDelegate {

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
    
    @IBAction func btnLetsWalkClick(_ sender: Any)
    {
       performSegue(withIdentifier: "ToARViewController", sender: Data())
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is MyEyesARViewController
        {
            let arVC = segue.destination as? MyEyesARViewController
            arVC?.destinationLat = 28.6825662
            arVC?.destinationLong = 77.2321066
        }
    }
}

