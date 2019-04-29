import UIKit
protocol VisionDelegate
{
    func NavigateToVision(isLocalLocation:Bool)
    func filterLocationList(filterInput: String)
    func whereAmI()
    func saveThisLocation()
}

extension VisionDelegate
{
    func saveThisLocation()
    {
        AppDelegate.locationManager.saveCurrentLocation { (isSuccess:Bool) in
            if(isSuccess)
            {
                AppDelegate.speechManager.voiceOutput(message: "Location Saved successfully ")
            }
            else
            {
                AppDelegate.speechManager.voiceOutput(message: "Couldn't save location")
            }
        }
    }
    
    func whereAmI()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            AppDelegate.locationManager.getUserLocatoin { (location: String) in
                AppDelegate.speechManager.voiceOutput(message:"You are at " + location,commandType:  Constants.VoiceCommand.VoiceCommandInfo)
            }
        })
    }
    func NavigateToVision(isLocalLocation:Bool)
    {
        
    }
    func filterLocationList(filterInput: String)
    {
        
    }
}
