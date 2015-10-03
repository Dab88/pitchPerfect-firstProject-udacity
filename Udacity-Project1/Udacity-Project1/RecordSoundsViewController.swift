//
//  RecordSoundsViewController.swift
//  Udacity-Project1
//
//  Created by dvelasquez c on 9/26/15.
//  Copyright (c) 2015 Mahisoft. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {
    
    //MARK: UI Objects
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var recordingLbl: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var restartBtn: UIButton!
    
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio?
    
    
    //MARK: App Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        recordingMode(active: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: IBActions
    @IBAction func recordAudio(sender: AnyObject) {
        
        recordingMode(active: true)
        
        //Get path
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //Set the record name
        let recordingName = "pitchAudioDaniela.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        
        recordingMode(active: false)
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBAction func pauseRecordAudio(sender: UIButton) {
        pauseMode(active: true)
    }
    
    
    @IBAction func restartRecordAudio(sender: UIButton) {
        
        pauseMode(active: false)
        
        
    }
    
    
    //MARK:
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "stopRecording"){
            
            let playVC = segue.destinationViewController as! PlaySoundsViewController
            
            playVC.recordReceivedAudio = recordedAudio
            
        }
    }
    
    
    func recordingMode(active active: Bool){
        
        recordingLbl.hidden = false
        recordingLbl.text = active ? "Recording …" : "Tap to Record"
        
        
        recordBtn.enabled = !active
        
        stopBtn.hidden = !active
        restartBtn.hidden = !active
        pauseBtn.hidden = !active
        
        if(!active){
            try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        
        
    }
    
    func pauseMode(active active: Bool){
        
        restartBtn.enabled = active
        
        recordingLbl.text = active ? "Paused" : "Recording …"
       
        if(active){
            audioRecorder.pause()
        }else{
            audioRecorder.record()
        }
        
    }
    
}

extension RecordSoundsViewController: AVAudioRecorderDelegate{
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool){
        //Create a model RecordedAudio instance
        recordedAudio = RecordedAudio()
        recordedAudio?.filePathUrl = recorder.url
        recordedAudio?.title = recorder.url.lastPathComponent
        
        self.performSegueWithIdentifier("stopRecording", sender: self)
    }
}

