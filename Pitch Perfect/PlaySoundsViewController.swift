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
    
    var currentState = playerState.isStopped
    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEffect:AVAudioUnitEffect!
    
    var error:NSError?
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    enum playerState {
        case isPlaying
        case isStopped
        case isPaused
    }

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
        //state = .isPlaying(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0
        audioPlayer.play()
        pauseButton.hidden = false
        resumeButton.hidden = true
        //isPlaying = true
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate = 1.5
        audioPlayer.currentTime = 0
        audioPlayer.play()
        pauseButton.hidden = false
        //isPlaying = true
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        playAudioWithVariablePitch(1000)
        pauseButton.hidden = false
        resumeButton.hidden = true
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        playAudioWithVariablePitch(-1000)
        pauseButton.hidden = false
        resumeButton.hidden = true
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.play()
        pauseButton.hidden = false
        resumeButton.hidden = true
        
        let delay:NSTimeInterval = 0.5 // 500ms
        var playtime:NSTimeInterval
        playtime = audioPlayer2.deviceCurrentTime + delay
        
        audioPlayer2.stop()
        audioPlayer2.currentTime = 0
        audioPlayer2.volume = 0.8;
        audioPlayer2.playAtTime(playtime)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var audioDelay = AVAudioUnitDelay()
        audioEngine.attachNode(audioDelay)
        
        var audioReverb = AVAudioUnitReverb()
        audioReverb.wetDryMix = 10
        
        audioEngine.attachNode(audioReverb)
        audioEngine.connect(audioPlayerNode, to: audioReverb, format:nil)
        audioEngine.connect(audioReverb, to: audioEngine.outputNode, format:nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
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
        //if currentState == playerState.isPlaying{
        if audioPlayer.playing{
            audioPlayer.pause()
            audioEngine.pause()
            pauseButton.hidden = true
            resumeButton.hidden = false
        }
    }
    
    @IBAction func resumeAudio(sender: AnyObject) {
        //if currentState == playerState.isPaused{
        if audioPlayer.playing{
            audioPlayer.play()
            resumeButton.hidden = true
            pauseButton.hidden = false
        }
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }
}
