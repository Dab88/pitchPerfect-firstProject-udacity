//
//  PlaySoundsViewController.swift
//  Udacity-Project1
//
//  Created by dvelasquez c on 9/26/15.
//  Copyright (c) 2015 Mahisoft. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    //MARK: UI Objects
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    //MARK: Variables
    var audioPlayer:AVAudioPlayer?
    var audioPlayerNode: AVAudioPlayerNode?
    var audioEngine: AVAudioEngine?
    var audioFile: AVAudioFile?
    
    var recordReceivedAudio: RecordedAudio?
    
    
    //MARK: App Cycle Life
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAudio()
    }
    
    override func viewWillAppear(animated: Bool){
        stopBtn.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: IBActions
    @IBAction func stopAudio(sender: AnyObject) {
        playMode(active: false)
    }
    
    
    @IBAction func changeVolume(sender: AnyObject) {
        audioPlayer?.volume = self.volumeSlider.value
    }
    
    @IBAction func playAudioSlowMode(sender: AnyObject) {
        playAudioWithVariableRate(0.5)
    }
    
    
    @IBAction func playAudioFastode(sender: AnyObject) {
        playAudioWithVariableRate(2.0)
    }
    
    @IBAction func playAudioDarthVaderMode(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playAudioChipmunkMode(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func playAudioReverbMode(sender: AnyObject) {
        playAudioWithAditionalEffects(reverb: 90)
    }
    
    @IBAction func playAudioEchoMode(sender: AnyObject) {
        playAudioWithAditionalEffects(echo: 2)
    }
    
    
    //MARK: Logical Functions
    
    func loadAudio(){
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: recordReceivedAudio!.filePathUrl)
        
        //Get audio
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL: (recordReceivedAudio?.filePathUrl)!)
        }catch{
            print("Problems getting the audio")
        }
        /*
        
        if var audioPath = NSBundle.mainBundle().pathForResource(fileName, ofType:fileExtension){
        //Transform String to NSURL
        var audioURL = NSURL.fileURLWithPath(audioPath)
        //Get audio
        audioPlayer = AVAudioPlayer(contentsOfURL: audioURL, fileTypeHint: nil)
        }
        else{
        print("Problems finding \(fileName).\(fileExtension)")
        }*/
    }
    
    
    func playAudioWithVariableRate(rate: Float = 1.0){
        
        //Previous configure
        playMode(active: true)
        
        audioPlayer?.volume = 1.0 //self.volumeSlider.value
        audioPlayer?.enableRate = true
        audioPlayer?.currentTime = 0.0 // For play the sound since the 0
        
        //Config rate
        audioPlayer?.rate = rate
        audioPlayer?.play()
    }
    
    
    func playAudioWithVariablePitch(pitch: Float = 1.0){
        
        //Basic settings
        playMode(active: true)
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine!.attachNode(audioPlayerNode)
        
        
        //Pitch
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine!.attachNode(changePitchEffect)
        
        
        audioEngine!.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine!.connect(changePitchEffect, to: audioEngine!.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile!, atTime: nil, completionHandler: nil)
        try! audioEngine!.start()
        
        audioPlayerNode.play()
    }
    
    
    func playAudioWithAditionalEffects(reverb reverb: Float = 0, echo: Float = 0){
        
        //Basic settings
        playMode(active: true)
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine!.attachNode(audioPlayerNode)
        
        
        //Reverb effect
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = reverb
        audioEngine!.attachNode(reverbEffect)
        
        
        //Echo effect
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = NSTimeInterval(echo)
        audioEngine!.attachNode(echoEffect)
        
        audioEngine!.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine!.connect(reverbEffect, to: echoEffect, format: nil)
        audioEngine!.connect(echoEffect, to: audioEngine!.outputNode, format: nil)
        
        
        audioPlayerNode.scheduleFile(audioFile!, atTime: nil, completionHandler: nil)
        try! audioEngine!.start()
        
        audioPlayerNode.play()
        
    }
    
    
    func playMode(active active: Bool){
        
        audioPlayer?.stop()
        audioEngine!.stop()
        audioEngine!.reset()
        
        stopBtn.enabled = active
        
    }
    
    
}
