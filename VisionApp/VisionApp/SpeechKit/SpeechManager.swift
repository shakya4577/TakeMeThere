
import UIKit
import Speech

class SpeechManager: NSObject, SFSpeechRecognizerDelegate,AVSpeechSynthesizerDelegate
{
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine:AVAudioEngine? = AVAudioEngine()
    private var audioSession = AVAudioSession.sharedInstance()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    let synthesizer = AVSpeechSynthesizer()
    private var listeningSempahor = true
    private var voiceInputMessage = String()
    private var locationName = String()
    private var locationPlacemark = String()
    internal var voiceInteractorSemaphor = true
    var currentSpeechCommad:Constants.VoiceCommand = Constants.VoiceCommand.VoiceCommandInfo;
    let systemSoundID: SystemSoundID = 1322
    override init()
    {
        super.init()
        setupSpeechKit()
    }
    
     func setupSpeechKit()
    {
        speechRecognizer!.delegate = self
        synthesizer.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
        }
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
         do
        {
            audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            //try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
                
        } catch
        {
                    
        }
    }
    
    func voiceInput()
    {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        let inputNode = audioEngine!.inputNode
        inputNode.removeTap(onBus: 0)
        recognitionRequest.shouldReportPartialResults = true
         recognitionTask = speechRecognizer!.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            if result != nil
            {
               self.voiceInputMessage = (result?.bestTranscription.formattedString)!
                    if(self.listeningSempahor)
                    {
                        self.listeningSempahor = false
                        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.voiceInputAction), userInfo: nil, repeats: false)
                    }
            }
            if error != nil  {
                self.audioEngine!.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine!.prepare()
        do {
            try audioEngine!.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    @objc func voiceInputAction()
    {
        voiceInputMessage = voiceInputMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        print(" final "+voiceInputMessage)
        
        if(currentSpeechCommad == Constants.VoiceCommand.VoiceCommandAwakeInteractor)
        {
            if(voiceInputMessage == "Let's walk")
            {
                AppDelegate.visionDelegate!.NavigateToVision(isLocalLocation: false)
            }
            else if(voiceInputMessage == "Where am I")
            {
                AppDelegate.visionDelegate!.whereAmI()
            }
            else
            {
                if(voiceInputMessage.count<10)
                {
                    return
                }
                let index = voiceInputMessage.index(voiceInputMessage.startIndex, offsetBy: 10)
                let isTakeMeCommand = voiceInputMessage[..<index]
                print(String(isTakeMeCommand))
                let destination = voiceInputMessage[index...]
                print(String(destination))
                if (isTakeMeCommand == "Take me to")
                {
                    AppDelegate.visionDelegate!.filterLocationList(filterInput: String(destination))
                }
            }
        }
        else if(currentSpeechCommad == Constants.VoiceCommand.VoiceCommandLocationName)
        {
            locationName = voiceInputMessage
            voiceOutput(message: "What is the placemark for this location", commandType: Constants.VoiceCommand.VoiceCommandLocatoiPlacemark)
        }
        else if(currentSpeechCommad == Constants.VoiceCommand.VoiceCommandLocatoiPlacemark)
        {
            locationPlacemark = voiceInputMessage
        }
        
    }
    
    func voiceOutput(message:String,commandType:Constants.VoiceCommand=Constants.VoiceCommand.VoiceCommandInfo)
    {
        if(voiceInteractorSemaphor)
        {
            voiceInteractorSemaphor = false;
            _ = Timer.scheduledTimer(withTimeInterval: 20, repeats: false)
            { timer in
                self.voiceInteractorSemaphor = true
            }
            currentSpeechCommad = commandType
            let utterance = AVSpeechUtterance(string: message)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            synthesizer.speak(utterance)
        }
    }
    
     public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance)
     {
        if(currentSpeechCommad != Constants.VoiceCommand.VoiceCommandInfo)
        {
           AudioServicesPlaySystemSound (systemSoundID)
           voiceInput()
        }
     }
    
    func inputsToSaveLocation()->(String,String)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0, execute: {
            self.voiceOutput(message: "What is the location name",commandType: Constants.VoiceCommand.VoiceCommandLocationName)
        });
      return (locationName,locationPlacemark)

    }
}

