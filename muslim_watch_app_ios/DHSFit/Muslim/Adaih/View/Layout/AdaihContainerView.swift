//
//  AdaihContainerView.swift
//  MuslimFit
//
//  Created by Karim on 14/07/2023.
//

import Foundation
import UIKit
import AVFoundation

class AdaihContainerView: UIView {
    
    var filename = String()
           var playerItem: AVPlayerItem?
    var audioPlayer: AVAudioPlayer?
    
    var adaih = [DuaaData]()
    var player: AVPlayer?
    var selectedRow: Int?
    var view = UIViewController()
    let coreDataManager = CoreDataManager()
    let defaultsManager: UserDefaultsProtocol = UserDefaultsManager()
    
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
    
    lazy var adaihTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(AdaihTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(AdaihTableViewCell.self))
        return tableView
    }()
    
    init(view: UIViewController) {
        self.view = view
        super.init(frame: .zero)
//        self.presenter = presenter
//        super.init()
//        self.clearNavigationButtons()
//        self.title = "Issues types".localize
//        self.backgroundColor = .green
        self.layoutUserInterFace()
    }
    
//    deinit {
//        player?.pause()
//    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layoutUserInterFace() {
        self.addSubViews()
        self.setupBackground()
        self.setupBackBTN()
        setupAdaihTableViewConstraints()
    }

    private func addSubViews() {
        addSubview(background)
        addSubview(backBTN)
        addSubview(self.adaihTableView)
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
    
    private func setupAdaihTableViewConstraints() {
        NSLayoutConstraint.activate([
            self.adaihTableView.topAnchor.constraint(equalTo: backBTN.bottomAnchor, constant: 50),
            self.adaihTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.adaihTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.adaihTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func didTappedBackBTN() {
//        audioPlayer?.pause()
        view.navigationController?.popViewController(animated: true)
    }
    
    func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL)->Void)){
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data.init(contentsOf: url)
                try data.write(to: filePath, options: .atomic)
                print("saved at \(filePath.absoluteString)")
                DispatchQueue.main.async {
                    completion(filePath)
                }
            } catch {
                print("an error happened while downloading or saving the file")
            }
        }
    }
    
    func playAudio(at url: URL) {
        do {
            print(url)
        try AVAudioSession.sharedInstance().setCategory(.playback)
                try AVAudioSession.sharedInstance().setActive(true)
        
//        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play audio:", error.localizedDescription)
        }
    }
    
    func play(url: URL) {
        print("playing \(url)")

        do {

//            let player = AVPlayerItem(

            let playerItem = AVPlayerItem(url: url as URL)

            self.player = try AVPlayer(playerItem:playerItem)
            player!.volume = 1.0
            player!.play()
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
    func pause(url: URL) {
        print("playing \(url)")
        
        do {
            
            try AVAudioSession.sharedInstance().setCategory(.playback)
                    try AVAudioSession.sharedInstance().setActive(true)
            
    //        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
//            self.audioPlayer = try AVPlayer(playerItem:playerItem)
            audioPlayer!.volume = 1.0
            audioPlayer!.pause()
        } catch let error as NSError {
            self.audioPlayer = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
    
//
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

//    func play(url: URL) {
//        print("playing \(url)")
//
//        do {
//
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//            audioPlayer?.prepareToPlay()
//            audioPlayer?.delegate = self
//            audioPlayer?.play()
//            let percentage = (audioPlayer?.currentTime ?? 0)/(audioPlayer?.duration ?? 0)
//            DispatchQueue.main.async {
//                // do what ever you want with that "percentage"
//            }
//
//        } catch let error {
//            audioPlayer = nil
//        }
//
//    }
    
//    func playSound() {
//
//        Bundle.main.url
//
//        guard let url = Bundle.main.url(forResource: "soundName", withExtension: "mp3") else { return }
//
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//            /* iOS 10 and earlier require the following line:
//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
//
//            guard let player = player else { return }
//
//            player.play()
//
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
}

extension AdaihContainerView: AVAudioPlayerDelegate {
    
}

//extension AdaihContainerView: URLSessionDelegate, URLSessionDownloadDelegate {
//    func download(name: String, url: URL) {
//           filename = name
////           let downloadURL = URL(string: url)!
//
//           let config = URLSessionConfiguration.default
//           let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
//           session.downloadTask(with: url).resume()
//       }
//
//
////       var filename = String()
//       func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//           if let data = try? Data(contentsOf: location) {
//
//                   do {
//                       try data.write(to: path(name: filename)!)
//                       play(path: path(name: filename)!)
//                   }
//                   catch {}
//           } else {}
//       }
//
//
//
////       var player: AVPlayer?
////       var playerItem: AVPlayerItem?
//
//       func play(path: URL) {
//           playerItem = AVPlayerItem(url: path)
//           player = AVPlayer(playerItem: playerItem)
//           player?.play()
//       }
//
//
//       func path(name: String) -> URL? {
//           let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//           return path?.appendingPathComponent(name)
//       }
//}
