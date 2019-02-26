
import UIKit

class NewUserViewController: UIViewController
{
    
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
        setupUI()
    }
    @objc func dismissKeyboard()
    {
       view.endEditing(true)
       resignFirstResponder()
    }
    
    private func setupUI()
    {
        stepCounter = UserDefaults.standard.integer(forKey: Constants.userRegisterStepCounterKey)
        if(stepCounter==1)
        {
            txtField.isHidden = true
            btnMale.isHidden = true
            btnFemale.isHidden = true
            
            txtEmgPh1.isHidden = false
            txtEmgPh2.isHidden = false
            txtEmgPh3.isHidden = false
        }
        else if(stepCounter == 2)
        {
            txtField.isHidden = true
            btnMale.isHidden = true
            btnFemale.isHidden = true
            txtEmgPh1.isHidden = true
            txtEmgPh2.isHidden = true
            txtEmgPh3.isHidden = true
            
            txtView.isHidden = false
            txtView2.isHidden = false
        }
    }
    
    @IBAction func btnNextClick(_ sender: Any)
    {
        if(stepCounter==0)
        {
            if(isTextFieldValid(textField: txtField))
            {
               if let gender = isFemale
               {
                  UserDefaults.standard.set(txtField.text, forKey: Constants.UserNameKey)
                  UserDefaults.standard.set(gender, forKey: Constants.UserGenderKey)
                stepCounter = stepCounter+1
                UserDefaults.standard.set(stepCounter, forKey: Constants.userRegisterStepCounterKey)
                setupUI()
               }
                else
                {
                  btnMale.layer.borderColor = UIColor.red.cgColor
                  btnMale.layer.borderWidth = 1.0
                  btnFemale.layer.borderColor = UIColor.red.cgColor
                  btnFemale.layer.borderWidth = 1.0
                }
            }
        }
        else if(stepCounter == 1)
        {
            if(isTextFieldValid(textField: txtEmgPh1) && isTextFieldValid(textField: txtEmgPh2) && isTextFieldValid(textField: txtEmgPh3))
            {
                UserDefaults.standard.set(txtEmgPh1.text, forKey: Constants.userEmgNoOneKey)
                UserDefaults.standard.set(txtEmgPh2.text, forKey: Constants.userEmgNoTwoKey)
                UserDefaults.standard.set(txtEmgPh3.text, forKey: Constants.userEmgNoThreeKey)
                stepCounter = stepCounter+1
                UserDefaults.standard.set(stepCounter, forKey: Constants.userRegisterStepCounterKey)
                setupUI()
            }
        }
        else
        {
            if(isTextFieldValid(textField: nil, textView: txtView) && isTextFieldValid(textField: nil, textView: txtView2) )
            {
                UserDefaults.standard.set(txtView.text, forKey: Constants.userEmgAddrOneKey)
                UserDefaults.standard.set(txtView2.text, forKey: Constants.userEmgAddrTwoKey)
                stepCounter = stepCounter+1
                UserDefaults.standard.set(stepCounter, forKey: Constants.userRegisterStepCounterKey)
                 UserDefaults.standard.set(true, forKey: Constants.userRegisterDone)
                performSegue(withIdentifier: "LetsWalkSegue", sender: Data())
            }
        }
    }
    
    private func isTextFieldValid(textField:UITextField!=nil,textView:UITextView!=nil)->Bool
    {
        if(textField != nil)
        {
            if(textField.text=="")
            {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
                return false
            }
            return true
        }
        if(textView != nil)
        {
            if(textView.text=="")
            {
                textView.layer.borderColor = UIColor.red.cgColor
                textView.layer.borderWidth = 1.0
                return false
            }
            return true
        }
        return true
    }
    
    @IBAction func btnFemaleClick(_ sender: Any)
    {
        btnFemale.layer.borderColor = UIColor.blue.cgColor
        btnFemale.layer.borderWidth = 2.0
        isFemale = true
    }
    @IBAction func btnMaleClick(_ sender: Any)
    {
        btnMale.layer.borderColor = UIColor.blue.cgColor
        btnMale.layer.borderWidth = 2.0
        isFemale = false
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    {
//        if segue.destination is VisionViewController
//        {
//            let visionViewController = segue.destination as? VisionViewController
//            visionViewController?.isWalk = isWalkMode
//            if(!isWalkMode)
//            {
//                visionViewController?.destinationLocation = localLocationList[locationSelectionCounter]
//            }
//        }
//    }
}
