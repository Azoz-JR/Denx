//
//  FavouriteContainerView+TableView.swift
//  MuslimFit
//
//  Created by Karim on 16/10/2023.
//

import Foundation
import UIKit
import AVFoundation
import AVKit

extension FavouriteContainerView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

//        return coreDataManager.fetchAdaih().count
        return coreDataManager.fetchQuran().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(QuranPlayerTableViewCell.self), for: indexPath) as? QuranPlayerTableViewCell else {
            return UITableViewCell()
        }
        
        cell.duaaLabel.text = coreDataManager.fetchQuran()[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let player = PlayerViewController()
        player.favouritedQuran = coreDataManager.fetchQuran()
        player.index = indexPath.row
        view.navigationController?.pushViewController(player, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

extension FavouriteContainerView: AVAssetResourceLoaderDelegate {
    
}
