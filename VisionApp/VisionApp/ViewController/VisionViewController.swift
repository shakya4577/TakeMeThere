import UIKit
import ARKit
import SceneKit
import CoreLocation
import MapKit
import SpriteKit
import ARKit
import Vision

class VisionViewController: UIViewController,VisionDelegate,ARSKViewDelegate, ARSessionDelegate
{
    var tempNavAvailableFlag = Bool()
    var isNavigationAvailable: Bool
    {
        set
        {
              tempNavAvailableFlag = newValue
              if let dest = destinationLocation
              {
                self.title = dest.locationName
              }
              if(newValue)
              {
               sceneViewBottomConstraint.constant = 0
               routeMap.isHidden = false
              }
        }
        get
        {
            return tempNavAvailableFlag
        }
        
    }
    
    @IBOutlet weak var routeMap: MKMapView!
    @IBOutlet weak var lblInfoTwo: UILabel!
    @IBOutlet weak var sceneViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblInfoOne: UILabel!
    @IBOutlet weak var sceneView: ARSKView!
    var destinationLocation:LocationModel?
    var isLocalDestination:Bool?
    static var sharedInstance = VisionViewController()

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        AppDelegate.visionDelegate = self
        AppDelegate.locationManager.appleMap = routeMap
        NotificationCenter.default.addObserver(self, selector: #selector(nextMoveSelector(_:)), name: Constants.nextMoveNotificationName, object: nil)
      
        let overlayScene = SKScene()
        overlayScene.scaleMode = .aspectFill
        sceneView.delegate = self
        sceneView.presentScene(overlayScene)
        sceneView.session.delegate = self
        
    }
    
    @objc func nextMoveSelector(_ notification:Notification)
    {
        if let data = notification.userInfo as? [String: String]
        {
            AppDelegate.speechManager.voiceOutput(message: data["NexStep"]!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        sceneViewBottomConstraint.constant = -1 * routeMap.frame.height
        routeMap.isHidden = true
        if let dest = destinationLocation
        {
            AppDelegate.locationManager.destinationCoordinate = CLLocationCoordinate2D(latitude: dest.locatoinLatitude, longitude: dest.locationLongitude)
        }
        else
        {
            self.title = "Walking"
        }
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func whereAmI(location:String)
    {
        AppDelegate.locationManager.getUserLocatoin { (location:String) in
            AppDelegate.speechManager.voiceOutput(message: location)
        }
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
    
    //Vision Framework//
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard currentBuffer == nil, case .normal = frame.camera.trackingState else {
            return
        }
        self.currentBuffer = frame.capturedImage
        classifyCurrentImage()
    }
    
    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: Inceptionv3().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            request.usesCPUOnly = true
            
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    // The pixel buffer being held for analysis; used to serialize Vision requests.
    private var currentBuffer: CVPixelBuffer?
    
    // Queue for dispatching vision classification requests
    private let visionQueue = DispatchQueue(label: "com.example.apple-samplecode.ARKitVision.serialVisionQueue")
    
    private func classifyCurrentImage() {
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(UIDevice.current.orientation.rawValue))
        
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: currentBuffer!, orientation: orientation!)
        visionQueue.async {
            do {
                defer { self.currentBuffer = nil }
                try requestHandler.perform([self.classificationRequest])
            } catch {
                print("Error: Vision request failed with error \"\(error)\"")
            }
        }
    }
    
    private var identifierString = ""
    private var confidence: VNConfidence = 0.0
   
    func processClassifications(for request: VNRequest, error: Error?) {
        guard let results = request.results else {
            print("Unable to classify image.\n\(error!.localizedDescription)")
            return
        }
        let classifications = results as! [VNClassificationObservation]
        
        if let bestResult = classifications.first(where: { result in result.confidence > 0.5 }),
            let label = bestResult.identifier.split(separator: ",").first {
            identifierString = String(label)
            confidence = bestResult.confidence
        } else {
            identifierString = ""
            confidence = 0
        }
        DispatchQueue.main.async { [weak self] in
            self?.displayClassifierResults()
        }
    }
    
    private func displayClassifierResults() {
        guard !self.identifierString.isEmpty else {
            return // No object was classified.
        }
        let message = String(format: "Detected \(self.identifierString) with %.2f", self.confidence * 100) + "% confidence"
        print(message)
        let detectedMessage = String(format: "Detected \(self.identifierString)")
        AppDelegate.speechManager.voiceOutput(message: detectedMessage)
    }
    
}


