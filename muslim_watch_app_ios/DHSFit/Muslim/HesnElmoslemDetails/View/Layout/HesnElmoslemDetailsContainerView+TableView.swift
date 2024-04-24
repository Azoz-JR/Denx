//
//  HEsnElmoslemContainerView+TableView.swift
//  MuslimFit
//
//  Created by Karim on 30/07/2023.
//

import Foundation
import UIKit
import Kingfisher

extension HesnElmoslemDetailsContainerView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return body?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BodyTableViewCell.self), for: indexPath) as? BodyTableViewCell else {
            return UITableViewCell()
        }
        
//        if let url = URL(string: "https://denx.suppwhey.net\(body?[indexPath.row])") {
//            cell.image.kf.indicatorType = .activity
//            cell.image.kf.setImage(with: url)
//            cell.image.load(url: url)
//        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = HesnElmoslemDetailsViewController()
//        vc.hidesBottomBarWhenPushed = true
//        vc.header = "https://denx.suppwhey.net\(hesnElmoslem[indexPath.row].header)"
//        vc.body = "https://denx.suppwhey.net\(hesnElmoslem[indexPath.row].body)"
//        view.navigationController?.pushViewController(vc, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        500
    }
}
