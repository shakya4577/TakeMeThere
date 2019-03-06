import UIKit

extension HomeViewController

{
    @IBAction func longPressDetected(_ sender: UILongPressGestureRecognizer)
    {
        AppDelegate.speechManager.awakeVoiceInteractor()
    }
    
    @IBAction func swipeDetected(_ sender: UISwipeGestureRecognizer)
    {
        if(sender.direction == .up && !isSelection)
        {
            filterLocationList(filterInput: "")
        }
        else if(sender.direction == .up && isSelection)
        {
            locationSelectionCounter = locationSelectionCounter - 1
            selectDestination()
            let indexPath = NSIndexPath(item: locationSelectionCounter, section: 0)
            locationTableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: true)
        }
        else if(sender.direction == .right && !isSelection)
        {
            letsWalk()
        }
        else if(sender.direction == .right && isSelection)
        {
            takeMetoDestination()
        }
        else if(sender.direction == .down && isSelection)
        {
            locationSelectionCounter = locationSelectionCounter + 1
            selectDestination()
            let indexPath = NSIndexPath(item: locationSelectionCounter, section: 0)
            locationTableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: true)
        }
        else if(sender.direction == .down && !isSelection)
        {
            saveThisLocation()
        }
    }
    
    @IBAction func tapDetected(_ sender: UITapGestureRecognizer)
    {
        whereAmI()
    }
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
}
