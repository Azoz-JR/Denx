//
//  QuranPlayerContainerView+TableView.swift
//  MuslimFit
//
//  Created by Karim on 26/09/2023.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

extension QuranPlayerContainerView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

//        return coreDataManager.fetchAdaih().count
        return quran.count
//        return adaih.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(QuranPlayerTableViewCell.self), for: indexPath) as? QuranPlayerTableViewCell else {
            return UITableViewCell()
        }
        
//        cell.duaaLabel.text = adaih[indexPath.row].title
        cell.duaaLabel.text = quran[indexPath.row].name
        
        cell.onTapFavouriteBTN = { [weak self] in
            guard let self = self else { return }
            
//            if quran[indexPath.row].favourite ?? false {
//            if quran[indexPath.row].favourite ?? false {
//                quran[indexPath.row].favourite = false
//                coreDataManager.clearQuranLog(at: "\(quran[indexPath.row].id ?? 0)")
//            } else {
//                quran[indexPath.row].favourite = true
//                coreDataManager.saveQuran(id: "\(quran[indexPath.row].id ?? 0)", audio: quran[indexPath.row].audio ?? "", name: quran[indexPath.row].name ?? "")
//            }
            
//            if fetchedQuran.contains(quran[indexPath.row].id) {
//                
//            }
            
//            fetch
            
            if fetchedQuranIds.contains("\(quran[indexPath.row].id ?? 0)") {
                coreDataManager.clearQuranLog(at: "\(quran[indexPath.row].id ?? 0)")
            } else {
                coreDataManager.saveQuran(id: "\(quran[indexPath.row].id ?? 0)", audio: quran[indexPath.row].audio ?? "", name: quran[indexPath.row].name ?? "")
            }
            
//            if fetchedQuran.isEmpty {
//                coreDataManager.saveQuran(id: "\(quran[indexPath.row].id ?? 0)", audio: quran[indexPath.row].audio ?? "", name: quran[indexPath.row].name ?? "")
//            } else {
//                for i in fetchedQuran {
//                if "\(quran[indexPath.row].id ?? 0)" == i.id {
//                        coreDataManager.clearQuranLog(at: "\(quran[indexPath.row].id ?? 0)")
//                    break
//                    } else {
//                        coreDataManager.saveQuran(id: "\(quran[indexPath.row].id ?? 0)", audio: quran[indexPath.row].audio ?? "", name: quran[indexPath.row].name ?? "")
//    //                    break
//                    }
//                }
//            }
            
            
//            DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(5)) {
//                self.fetchedQuran = self.coreDataManager.fetchQuran()
//            }
            
//            self.quran[indexPath.row].favourite = !(self.quran[indexPath.row].favourite ?? false)
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)){
//                self.quranPlayerTableView.reloadData()
//            }
        }
        
//        if coreDataManager.fetchQuran().isEmpty {
        if fetchedQuran.isEmpty {
            cell.favouriteBTN.setImage(UIImage(named: "unfavourited"), for: .normal)
        } else {
//            for i in coreDataManager.fetchQuran() {
            for i in fetchedQuran {
                if i.id == "\(quran[indexPath.row].id ?? 0)" {
                    print(i.id)
                    DispatchQueue.main.async {
                        cell.favouriteBTN.setImage(UIImage(named: "favourited"), for: .normal)
                    }
                    
                } else {
                    cell.favouriteBTN.setImage(UIImage(named: "unfavourited"), for: .normal)
                }
            }
        }
        
//        if quran[indexPath.row].favourite ?? false {
//            cell.favouriteBTN.setImage(UIImage(named: "favourited"), for: .normal)
//        } else {
//            cell.favouriteBTN.setImage(UIImage(named: "unfavourited"), for: .normal)
//        }
//            cell.duaaLabel.text = coreDataManager.fetchAdaih()[indexPath.row].title
//
//            if indexPath.row == selectedRow {
//                coreDataManager.fetchAdaih()[indexPath.row].played = true
//            } else {
//                coreDataManager.fetchAdaih()[indexPath.row].played = false
//            }
//
//            if coreDataManager.fetchAdaih()[indexPath.row].played {
//                cell.playPauseImage.image = UIImage(named: "pause")
//            } else {
//                cell.playPauseImage.image = UIImage(named: "play")
//            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let url = URL(string: "https://denx.suppwhey.net/public/assets/doaa_audios/1.mp3")!
//
//                // Create the asset instance and the resouce loader because we will be asked
//                // for the license to playback DRM protected asset.
//                let asset = AVURLAsset(url: url)
//                let queue = DispatchQueue(label: "FP License Acquire")
//                asset.resourceLoader.setDelegate(self, queue: queue)
//
//                // Create the player item and the player to play it back in.
//                let playerItem = AVPlayerItem(asset: asset)
//                let player = AVPlayer(playerItem: playerItem)
//
//                // Create a new AVPlayerViewController and pass it a reference to the player.
////        var audioPlayer: AVAudioPlayer?
//                let controller = AVPlayerViewController()
//                controller.player = player
//
//                // Modally present the player and call the player's play() method when complete.
//        view.present(controller, animated: true) {
//                    player.play()
//                }
        
//        guard let url = URL(string: "https://denx.suppwhey.net/public/assets/doaa_audios/1.mp3") else { return }
////        let videoURL = video.url
//        let player = AVPlayer(url: url)
//
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//
//        view.present(playerViewController, animated: true) {
//          player.play()
//        }
        
        let player = PlayerViewController()
//        view.present(player, animated: true)
//        player.
//        player.adaih = adaih
        player.quran = quran
        player.index = indexPath.row
        view.navigationController?.pushViewController(player, animated: true)
        
//        guard let url = coreDataManager.fetchAdaih()[indexPath.row].audio else {
//            return
//        }
//
//            if indexPath.row == selectedRow {
//                selectedRow = nil
//                pause(url: url)
//            } else {
//                selectedRow = indexPath.row
//
//                playAudio(at: url)
//            }
//
//            adaihTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

extension QuranPlayerContainerView: AVAssetResourceLoaderDelegate {
    
}
