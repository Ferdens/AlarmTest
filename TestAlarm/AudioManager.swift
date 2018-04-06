//
//  AudioManager.swift
//  TestAlarm
//
//  Created by anton Shepetuha on 06.04.18.
//  Copyright © 2018 anton Shepetuha. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager: NSObject, AVAudioPlayerDelegate {
    
    static let shared = AudioManager()
    
    private var alarmAudioPlayer        : AVAudioPlayer?
    private var backgroundAudioPlayer   : AVAudioPlayer?
    private var vibrateTimer            : Timer?
    
    func alarmIsPlaying() -> Bool {
        return alarmAudioPlayer != nil
    }
    
    func playSilenceAudio() {
        let audioFileName = "silence"
        let audioFile = URL(fileURLWithPath: Bundle.main.path(forResource: audioFileName, ofType: "m4a")!)
        play(audioFile: audioFile, player: &backgroundAudioPlayer)
    }
    
    func playAlarmAudio() {
        let audioFileName = "alarmSound"
        let audioFile = URL(fileURLWithPath: Bundle.main.path(forResource: audioFileName, ofType: "wav")!)
        play(audioFile: audioFile, player: &alarmAudioPlayer)
        playVibrate()
    }
    
    func stopSilenceAudio() {
        if let player = backgroundAudioPlayer {
            if player.isPlaying {
                player.stop()
            }
        }
    }
    
    func stopAlarmAudio() {
        if let player = alarmAudioPlayer {
            if player.isPlaying {
                player.stop()
            }
        }
        stopVibrate()
    }
    
    private func play(audioFile: URL, player: inout AVAudioPlayer?) {
        if let player = player {
            if player.isPlaying {
                player.stop()
            }
        }
        do {
            player = try AVAudioPlayer.init(contentsOf: audioFile)
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            } catch {
            }
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
            }
        } catch {
        }
        player!.delegate = self
        player!.prepareToPlay()
        player!.play()
        player!.volume = 0.3
    }
    
    private func playVibrate() {
        if (vibrateTimer != nil) {
            vibrateTimer?.invalidate()
            vibrateTimer = nil
        }
        vibrateTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(AudioManager.shared.repeatVibrate(_:)), userInfo: nil, repeats: true)
    }
    
    private func stopVibrate() {
        if let timer = vibrateTimer {
            timer.invalidate()
            vibrateTimer = nil
        }
    }
    
   @objc private func repeatVibrate(_ timer: Timer) {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player == backgroundAudioPlayer {
            self.playSilenceAudio()
        }
        if player == alarmAudioPlayer {
            stopVibrate()
        }
    }
    
}
