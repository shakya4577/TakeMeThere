import UIKit
extension HomeViewController
{
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchEditingSemaphor
        {
            searchEditingSemaphor = false
            _ = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in
                self.searchEditingSemaphor = true
                self.localLocationList = RealmManager.getLocationList()
                if(searchBar.text != "")
                {
                    self.localLocationList = self.localLocationList.filter { $0.locationName.contains(searchBar.text!)}
                    if(self.localLocationList.count==0)
                    {
                        AppDelegate.locationManager.searchLocationList(locationInput: searchBar.text!) {
                            (returnedlocationList:[LocationModel])
                            in
                            self.localLocationList = returnedlocationList
                            self.locationTableView.reloadData()
                        }
                    }
                }
                else
                {
                    self.localLocationList = RealmManager.getLocationList()
                }
                self.locationTableView.reloadData()
            }
        }
    }
    
    @IBAction func longPressDetected(_ sender: UILongPressGestureRecognizer)
    {
       
        AppDelegate.speechManager.voiceOutput(message: "Hi I am Listening", commandType: Constants.VoiceCommand.VoiceCommandAwakeInteractor);
    }
    
    @IBAction func swipeDetected(_ sender: UISwipeGestureRecognizer)
    {
        let isLocalLocation = searchBar.text?.isEmpty
        
        switch sender.direction
        {
        case .up:
            locationSelectionCounter = locationSelectionCounter - 1
            selectDestination()
            let indexPath = NSIndexPath(item: locationSelectionCounter, section: 0)
            locationTableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: true)
        case .right: NavigateToVision(isLocalLocation: isLocalLocation!)
        case .down :  locationSelectionCounter = locationSelectionCounter + 1
        selectDestination()
        let indexPath = NSIndexPath(item: locationSelectionCounter, section: 0)
        locationTableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.top, animated: true)
        default:
            return
        }
    }
    
    @IBAction func tapDetected(_ sender: UITapGestureRecognizer)
    {
       AppDelegate.visionDelegate?.whereAmI()
    }
    
   
}
