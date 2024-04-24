//
//  PlayerViewController.swift
//  MuslimFit
//
//  Created by Karim on 01/10/2023.
//

import UIKit
import SwiftAudioEx
import AVKit

class PlayerViewController: UIViewController {

//    private let controller = AudioController.shared
    var flag = false
    var adaih = [AdaihModel]()
    var quran = [QuranModel]()
    var favouritedQuran = [Quran]()
    var index = 0
    var audioPlayer = AVAudioPlayer()
    
    lazy var containerView: PlayerContainerView = {
//        if flag {
        let view = PlayerContainerView(view: self, quran: quran, favouritedQuran: favouritedQuran, index: index, audioPlayer: audioPlayer)
            return view
//        } else {
//            let view = PlayerContainerView(view: self, quran: quran, index: index, audioPlayer: audioPlayer)
//            return view
//        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        
        self.containerView.onTapDownloadBTN = { [weak self] in
            self?.showTimedAlert(message: LanguageManager.lang(withKey: "Downloading", value: "Downloading") ?? "")
        }
        
        self.containerView.downloadedBTN = { [weak self] in
            self?.showTimedAlert(message: LanguageManager.lang(withKey: "Downloaded", value: "Downloaded") ?? "")
        }
        
//        let player = QueuedAudioPlayer()
//        let audioItem = DefaultAudioItem(audioUrl: "someUrl", sourceType: .stream)
//        try? player.add(item: audioItem, playWhenReady: true)
        
//        controller.player.event.playWhenReadyChange.addListener(self, handlePlayWhenReadyChange)
//        controller.player.event.stateChange.addListener(self, handleAudioPlayerStateChange)
//        controller.player.event.playbackEnd.addListener(self, handleAudioPlayerPlaybackEnd(data:))
//        controller.player.event.secondElapse.addListener(self, handleAudioPlayerSecondElapsed)
//        controller.player.event.seek.addListener(self, handleAudioPlayerDidSeek)
//        controller.player.event.updateDuration.addListener(self, handleAudioPlayerUpdateDuration)
//        controller.player.event.didRecreateAVPlayer.addListener(self, handleAVPlayerRecreated)
//        handleAudioPlayerStateChange(data: controller.player.playerState)
//        DispatchQueue.main.async {
//            self.render()
//        }
        if !favouritedQuran.isEmpty {
            self.containerView.titleLabel.text = favouritedQuran[index].name
        } else {
            self.containerView.titleLabel.text = quran[index].name
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        guard let url = URL(string: "\(quran[index].audio ?? "")") else {
//            return
//        }
////        play(url: url)
//        self.containerView.playAudio(at: url)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.containerView.player = nil
        self.containerView.timer = nil
    }

    override func loadView() {
        super.loadView()
        self.view = containerView
    }
}
