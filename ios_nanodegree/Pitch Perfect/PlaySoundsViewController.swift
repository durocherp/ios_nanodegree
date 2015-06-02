//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Paul Durocher on 5/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//  PlayEchoAudio and PlayReverbAudio

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var reverb = AVAudioUnitReverb()
    var delay = AVAudioUnitDelay()
    var error:NSError?
    //var reverbPlayers:[AVAudioPlayer] = []
    //let N:Int = 10
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error:nil)
//        for i in 0...N {
//            var temp = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
//            reverbPlayers.append(temp)
//        }
        
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
    
    @IBAction func playReverbAudio(sender: UIButton) {
        audioEngine.attachNode(delay)
        audioEngine.attachNode(reverb)
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
