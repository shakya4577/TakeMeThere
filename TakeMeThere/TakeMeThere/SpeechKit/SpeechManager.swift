
import UIKit
import Speech

class SpeechManager: NSObject, SFSpeechRecognizerDelegate
{
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine:AVAudioEngine? = AVAudioEngine()
    private let audioSession = AVAudioSession.sharedInstance()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var voiceInteractorSemaphor = true
    private var listeningSempahor = true
    private var voiceInputMessage = String()
    override init()
    {
        super.init()
        setupSpeechKit()
    }
    
     func setupSpeechKit()
    {
        speechRecognizer!.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
        }
    }
    
    func voiceInput() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine!.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer!.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            if result != nil {
                self.voiceInputMessage = (result?.bestTranscription.formattedString)!
                if(self.listeningSempahor)
                {
                  self.listeningSempahor = false
                    Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.voiceInputAction), userInfo: nil, repeats: false)
                }
                //print(self.voiceInputMessage)
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
      
        if(voiceInputMessage == "Let's walk")
        {
           AppDelegate.homeViewController.letsWalk()
        }
        else
        {
            let index = voiceInputMessage.index(voiceInputMessage.startIndex, offsetBy: 10)
            let isTakeMeCommand = voiceInputMessage[..<index]
            let destination:String = String(voiceInputMessage[index...voiceInputMessage.endIndex])
            if (isTakeMeCommand == "Take me to")
            {
                AppDelegate.homeViewController.takeMetoDestination(destination: destination);
            }
        }
    }
    
    func awakeVoiceInteractor()
    {
        if(voiceInteractorSemaphor)
        {
            voiceInteractorSemaphor = false;
            _ = Timer.scheduledTimer(withTimeInterval: 20, repeats: false)
            { timer in
                self.voiceInteractorSemaphor = true
            }
            AppDelegate.homeViewController.filterLocationTableSource(filterString: "Australia")
//            voiceOutput(message: Constants.awakeMessage)
//            sleep(2)
//            voiceInput()
        }
    }
    
    func voiceOutput(message:String)
    {
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
//    func getUserCommand(completion: @escaping (_ isWalk:Bool, _ destination: String) -> Void)
//    {
//       self.awakeVoiceInteractor()
//        completion(isWalk,voiceInputMessage)
//    }
    
    
}
