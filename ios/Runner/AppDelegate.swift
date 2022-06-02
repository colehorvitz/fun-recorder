import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterEventChannel(name: "com.example.fun_recorder/recorder",
                                              binaryMessenger: controller.binaryMessenger)
    batteryChannel.setStreamHandler(RecordingStreamHandler())

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
}

class RecordingStreamHandler: NSObject, FlutterStreamHandler {
    var recordingSession: AVAudioSession!
    var audioRecorder: AudioRecorder!
    var events:FlutterEventSink!

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        let path = arguments as! String
        self.audioRecorder = AudioRecorder(path: path, events: events)
        self.audioRecorder.record()
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.audioRecorder.stop()
        return nil
    }
    
    
    
}



class AudioRecorder: NSObject, AVAudioRecorderDelegate  {
    var recorder:AVAudioRecorder!
    let path:String
    var isRecording:Bool = false
    let events:FlutterEventSink
    var recordingSession:AVAudioSession!
    var ampHistory:Array = [Float]()
    
    init(path:String, events: @escaping FlutterEventSink) {
        self.path = path
        self.events = events
        self.recordingSession = AVAudioSession.sharedInstance()
    }
    
    func normalPower(power:Float) -> Float {
        return exp(power/20)
    }
    
    func record() -> Void {
        do {
            let settings = [
                  AVFormatIDKey: kAudioFormatLinearPCM,
                  AVSampleRateKey: 44100,
                  AVEncoderBitRateKey: 320000,
                  AVNumberOfChannelsKey: 2,
                  AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ] as [String : Any]
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recorder = try AVAudioRecorder(url: URL(string: path)!, settings: settings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.record()
        } catch let error as NSError{
            events(error.description)
        }
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if (self.recorder.isRecording){
                self.recorder.updateMeters()
                let power = self.recorder.averagePower(forChannel: 0)
                let latestPower = Float(self.ampHistory.count + 1) * power - Float(self.ampHistory.last ?? 0.0)
                let duration = Int(self.recorder.currentTime * 1000)
                let path = self.recorder.url.absoluteString
                var recordingResult = [String : Any]()
                recordingResult["amp"] = self.normalPower(power: latestPower)
                recordingResult["duration"] = duration
                recordingResult["path"] = path
                self.events(recordingResult)
            }
        }
    }
    
    func stop() {
        recorder.stop()
        do {
            try recordingSession.setCategory(.playback)
        } catch{
            events(error)
        }
    }
    

}
