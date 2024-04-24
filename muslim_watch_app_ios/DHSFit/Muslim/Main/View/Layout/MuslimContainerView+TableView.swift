//
//  MuslimContainerView+TableView.swift
//  MuslimFit
//
//  Created by Karim on 12/07/2023.
//

import Foundation
import UIKit
import AppStructureFeature
import Logging
import NoorFont
import NoorUI

extension MuslimContainerView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 7
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(MuslimTableViewCell.self), for: indexPath) as? MuslimTableViewCell else {
            return UITableViewCell()
        }
//        cell.cellImageView.text = presenter.getHelpDiskIssuesOrders()[indexPath.row]
        if languages.contains(phoneCurLang) {
            cell.cellImageView.image = UIImage(named: "muslim_home_0\(indexPath.row + 1)_\(phoneCurLang)")
        } else {
            cell.cellImageView.image = UIImage(named: "muslim_home_0\(indexPath.row + 1)_ar")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //            if (UserDefaults.standard.value(forKey: "fontFlag") == nil) {
            //                FontName.registerFonts()
            //                LoggingSystem.bootstrap(StreamLogHandler.standardError)
            //                AsyncTextLabelSystem.bootstrap(FixedTextNode.init)
            //            }
                        
                        UserDefaults.standard.set(true, forKey: "fontFlag")
            //            return
            //            FontName.registerFonts()
            //            LoggingSystem.bootstrap(StreamLogHandler.standardError)
            //            AsyncTextLabelSystem.bootstrap(FixedTextNode.init)
            //
            //            // Eagerly load download manager to handle any background downloads.
            //            Task { _ = await downloadManagerContainer.downloadManager() }
            ////
            ////            // Begin fetching resources immediately upon the application's start-up.
            //            Task { await container.readingResources.startLoadingResources() }

            //            Task { @MainActor in
            //                let downloadManager = await downloadManagerContainer.downloadManager()
            //                downloadManager.setBackgroundSessionCompletion(completionHandler)
            //            }
                        
            //            let windowScene =
                        let scene = UIApplication.shared.connectedScenes.first
                        //            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        if let sd = (scene?.delegate as? SceneDelegate) {
            //                sd.blah()
                            sd.window.overrideUserInterfaceStyle = ThemeService.shared.theme.userInterfaceStyle
            //                self.sd = window
                            
            //                let navigation = UINavigationController()
                            
                            let launchBuilder = LaunchBuilder(container: Container.shared)
                            let launchStartup = launchBuilder.launchStartup()
                            launchStartup.launch(from: sd.window)
                            
            //                navigation.viewControllers = [launchStartup]
                            
                            

                            self.launchStartup = launchStartup
                        
            //            let window = UIWindow(windowScene: windowScene)
            //            window.overrideUserInterfaceStyle = ThemeService.shared.theme.userInterfaceStyle
            //            self.window = window

            //            let launchBuilder = LaunchBuilder(container: Container.shared)
            //            let launchStartup = launchBuilder.launchStartup()
            //            launchStartup.launch(from: window)
            //
            //            self.launchStartup = launchStartup
            
            }
            break
        case 1:
            let vc = UIFoCounterController(nibName: "UIFoCounterController", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            view.navigationController?.pushViewController(vc, animated: true)
        case 2:
            DispatchQueue.main.async {
                let vc = HesnElmoslemViewController()
                vc.hidesBottomBarWhenPushed = true
                self.view.navigationController?.pushViewController(vc, animated: true)
            }
        case 3:
//            let vc = CompassViewController()
//            vc.hidesBottomBarWhenPushed = true
//            view.navigationController?.pushViewController(vc, animated: true)
            let vc = UICompassController(nibName: "UICompassController", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            view.navigationController?.pushViewController(vc, animated: true)
        case 4:
//            let vc = PrayersViewController()
//            vc.hidesBottomBarWhenPushed = true
//            view.navigationController?.pushViewController(vc, animated: true)
            let vc = UIQuranAlarmController(nibName: "UIQuranAlarmController", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            view.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = HijriCalendarViewController()
            vc.hidesBottomBarWhenPushed = true
            view.navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = AdaihViewController()
            vc.hidesBottomBarWhenPushed = true
            view.navigationController?.pushViewController(vc, animated: true)
        case 7:
            let vc = QuranPlayerViewController()
            vc.hidesBottomBarWhenPushed = true
            view.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width - 32
        let cellheight = screenWidth * 901/2341
        return cellheight
    }
}
