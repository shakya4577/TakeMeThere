

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {

    var window: UIWindow?
    static let speechManager:SpeechManager = SpeechManager()
    static let locationManager:LocationManager = LocationManager()
    static let homeViewController:HomeViewController = HomeViewController()
    static var primeDelegate:PrimeDelegate?
    static var visionDelegate:VisionDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        print(UserDefaults.standard.bool(forKey: Constants.userRegisterDone))
        if(!UserDefaults.standard.bool(forKey: Constants.userRegisterDone))
        {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let newUserViewController = mainStoryBoard.instantiateViewController(withIdentifier: "NewUserViewController") as! NewUserViewController
            self.window?.rootViewController = newUserViewController
            GIDSignIn.sharedInstance().delegate = self
            
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil)
        {
            // Perform any operations on signed in user here.
            // ...
        } else
        {
            print("\(error.localizedDescription)")
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (error == nil)
        {
            // Perform any operations on signed in user here.
            // ...
        } else
        {
            print("\(error.localizedDescription)")
        }
        
    }

}

