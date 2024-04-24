//
//  HesnElmoslemContainerView+TableView.swift
//  MuslimFit
//
//  Created by Karim on 14/07/2023.
//

import Foundation
import UIKit
import Kingfisher

extension HesnElmoslemContainerView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let hesnElmoslem: HesnElmoslemModel = defaultsManager.valueStoreable(key: UserDefaultsKeys.hesnElmoslem) {
//            return hesnElmoslem.data?.count ?? 0
//        }
//        return 0
        return coreDataManager.fetchHesnElmoslem().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(HesnElmoslemTableViewCell.self), for: indexPath) as? HesnElmoslemTableViewCell else {
            return UITableViewCell()
        }
        
        cell.image.image = UIImage(data: coreDataManager.fetchHesnElmoslem()[indexPath.row].header ?? Data())
        
//        if let hesnElmoslem: HesnElmoslemModel = defaultsManager.valueStoreable(key: UserDefaultsKeys.hesnElmoslem) {
//            if let strUrl = "https://denx.suppwhey.net\(hesnElmoslem.data?[indexPath.row].header ?? "")".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
//                  let imgUrl = URL(string: strUrl) {
//
//                cell.image.loadImageWithUrl(imgUrl) // call this line for getting image to yourImageView
//            }
//        }
        
        
        
//        if let url = URL(string: "https://denx.suppwhey.net\(hesnElmoslem[indexPath.row].header ?? "")") {
//            cell.image.kf.indicatorType = .activity
//            cell.image.kf.setImage(with: url)
////            cell.image.load(url: url)
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = HesnElmoslemDetailsViewController()
        vc.hidesBottomBarWhenPushed = true
//        if let hesnElmoslem: HesnElmoslemModel = defaultsManager.valueStoreable(key: UserDefaultsKeys.hesnElmoslem) {
//            vc.header = "https://denx.suppwhey.net\(hesnElmoslem.data?[indexPath.row].header ?? "")"
//    //        vc.body = "https://denx.suppwhey.net\(hesnElmoslem[indexPath.row].body)"
//            vc.body = hesnElmoslem.data?[indexPath.row].body ?? ""
//        }
        
        vc.header = coreDataManager.fetchHesnElmoslem()[indexPath.row
        ].header
        
        vc.body = coreDataManager.fetchHesnElmoslem()[indexPath.row].body
        
        view.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
