
import UIKit

class NewUserViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate,GIDSignInUIDelegate
{
    
    @IBOutlet weak var middleLine: UIView!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var txtEmgPh3: UITextField!
    @IBOutlet weak var txtEmgPh2: UITextField!
    @IBOutlet weak var txtEmgPh1: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var txtFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtView2: UITextView!
    var stepCounter = 0
    var isFemale:Bool? = nil
    
    override func viewDidLoad()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        GIDSignIn.sharedInstance().clientID = "543859633967-v6fls8mp36rn5j2otak3m095p4vb0dnb.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        setupUI()
    }
    
    @objc func dismissKeyboard()
    {
       view.endEditing(true)
       resignFirstResponder()
    }
    
    
   
    
    
    
}
