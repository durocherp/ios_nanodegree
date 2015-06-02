//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Paul Durocher on 5/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.


import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioReverb = AVAudioUnitReverb()
    var audioDelay = AVAudioUnitDelay()
    var error:NSError?
    var wetDryMix:Float = 0.0
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error:nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.rate = 1.5
        audioPlayer.currentTime = 0
        audioPlayer.play()
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
        
        let delay:NSTimeInterval = 0.5 //100ms
        var playtime:NSTimeInterval
        playtime = audioPlayer2.deviceCurrentTime + delay
        
        audioPlayer2.stop()
        audioPlayer2.currentTime = 0
        audioPlayer2.volume = 0.8;
        audioPlayer2.playAtTime(playtime)
    }
    
    func loadFactoryPreset(preset: AVAudioUnitReverbPreset) {
        
    
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        audioEngine.attachNode(audioDelay)
        audioEngine.attachNode(audioReverb)
        var reverbPreset = AVAudioUnitReverbPreset(rawValue: 10)
        
        
        //audioEngine.connect(<#node1: AVAudioNode!#>, to: <#AVAudioNode!#>, format: <#AVAudioFormat!#>)
//        audioEngine.connect(input, to: delay, format: format)
//        audioEngine.connect(delay, to: reverb, format: format)
//        audioEngine.connect(reverb, to: output, format: format)
        
        //**********************
//        let delay:NSTimeInterval = 0.02
//        for i in 0...N{
//            var curDelay:NSTimeInterval = delay * NSTimeInterval(i)
//            var player:AVAudioPlayer = reverbPlayers[i]
//            
//            var exponent:Double = -Double(i)/Double(N/2)
//            var volume = Float(pow(Double(M_E), exponent))
//            player.volume = volume
//            player.playAtTime(player.deviceCurrentTime + curDelay)
//        }
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
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }
}
