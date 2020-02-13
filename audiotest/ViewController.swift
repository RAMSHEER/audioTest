//
//  ViewController.swift
//  audiotest
//
//  Created by Purpose Code on 12/02/20.
//  Copyright © 2020 EmojiView. All rights reserved.
//

import UIKit
import SwiftAudio
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
    private var isScrubbing: Bool = false
    private let controller = AudioController.shared
    private var lastLoadFailed: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      controller.player.event.stateChange.addListener(self, handleAudioPlayerStateChange)
              controller.player.event.secondElapse.addListener(self, handleAudioPlayerSecondElapsed)
              controller.player.event.seek.addListener(self, handleAudioPlayerDidSeek)
              controller.player.event.updateDuration.addListener(self, handleAudioPlayerUpdateDuration)
              controller.player.event.didRecreateAVPlayer.addListener(self, handleAVPlayerRecreated)
              controller.player.event.fail.addListener(self, handlePlayerFailure)
              updateMetaData()
              handleAudioPlayerStateChange(data: controller.player.playerState)
    }


    @IBAction func slider(_ sender: Any) {
          isScrubbing = true
        print("scrubbing")
        
    }
    @IBAction func previous(_ sender: Any) {
        print("prev")
          print(controller.player.currentIndex)
         try? controller.player.previous()
    }
    @IBAction func next(_ sender: Any) {
        print("next")
        print(controller.sources?.count)
        print(controller.player.currentIndex)
          try? controller.player.next()
        
        
        
    }
    @IBAction func playPause(_ sender: Any) {
        
        if !controller.audioSessionController.audioSessionIsActive {
                   try? controller.audioSessionController.activateSession()
               }
               if lastLoadFailed, let item = controller.player.currentItem {
                   lastLoadFailed = false
                   try? controller.player.load(item: item, playWhenReady: true)
               }
               else {
                   controller.player.togglePlaying()
               }
        
    }
    
    
    
    func updateTimeValues() {
//        self.slider.maximumValue = Float(self.controller.player.duration)
//        self.slider.setValue(Float(self.controller.player.currentTime), animated: true)
//        self.elapsedTimeLabel.text = self.controller.player.currentTime.secondsToString()
//        self.remainingTimeLabel.text = (self.controller.player.duration - self.controller.player.currentTime).secondsToString()
    }
    
    func updateMetaData() {
//        if let item = controller.player.currentItem {
//            titleLabel.text = item.getTitle()
//            artistLabel.text = item.getArtist()
//            item.getArtwork({ (image) in
//                self.imageView.image = image
//            })
//        }
    }
    
    func setPlayButtonState(forAudioPlayerState state: AudioPlayerState) {
//        playButton.setTitle(state == .playing ? "Pause" : "Play", for: .normal)
    }
    
    func setErrorMessage(_ message: String) {
//        self.loadIndicator.stopAnimating()
//        errorLabel.isHidden = false
//        errorLabel.text = message
    }
    
    // MARK: - AudioPlayer Event Handlers
    
    func handleAudioPlayerStateChange(data: AudioPlayer.StateChangeEventData) {
        print(data)
        DispatchQueue.main.async {
            self.setPlayButtonState(forAudioPlayerState: data)
            switch data {
            case .loading:
//                self.loadIndicator.startAnimating()
                self.updateMetaData()
                self.updateTimeValues()
            case .buffering:
                break
//                self.loadIndicator.startAnimating()
            case .ready:
//                self.loadIndicator.stopAnimating()
                self.updateMetaData()
                self.updateTimeValues()
            case .playing, .paused, .idle:
//                self.loadIndicator.stopAnimating()
                self.updateTimeValues()
            }
        }
    }
    
    func handleAudioPlayerSecondElapsed(data: AudioPlayer.SecondElapseEventData) {
        if !isScrubbing {
            DispatchQueue.main.async {
                self.updateTimeValues()
            }
        }
    }
    
    func handleAudioPlayerDidSeek(data: AudioPlayer.SeekEventData) {
        isScrubbing = false
    }
    
    func handleAudioPlayerUpdateDuration(data: AudioPlayer.UpdateDurationEventData) {
        DispatchQueue.main.async {
            self.updateTimeValues()
        }
    }
    
    func handleAVPlayerRecreated() {
        try? controller.audioSessionController.set(category: .playback)
    }
    
    func handlePlayerFailure(data: AudioPlayer.FailEventData) {
        if let error = data as NSError? {
            if error.code == -1009 {
                lastLoadFailed = true
                DispatchQueue.main.async {
                    self.setErrorMessage("Network disconnected. Please try again...")
                }
            }
        }
    }
    
}

