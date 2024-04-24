//
//  PlayerContainerView.swift
//  MuslimFit
//
//  Created by Karim on 01/10/2023.
//

import Foundation
import UIKit
//import SwiftAudioEx
import AVFoundation
//import MediaPlayer

class PlayerContainerView: UIView {
    
    var view = UIViewController()
    var adaih = [AdaihModel]()
    var quran = [QuranModel]()
    var favouritedQuran = [Quran]()
    var audioPlayer: AVAudioPlayer?
    //    var audioPlayer: AVAudioPlayer? = AVAudioPlayer()
    
    //    var audioPlayer = AVAudioPlayer()
    
    var index = 0
    var played = false
    var repeated = false
    
    var player: AVPlayer?
    //    var player: AVAudioPlayer?
    
    var timer: Timer?
    
    var longTap: UILongPressGestureRecognizer?
    
    private var trackDuration: Float = 0 {
        didSet {
            self.slider.minimumValue = 0
            self.slider.maximumValue = trackDuration
//            self.remainingTimeLabel.text = "\(trackDuration)"
        }
    }
    
    private var isScrubbing: Bool = false
    //    private let controller = AudioController.shared
    //    let player = QueuedAudioPlayer()
    //    let audioItem = DefaultAudioItem(audioUrl: "https://denx.suppwhey.net/public/assets/doaa_audios/1.mp3", sourceType: .stream)
    //    player.add(item: audioItem, playWhenReady: true)
    
    lazy var background: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "muslim_alarm_bg")
        return imageView
    }()
    
    lazy var backBTN: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "home_date_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        if LanguageManager.shareInstance().getHttpLanguageType() == "ar" {
            button.transform = CGAffineTransform(rotationAngle: 180 - 45)
        }
        button.addTarget(self, action: #selector(didTappedBackBTN), for: .touchUpInside)
        return button
    }()
    
    lazy var titleImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "frame")
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "sssssssss"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(scrubbing), for: .touchUpInside)
        slider.addTarget(self, action: #selector(scrubbing), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(startScrubbing), for: .touchDown)
        slider.addTarget(self, action: #selector(scrubbingValueChanged), for: .valueChanged)
        return slider
    }()
    
    lazy var timeStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 0
        stack.alignment = .fill
        stack.distribution = .equalCentering
        return stack
    }()
    
    lazy var elapsedTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "00:00"
        return label
    }()
    
    lazy var remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "00:00"
        return label
    }()
    
    lazy var playStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    lazy var repeatBackground: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 30
        btn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btn.addTarget(self, action: #selector(repeatAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var repeatBTN: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .black
        btn.setImage(UIImage(named: "repeat")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 12.5
//        btn.transform = CGAffineTransform(rotationAngle: 180 - 45)
        btn.addTarget(self, action: #selector(repeatAction), for: .touchUpInside)
        //        btn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        //        btn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        return btn
    }()
    
    lazy var prevBackground: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 30
        btn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btn.addTarget(self, action: #selector(prevAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var prevBTN: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .black
        btn.setImage(UIImage(named: "previous")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 12.5
//        btn.transform = CGAffineTransform(rotationAngle: 180 - 45)
        btn.addTarget(self, action: #selector(prevAction), for: .touchUpInside)
        //        btn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        //        btn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        return btn
    }()
    
    lazy var playBackground: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 30
        btn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btn.addTarget(self, action: #selector(playAction), for: .touchUpInside)
//        btn.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(sleepAction)))
//        btn.addTarget(self, action: #selector(sleepAction), for: .touchDragInside)
        return btn
    }()
    
    lazy var playBTN: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .black
        btn.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysTemplate), for: .normal)
        //        btn.transform = CGAffineTransform(rotationAngle: 180 - 45)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 12.5
        btn.addTarget(self, action: #selector(playAction), for: .touchUpInside)
//        btn.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(sleepAction(gesture:))))
//        btn.addTarget(self, action: #selector(sleepAction), for: .)
        //        btn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        //        btn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        return btn
    }()
    
    lazy var pauseBackground: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 30
        btn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btn.addTarget(self, action: #selector(pauseAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var pauseBTN: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .black
        btn.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysTemplate), for: .normal)
        //        btn.transform = CGAffineTransform(rotationAngle: 180 - 45)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 12.5
        btn.addTarget(self, action: #selector(pauseAction), for: .touchUpInside)
        //        btn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        //        btn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        return btn
    }()
    
    lazy var nextBackground: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 30
        btn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var nextBTN: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .black
        btn.setImage(UIImage(named: "forward")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 12.5
        btn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        //        btn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        //        btn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        return btn
    }()
    
    lazy var stopBackground: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 30
        btn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btn.addTarget(self, action: #selector(stopAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var stopBTN: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .black
        btn.setImage(UIImage(named: "stop")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 12.5
        btn.addTarget(self, action: #selector(stopAction), for: .touchUpInside)
        //        btn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        //        btn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        return btn
    }()
    
    lazy var downloadBackground: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 30
        btn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        btn.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var downloadBTN: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .black
        btn.setImage(UIImage(named: "download")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 12.5
        btn.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
        //        btn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        //        btn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        return btn
    }()
    
    lazy var holdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LanguageManager.lang(withKey: "Hold on pause button for sleep timer", value: "Hold on pause button for sleep timer") ?? ""
//        label.text = "Hold on pause button for sleep timer"
        return label
    }()
    
    init(view: UIViewController, quran: [QuranModel], favouritedQuran: [Quran], index: Int, audioPlayer: AVAudioPlayer) {
        self.view = view
        self.quran = quran
        self.index = index
        self.favouritedQuran = favouritedQuran
        //        self.audioPlayer = audioPlayer
        
        super.init(frame: .zero)
        
        longTap = UILongPressGestureRecognizer(target: self, action: #selector(sleepAction(gesture:)))
        NotificationCenter.default.addObserver(self, selector: #selector(sleepTimeAction), name: NSNotification.Name("sleepTime"), object: nil)
        
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
        //        audioPlayer = AVAudioPlayer()
        self.layoutUserInterFace()
//        guard let url = URL(string: "\(quran[index].audio ?? "")") else {
//            return
//        }
////        if FileManager.default.fileExists(atPath: <#T##String#>)
////        play(url: url)
////        downloadAudio(url: url) { destinationURL in
////            <#code#>
////        }
////        if player.
//        playDownloadedOrLive(url: url)
        
        //        playAudio(at: url)
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func playDownloadedOrLive(url: URL) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let destinationURL = URL(fileURLWithPath: documentsPath).appendingPathComponent(url.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            play(url: destinationURL)
        } else {
            play(url: url)
        }
    }
    
    private func layoutUserInterFace() {
        self.addSubViews()
        self.setupBackground()
        setupBackBTN()
        self.setupSlider()
        setupFrame()
        setupTitle()
        setupTimeStack()
        setupPlayStack()
        setupRepeatBTN()
        setupPrevBTN()
        setupPlayBTN()
//        setupPauseBTN()
        setupNextBTN()
        setupStopBTN()
        setupDownloadBTN()
        setupHoldLabel()
    }
    
    private func addSubViews() {
        
        addSubview(background)
        addSubview(backBTN)
        addSubview(slider)
        addSubview(titleImage)
        addSubview(titleLabel)
        addSubview(timeStack)
        addSubview(playStack)
        addSubview(repeatBTN)
        addSubview(prevBTN)
        addSubview(playBTN)
//        addSubview(pauseBTN)
        addSubview(stopBTN)
        addSubview(nextBTN)
        addSubview(downloadBTN)
        addSubview(holdLabel)
        
        timeStack.addArrangedSubview(elapsedTimeLabel)
        timeStack.addArrangedSubview(remainingTimeLabel)
        
        //        playStack.addArrangedSubview(prevBTN)
        //        playStack.addArrangedSubview(playBTN)
        //        playStack.addArrangedSubview(nextBTN)
        
        playStack.addArrangedSubview(repeatBackground)
        playStack.addArrangedSubview(prevBackground)
        playStack.addArrangedSubview(playBackground)
//        playStack.addArrangedSubview(pauseBackground)
        playStack.addArrangedSubview(stopBackground)
        playStack.addArrangedSubview(nextBackground)
        playStack.addArrangedSubview(downloadBackground)
    }
    
    private func setupBackground() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: self.topAnchor),
            background.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupBackBTN() {
        NSLayoutConstraint.activate([
            backBTN.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            backBTN.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            backBTN.heightAnchor.constraint(equalToConstant: 25),
            backBTN.widthAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setupSlider() {
        NSLayoutConstraint.activate([
            slider.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 50),
            slider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            slider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
    }
    
    private func setupFrame() {
        NSLayoutConstraint.activate([
//            titleImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
            titleImage.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -25),
            titleImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            titleImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            titleImage.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    private func setupTitle() {
        NSLayoutConstraint.activate([
            //            titleLabel.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: 25),
//            titleLabel.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -25),
            //            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            titleLabel.centerXAnchor.constraint(equalTo: titleImage.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleImage.centerYAnchor)
//            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func setupTimeStack() {
        NSLayoutConstraint.activate([
            timeStack.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 8),
            timeStack.leadingAnchor.constraint(equalTo: slider.leadingAnchor),
            timeStack.trailingAnchor.constraint(equalTo: slider.trailingAnchor)
        ])
    }
    
    private func setupPlayStack() {
        NSLayoutConstraint.activate([
            playStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -250),
            //            playStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 100),
            //            playStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -100),
            playStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupRepeatBTN() {
        NSLayoutConstraint.activate([
            repeatBTN.centerXAnchor.constraint(equalTo: repeatBackground.centerXAnchor),
            repeatBTN.centerYAnchor.constraint(equalTo: repeatBackground.centerYAnchor),
            repeatBTN.widthAnchor.constraint(equalToConstant: 20),
            repeatBTN.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupPrevBTN() {
        NSLayoutConstraint.activate([
            prevBTN.centerXAnchor.constraint(equalTo: prevBackground.centerXAnchor),
            prevBTN.centerYAnchor.constraint(equalTo: prevBackground.centerYAnchor),
            prevBTN.widthAnchor.constraint(equalToConstant: 20),
            prevBTN.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupPlayBTN() {
        NSLayoutConstraint.activate([
            playBTN.centerXAnchor.constraint(equalTo: playBackground.centerXAnchor),
            playBTN.centerYAnchor.constraint(equalTo: playBackground.centerYAnchor),
            playBTN.widthAnchor.constraint(equalToConstant: 20),
            playBTN.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupPauseBTN() {
        NSLayoutConstraint.activate([
            pauseBTN.centerXAnchor.constraint(equalTo: pauseBackground.centerXAnchor),
            pauseBTN.centerYAnchor.constraint(equalTo: pauseBackground.centerYAnchor),
            pauseBTN.widthAnchor.constraint(equalToConstant: 20),
            pauseBTN.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupNextBTN() {
        NSLayoutConstraint.activate([
            nextBTN.centerXAnchor.constraint(equalTo: nextBackground.centerXAnchor),
            nextBTN.centerYAnchor.constraint(equalTo: nextBackground.centerYAnchor),
            nextBTN.widthAnchor.constraint(equalToConstant: 20),
            nextBTN.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupStopBTN() {
        NSLayoutConstraint.activate([
            stopBTN.centerXAnchor.constraint(equalTo: stopBackground.centerXAnchor),
            stopBTN.centerYAnchor.constraint(equalTo: stopBackground.centerYAnchor),
            stopBTN.widthAnchor.constraint(equalToConstant: 20),
            stopBTN.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupDownloadBTN() {
        NSLayoutConstraint.activate([
            downloadBTN.centerXAnchor.constraint(equalTo: downloadBackground.centerXAnchor),
            downloadBTN.centerYAnchor.constraint(equalTo: downloadBackground.centerYAnchor),
            downloadBTN.widthAnchor.constraint(equalToConstant: 20),
            downloadBTN.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupHoldLabel() {
        NSLayoutConstraint.activate([
            holdLabel.topAnchor.constraint(equalTo: playStack.bottomAnchor, constant: 15),
            holdLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    @objc func startScrubbing() {
        isScrubbing = true
    }
    
    @objc func scrubbing() {
        //        controller.player.seek(to: Double(slider.value))
    }
    
    @objc func scrubbingValueChanged() {
        //        let value = Double(slider.value)
        //        elapsedTimeLabel.text = value.secondsToString()
        //        remainingTimeLabel.text = (controller.player.duration - value).secondsToString()
    }
    
    @objc func didTappedBackBTN() {
        view.navigationController?.popViewController(animated: true)
    }
    
    @objc func repeatAction() {
        repeated = !repeated
        if repeated {
            repeatBTN.setImage(UIImage(named: "repeatOne")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            repeatBTN.setImage(UIImage(named: "repeat")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc func prevAction() {
        //        try? controller.player.previous()
        //        try? player.previous()
        if !favouritedQuran.isEmpty {
            if index == 0 {
                guard let url = URL(string: "\(favouritedQuran.last?.audio ?? "")") else {
                    return
                }
                //            playAudio(at: url)
                titleLabel.text = favouritedQuran.last?.name
                //            play(url: url)
                playDownloadedOrLive(url: url)
            } else {
                index = index-1
                guard let url = URL(string: "\(favouritedQuran[index].audio ?? "")") else {
                    return
                }
                //            playAudio(at: url)
                titleLabel.text = favouritedQuran[index].name
                //            play(url: url)
                playDownloadedOrLive(url: url)
            }
        } else {
            if index == 0 {
                guard let url = URL(string: "\(quran.last?.audio ?? "")") else {
                    return
                }
                //            playAudio(at: url)
                titleLabel.text = quran.last?.name
                //            play(url: url)
                playDownloadedOrLive(url: url)
            } else {
                index = index-1
                guard let url = URL(string: "\(quran[index].audio ?? "")") else {
                    return
                }
                //            playAudio(at: url)
                titleLabel.text = quran[index].name
                //            play(url: url)
                playDownloadedOrLive(url: url)
            }
        }
    }
    
    @objc func playAction() {
        //        if !controller.audioSessionController.audioSessionIsActive {
        //            try? controller.audioSessionController.activateSession()
        //        }
        
        //        try? player.add(item: audioItem, playWhenReady: true)
        
        timer?.invalidate()
//        slider.value = 0
                played = !played
                if played {
                    playBTN.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysTemplate), for: .normal)
//                    playBTN.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(sleepAction(gesture:))))
                    playBTN.addGestureRecognizer(longTap!)
                } else {
                    playBTN.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysTemplate), for: .normal)
//                    playBTN.removeGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(sleepAction(gesture:))))
                    playBTN.removeGestureRecognizer(longTap!)
                }
        if !favouritedQuran.isEmpty {
            guard let url = URL(string: "\(favouritedQuran[index].audio ?? "")") else {
                        return
                    }
            //        playAudio(at: url)
            //        play(url: url)
            
            if player?.timeControlStatus == .playing {
                player?.pause()
            } else {
                if ((player?.isPlaying) != nil) {
                    player?.play()
                } else {
                    playDownloadedOrLive(url: url)
                }
            }
        } else {
            guard let url = URL(string: "\(quran[index].audio ?? "")") else {
                        return
                    }
            //        playAudio(at: url)
            //        play(url: url)
            
            if player?.timeControlStatus == .playing {
                player?.pause()
            } else {
                if ((player?.isPlaying) != nil) {
                    player?.play()
                } else {
                    playDownloadedOrLive(url: url)
                }
            }
        }
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        
//        if ((player?.isPlaying) != nil) {
////            player?.play()
//            player?.pause()
//        } else {
////            if ((player?.isPlaying) != nil) {
////                player?.play()
////            } else {
////                //            player?.play()
////                            playDownloadedOrLive(url: url)
////            }
//            playDownloadedOrLive(url: url)
//
//        }
    }
    
    @objc func sleepAction(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
//            print("hold")
            let vc = SleepTimeViewController()
            view.present(vc, animated: true)
        }
    }
    
    @objc func sleepTimeAction() {
        player?.pause()
//        played = false
        played = false
        DispatchQueue.main.async { [weak self] in
            self?.playBTN.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @objc
    private func updateSlider() {
        guard let currentTime = player?.currentItem?.currentTime(), let duration = player?.currentItem?.asset.duration else { return }
        print("current time:", CMTimeGetSeconds(currentTime))
        print("float current time:", Float(CMTimeGetSeconds(currentTime)))
        slider.value = Float(CMTimeGetSeconds(currentTime))
        let d = duration - currentTime
        let s = getHoursMinutesSecondsFrom(seconds: CMTimeGetSeconds(currentTime))
        let ss = getHoursMinutesSecondsFrom(seconds: CMTimeGetSeconds(d))
        elapsedTimeLabel.text = "\(s.minutes):\(s.seconds)"
        remainingTimeLabel.text = "\(ss.minutes):\(ss.seconds)"
//        slider.value = 3.0
        print("slider value:", slider.value)
        
        if slider.value > 0.99*slider.maximumValue {
            if repeated {
                player = nil
                played = false
                playAction()
            } else {
                nextAction()
            }
        }
    }
    
    @objc func pauseAction() {
        //        guard let url = URL(string: "https://denx.suppwhey.net\(adaih[index].url ?? "")") else {
        //            return
        //        }
        //        pause(url: url)
        player?.pause()
    }
    
    @objc func nextAction() {
        //        try? controller.player.next()
        //        try? player.next()
        if !favouritedQuran.isEmpty {
            if index == quran.count-1 {
                guard let url = URL(string: "\(favouritedQuran.first?.audio ?? "")") else {
                    return
                }
                //            playAudio(at: url)
                titleLabel.text = favouritedQuran.first?.name
    //            play(url: url)
                playDownloadedOrLive(url: url)
            } else {
                index = index+1
                guard let url = URL(string: "\(favouritedQuran[index].audio ?? "")") else {
                    return
                }
                //            playAudio(at: url)
                titleLabel.text = favouritedQuran[index].name
    //            play(url: url)
                playDownloadedOrLive(url: url)
            }
        } else {
            if index == quran.count-1 {
                guard let url = URL(string: "\(quran.first?.audio ?? "")") else {
                    return
                }
                //            playAudio(at: url)
                titleLabel.text = quran.first?.name
    //            play(url: url)
                playDownloadedOrLive(url: url)
            } else {
                index = index+1
                guard let url = URL(string: "\(quran[index].audio ?? "")") else {
                    return
                }
                //            playAudio(at: url)
                titleLabel.text = quran[index].name
    //            play(url: url)
                playDownloadedOrLive(url: url)
            }
        }
        
    }
    
    @objc func stopAction() {
        played = false
        playBTN.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysTemplate), for: .normal)
        player = nil
    }
    
    var onTapDownloadBTN: (() -> Void)?
    var downloadedBTN: (() -> Void)?
    
    @objc func downloadAction() {
        onTapDownloadBTN?()
        if !favouritedQuran.isEmpty {
            guard let url = URL(string: favouritedQuran[index].audio ?? "") else {
                return
            }
            downloadAudio(url: url) { destinationURL in
                if let destinationURL = destinationURL {
                    // File downloaded successfully, use the destinationURL for offline playback
                    print(destinationURL)
    //                self.play(url: destinationURL)
                    self.downloadedBTN?()
                    
                } else {
                    // File download failed
                    print("failed to download")
                    
                }
                
            }
        } else {
            guard let url = URL(string: quran[index].audio ?? "") else {
                return
            }
            downloadAudio(url: url) { destinationURL in
                if let destinationURL = destinationURL {
                    // File downloaded successfully, use the destinationURL for offline playback
                    print(destinationURL)
    //                self.play(url: destinationURL)
                    self.downloadedBTN?()
                } else {
                    // File download failed
                    print("failed to download")
                    
                }
                
            }
        }
        
    }
    
    func playAudio(at url: URL) {
        do {
            print(url)
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            //        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            if let uuuu = URL(string: "http://denx-dashboard.suppwhey.net/public//storage/Files/AudioSupplications/dashboard_16961576591.mp3") {
                print(uuuu)
                audioPlayer = try AVAudioPlayer(contentsOf: uuuu)
            }
            //            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer?.delegate = self
            
            //            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play audio:", error.localizedDescription)
        }
    }
    
    func play(url: URL) {
        print("playing \(url)")
        
        if player != nil {
//            guard let trackURL = viewModel.track(for: currentSong) else {
//                return
//            }
            let playerItem = AVPlayerItem(url: url as URL)
            
            self.player = try AVPlayer(playerItem:playerItem)
            if let duration = player?.currentItem?.asset.duration {
//                trackDuration = Float(CMTimeGetSeconds(duration))
//                self.remainingTimeLabel.text = "\(duration)"
                print("duration", duration)
                print("duration:", CMTimeGetSeconds(duration))
                trackDuration = Float(CMTimeGetSeconds(duration))
                let ss = getHoursMinutesSecondsFrom(seconds: CMTimeGetSeconds(duration))
                self.remainingTimeLabel.text = "\(ss.minutes):\(ss.seconds)"
//                print("track duration:", trackDuration)
            } else {
                print("else")
            }
//            player?.prepareToPlay()
            player!.volume = 1.0
            player?.play()
        } else {
            do {
                
                //            let player = AVPlayerItem(
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                let playerItem = AVPlayerItem(url: url as URL)
                
                self.player = try AVPlayer(playerItem:playerItem)
                
                if let duration = player?.currentItem?.asset.duration {
//                    self.remainingTimeLabel.text = "\(duration)"
//                    trackDuration = Float(CMTimeGetSeconds(duration))
                    print("duration:", duration)
                    print("duration:", CMTimeGetSeconds(duration))
                    trackDuration = Float(CMTimeGetSeconds(duration))
                    let ss = getHoursMinutesSecondsFrom(seconds: CMTimeGetSeconds(duration))
                    self.remainingTimeLabel.text = "\(ss.minutes):\(ss.seconds)"
//                    print("track duration:", trackDuration)
                } else {
                    print("else")
                }

                
                player!.volume = 1.0
                //                player?.prepareToPlay()
                player!.play()
            } catch let error as NSError {
                self.player = nil
                print(error.localizedDescription)
            } catch {
                print("AVAudioPlayer init failed")
            }

        }
        
//        }
        
    }
    
    func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        let secs = Int(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        return (hours, minutes, seconds)
    }
    
    func downloadAudio(url: URL, completion: @escaping (URL?) -> Void) {
        let session = URLSession(configuration: .default)
        let downloadTask = session.downloadTask(with: url) { (location, _, error) in
            guard let location = location, error == nil else {
                print("Failed to download audio file:", error?.localizedDescription ?? "")
                completion(nil)
                return
            }
            
            print(location)
            
            print("\(location)")
            
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let destinationURL = URL(fileURLWithPath: documentsPath).appendingPathComponent(url.lastPathComponent)
            
            
            do {
                
                if FileManager.default.fileExists(atPath: destinationURL.path) {
//                    try FileManager.default.removeItem(at: destinationURL)
                    completion(destinationURL)
                    
                }
                try FileManager.default.moveItem(at: location, to: destinationURL)
                print("Downloaded audio file:", destinationURL.path)
                completion(destinationURL)
            } catch {
                print("Failed to move audio file to destination:", error.localizedDescription)
                completion(nil)
            }
        }
        
        downloadTask.resume()
    }
    
    //    func pause(url: URL) {
    //        print("playing \(url)")
    //
    //        do {
    //
    //            let playerItem = AVPlayerItem(url: url as URL)
    //
    //            self.player = try AVPlayer(playerItem:playerItem)
    //            player!.volume = 1.0
    //            player!.pause()
    //        } catch let error as NSError {
    //            self.player = nil
    //            print(error.localizedDescription)
    //        } catch {
    //            print("AVAudioPlayer init failed")
    //        }
    //    }
    
    //    func renderTimeValues() {
    //        self.slider.maximumValue = Float(self.controller.player.duration)
    //        self.slider.setValue(Float(self.controller.player.currentTime), animated: true)
    //        self.elapsedTimeLabel.text = self.controller.player.currentTime.secondsToString()
    //        self.remainingTimeLabel.text = (self.controller.player.duration - self.controller.player.currentTime).secondsToString()
    //    }
    
    //    func render() {
    //        let player = self.controller.player
    //
    //        // Render play button
    //        self.playButton.setTitle(
    //            !player.playWhenReady || player.playerState == .failed
    //                ? "Play"
    //                : "Pause",
    //            for: .normal
    //        )
    //
    //        // Render metadata
    //        if let item = player.currentItem {
    //            self.titleLabel.text = item.getTitle()
    //            self.artistLabel.text = item.getArtist()
    //            item.getArtwork({ (image) in
    //                self.imageView.image = image
    //            })
    //        }
    //
    //        // Render time values
    //        self.renderTimeValues()
    //
    //        // Render error label
    //        if (player.playerState == .failed) {
    //            self.errorLabel.isHidden = false
    //            self.errorLabel.text = "Playback failed."
    //        } else {
    //            self.errorLabel.text = ""
    //            self.errorLabel.isHidden = true
    //        }
    //
    //        // Render load indicator:
    //        if (
    //            (player.playerState == .loading || player.playerState == .buffering)
    //            && self.controller.player.playWhenReady // Avoid showing indicator before user has pressed play
    //        ) {
    //            self.loadIndicator.startAnimating()
    //        } else {
    //            self.loadIndicator.stopAnimating()
    //        }
    //    }
    
    //    func handleAudioPlayerStateChange(data: AudioPlayer.StateChangeEventData) {
    //        print("state=\(data)")
    //        DispatchQueue.main.async {
    //            self.render()
    //        }
    //    }
    //
    //    func handlePlayWhenReadyChange(data: AudioPlayer.PlayWhenReadyChangeData) {
    //        print("playWhenReady=\(data)")
    //        DispatchQueue.main.async {
    //            self.render()
    //        }
    //    }
    //
    //    func handleAudioPlayerPlaybackEnd(data: AudioPlayer.PlaybackEndEventData) {
    //        print("playEndReason=\(data)")
    //    }
    //
    //    func handleAudioPlayerSecondElapsed(data: AudioPlayer.SecondElapseEventData) {
    //        if !isScrubbing {
    //            DispatchQueue.main.async {
    //                self.renderTimeValues()
    //            }
    //        }
    //    }
    //
    //    func handleAudioPlayerDidSeek(data: AudioPlayer.SeekEventData) {
    //        isScrubbing = false
    //    }
    //
    //    func handleAudioPlayerUpdateDuration(data: AudioPlayer.UpdateDurationEventData) {
    //        DispatchQueue.main.async {
    //            self.renderTimeValues()
    //        }
    //    }
    //
    //    func handleAVPlayerRecreated() {
    //        try? controller.audioSessionController.set(category: .playback)
    //    }
}

extension PlayerContainerView: AVAudioPlayerDelegate {
    
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

extension UIViewController {
    func showTimedAlert(message: String, actionBlock: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                alertController.dismiss(animated: true) {
                    actionBlock?()
                }
            }
            self?.present(alertController, animated: true)
        }
    }
}
