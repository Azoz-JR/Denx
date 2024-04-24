//
//  AdaihContainerView+TableView.swift
//  MuslimFit
//
//  Created by Karim on 14/07/2023.
//

import Foundation
import UIKit

extension AdaihContainerView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let adaih: AdaihModel = defaultsManager.valueStoreable(key: UserDefaultsKeys.adaih) {
//            return adaih.data?.count ?? 0
//        }
//        return 0
        return coreDataManager.fetchAdaih().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(AdaihTableViewCell.self), for: indexPath) as? AdaihTableViewCell else {
            return UITableViewCell()
        }
        
//        if var adaih: AdaihModel = self.defaultsManager.valueStoreable(key: UserDefaultsKeys.adaih) {
//            print(adaih)
//            cell.duaaLabel.text = adaih.data?[indexPath.row].title
//
//            if indexPath.row == selectedRow {
//                adaih.data?[indexPath.row].played = true
//            } else {
//                adaih.data?[indexPath.row].played = false
//            }
//
//            if (adaih.data?[indexPath.row].played ?? false) {
//                cell.playPauseImage.image = UIImage(named: "pause")
//            } else {
//                cell.playPauseImage.image = UIImage(named: "play")
//            }
//        }
        
//        print(coreDataManager.fetchAdaih())
        
//        print(coreDataManager.fetchAdaih()[indexPath.row].id)
        
//        if coreDataManager.fetchAdaih()[indexPath.row].id == "\(indexPath.row)" {
            cell.duaaLabel.text = coreDataManager.fetchAdaih()[indexPath.row].title

            if indexPath.row == selectedRow {
                coreDataManager.fetchAdaih()[indexPath.row].played = true
            } else {
                coreDataManager.fetchAdaih()[indexPath.row].played = false
            }

            if coreDataManager.fetchAdaih()[indexPath.row].played {
                cell.playPauseImage.image = UIImage(named: "pause")
            } else {
                cell.playPauseImage.image = UIImage(named: "play")
            }
//        }

        
//        cell.duaaLabel.text = adaih[indexPath.row].title
//
////        if let selectedRow = selectedRow {
//            if indexPath.row == selectedRow {
//                adaih[indexPath.row].played = true
//            } else {
//                adaih[indexPath.row].played = false
//            }
//
//            if adaih[indexPath.row].played ?? false {
//                cell.playPauseImage.image = UIImage(named: "pause")
//            } else {
//                cell.playPauseImage.image = UIImage(named: "play")
//            }
////        } else {
////
////        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as? AdaihTableViewCell
//        if let adaih: AdaihModel = defaultsManager.valueStoreable(key: UserDefaultsKeys.adaih) {
//            guard let url = URL(string: "https://denx.suppwhey.net\(adaih.data?[indexPath.row].url ?? "")") else {
//                return
//            }
//
//            if indexPath.row == selectedRow {
//                selectedRow = nil
//                pause(url: url)
//            } else {
//                selectedRow = indexPath.row
//                play(url: url)
//            }
//    //        adaih[indexPath.row].played = true
//
//            adaihTableView.reloadData()
//        }
        
//        guard let url = URL(string: "https://denx.suppwhey.net\(coreDataManager.fetchAdaih()[indexPath.row].audio ?? Data())") else {
//                return
//            }
        
        guard let url = coreDataManager.fetchAdaih()[indexPath.row].audio else {
            return
        }
            
            if indexPath.row == selectedRow {
                selectedRow = nil
                pause(url: url)
            } else {
                selectedRow = indexPath.row
//                downloadFile(withUrl: url, andFilePath: url) { filePath in
//                    self.play(url: filePath)
//                }
//                play(url: url)
                playAudio(at: url)
            }
    //        adaih[indexPath.row].played = true
            
            adaihTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
