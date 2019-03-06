import UIKit

extension VisionViewController
{
    @IBAction func swipeDetected(_ sender: UISwipeGestureRecognizer)
    {
        if(sender.direction == .down)
        {
            saveThisLocation()
        }
        if(sender.direction == .left)
        {
            AppDelegate.speechManager.voiceOutput(message: "Taking you to home Screen")
            sleep(2)
            navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func tapDetected(_ sender: UITapGestureRecognizer)
    {
        AppDelegate.locationManager.getUserLocatoin { (location: String) in
            AppDelegate.speechManager.voiceOutput(message:"You are at " + location)
        }
    }
    
    func longPressDetected(_ sender: Any)
    {
       AppDelegate.speechManager.voiceOutput(message: "Hi I am Listening", commandType: Constants.VoiceCommand.VoiceCommandAwakeInteractor);
    }
}
