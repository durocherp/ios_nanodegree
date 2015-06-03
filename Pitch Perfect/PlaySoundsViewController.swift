//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Paul Durocher on 5/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.


import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var error:NSError?
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    //var isPlaying:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error:nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        pauseButton.hidden = true
        resumeButton.hidden = true
        //isPlaying = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0
        audioPlayer.play()
        //isPlaying = true
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate = 1.5
        audioPlayer.currentTime = 0
        audioPlayer.play()
        //isPlaying = true
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.play()
        
        let delay:NSTimeInterval = 0.5 // 500ms
        var playtime:NSTimeInterval
        playtime = audioPlayer2.deviceCurrentTime + delay
        
        audioPlayer2.stop()
        audioPlayer2.currentTime = 0
        audioPlayer2.volume = 0.8;
        audioPlayer2.playAtTime(playtime)
    }
    
    @IBAction func playReverb(sender: UIButton) {
        
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
//        audioPlayer.stop()
//        audioPlayer.currentTime = 0
//        
//        var audioPlayerNode = AVAudioPlayerNode() //pitch player
//        audioEngine.attachNode(audioPlayerNode)
//        
//        var audioDelay = AVAudioUnitDelay()
//        audioEngine.attachNode(audioDelay)
//        
//        var audioReverb = AVAudioUnitReverb()
//        audioReverb.wetDryMix = 10
//        
//        audioEngine.attachNode(audioReverb)
//        
//        audioEngine.connect(audioPlayerNode, to: audioReverb, format:nil)
//        //audioEngine.connect(audioDelay, to: audioPlayerNode, format:nil)
//        
//        audioEngine.connect(audioReverb, to: audioDelay, format:nil)
//        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
//        audioEngine.startAndReturnError(nil)
//        audioPlayerNode.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format:nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    @IBAction func pauseAudio(sender: UIButton) {
    // audioPlayer.pause()
    //    pauseButton.hidden = true
        resumeButton.hidden = false
    }
    
    @IBAction func resumeAudio(sender: AnyObject) {
        audioPlayer.play()
        resumeButton.hidden = true
     //   pauseButton.hidden = false
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }
}
