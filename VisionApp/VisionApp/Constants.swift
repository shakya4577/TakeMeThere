import Foundation

class Constants
{
    //User Default Keys
    static var UserNameKey = "UserName"
    static var UserGenderKey = "UserGender"
    static var userEmgNoOneKey = "UserEmgNoOne"
    static var userEmgNoTwoKey = "UserEmgNoTWo"
    static var userEmgNoThreeKey = "UserEmgNoThree"
    static var userEmgAddrOneKey = "UserEmgAddOne"
    static var userEmgAddrTwoKey = "UserEmgAddTwo"
    static var userRegisterStepCounterKey = "UserRegisterCounter"
    static var userRegisterDone = "UserRegisterDone"
    // Constant strings
    static var awakeMessage = "Hi! I am listening"
    static var nextMoveNotificationName = Notification.Name(rawValue: "isNavigationAvailble")
  
     public enum VoiceCommand
     {
        case VoiceCommandAwakeInteractor
        case VoiceCommandLocationName
        case VoiceCommandLocatoiPlacemark
        case VoiceCommandInfo
     }
}
