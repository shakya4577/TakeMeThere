
import UIKit

class NewUserViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate
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
    var stepCounter : Int
    {
        get
        {
          return  UserDefaults.standard.integer(forKey: Constants.userRegisterStepCounterKey)
        }
        set
        {
            UserDefaults.standard.set(newValue, forKey: Constants.userRegisterStepCounterKey)
            setupUI()
        }
    }
    
    var isFemale:Bool? = nil
    override func viewDidLoad()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        formView.layer.cornerRadius = 10
        setupUI()
    }
    
    @objc func dismissKeyboard()
    {
       view.endEditing(true)
       resignFirstResponder()
    }
    
    private func setupUI()
    {
        UserDefaults.standard.integer(forKey: Constants.userRegisterStepCounterKey)
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
                  stepCounter = 1
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
                stepCounter = 2
            }
        }
        else
        {
            if(isTextFieldValid(textField: nil, textView: txtView) && isTextFieldValid(textField: nil, textView: txtView2) )
            {
                UserDefaults.standard.set(txtView.text, forKey: Constants.userEmgAddrOneKey)
                UserDefaults.standard.set(txtView2.text, forKey: Constants.userEmgAddrTwoKey)
                UserDefaults.standard.set(true, forKey: Constants.userRegisterDone)
                performSegue(withIdentifier: "LetsWalkSegue", sender: Data())
            }
        }
    }
    
    private func isTextFieldValid(textField:UITextField!=nil,textView:UITextView!=nil)->Bool
    {
        if let textBox = textField
        {
            if(textBox.text!.isEmpty)
            {
                textBox.layer.borderColor = UIColor.red.cgColor
                textBox.layer.borderWidth = 2.0
                return false
            }
            return true
        }
        else
        {
            if(textView.text!.isEmpty)
            {
                textView.layer.borderColor = UIColor.red.cgColor
                textView.layer.borderWidth = 2.0
                return false
            }
            return true
        }
    }
    
    
    @IBAction func btnGenderClick(_ sender: UIButton)
    {
        let selectedColor = UIColor(red: 58.0/255.0, green: 89.0/255.0, blue: 123.0/255.0, alpha: 1.0).cgColor
        
        sender.layer.borderColor = selectedColor
        sender.layer.borderWidth = 4.0
        sender.layer.cornerRadius = 10.0
        
        if sender == btnFemale
        {
            isFemale = true
            btnMale.layer.borderWidth = 0.0
        }
        else
        {
            isFemale = false
            btnFemale.layer.borderWidth = 0.0
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
       return range.location < 10
    }
   
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        textView.text = nil
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text.isEmpty
        {
            if textView == txtView
            {
                textView.text = "Enter First Emergency Address"
            }
            else
            {
                 textView.text = "Enter Second Emergency Address"
            }
        }
    }
}
