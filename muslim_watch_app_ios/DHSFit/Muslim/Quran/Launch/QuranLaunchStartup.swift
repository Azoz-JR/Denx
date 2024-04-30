//
//  QuranLaunchStartup.swift
//  MuslimFit
//
//  Created by Azoz Salah on 29/04/2024.
//

import AppStructureFeature
import AppMigrationFeature
import AppMigrator
import AudioUpdater
import SettingsService
import UIKit
import Utilities
import VLogging

@MainActor
public final class QuranLaunchStartup {
    // MARK: Lifecycle

    init(
        appBuilder: QuranAppBuilder,
        audioUpdater: AudioUpdater,
        fileSystemMigrator: FileSystemMigrator,
        recitersPathMigrator: RecitersPathMigrator,
        reviewService: ReviewService
    ) {
        self.appBuilder = appBuilder
        self.audioUpdater = audioUpdater
        self.fileSystemMigrator = fileSystemMigrator
        self.recitersPathMigrator = recitersPathMigrator
        self.reviewService = reviewService
    }

    // MARK: Public

    public func launch() -> UIViewController {
        upgradeIfNeeded()
    }

    // MARK: Private

    private let fileSystemMigrator: FileSystemMigrator
    private let recitersPathMigrator: RecitersPathMigrator
    private let appBuilder: QuranAppBuilder
    private let audioUpdater: AudioUpdater
    private let reviewService: ReviewService

    private let appMigrator = AppMigrator()
    private var appViewController: UIViewController?
    
    private var migrationVC: MigrationViewController?
    
    private func upgradeIfNeeded() -> UIViewController {
        registerMigrators()
        switch appMigrator.migrationStatus() {
        case .noMigration:
            return showApp()
        case let .migrate(blocksUI, titles):
            if blocksUI {
                logger.notice("Performing long upgrade task: \(titles)")
                migrationVC = MigrationViewController()
                migrationVC?.setTitles(titles)
//                window.rootViewController = migrationVC
//                window.makeKeyAndVisible()
            }
            Task {
                await appMigrator.migrate()
                return showApp()
            }
        }
        return showApp()
    }

//    private func upgradeIfNeeded(window: UIWindow) {
//        registerMigrators()
//        switch appMigrator.migrationStatus() {
//        case .noMigration:
//            showApp(window: window)
//        case let .migrate(blocksUI, titles):
//            if blocksUI {
//                logger.notice("Performing long upgrade task: \(titles)")
//                let migrationVC = MigrationViewController()
//                migrationVC.setTitles(titles)
//                window.rootViewController = migrationVC
//                window.makeKeyAndVisible()
//            }
//            Task {
//                await appMigrator.migrate()
//                showApp(window: window)
//            }
//        }
//    }
    
    private func showApp() -> UIViewController {
        if self.appViewController != nil {
            return appViewController!
        }

        updateAudioIfNeeded()

        let wasUpdated = migrationVC != nil

        let appViewController = appBuilder.build()
        self.appViewController = appViewController
        
        return appViewController

//        if wasUpdated {
//            appViewController.transition(to: window, duration: 0.3, options: .transitionCrossDissolve)
//        } else {
//            appViewController.launch(from: window)
//            reviewService.checkForReview(in: window)
//        }
    }

//    private func showApp(window: UIWindow) {
//        if self.appViewController != nil {
//            return
//        }
//
//        updateAudioIfNeeded()
//
//        let wasUpdated = window.rootViewController != nil
//
//        let appViewController = appBuilder.build()
//        self.appViewController = appViewController
//
//        if wasUpdated {
//            appViewController.transition(to: window, duration: 0.3, options: .transitionCrossDissolve)
//        } else {
//            appViewController.launch(from: window)
//            reviewService.checkForReview(in: window)
//        }
//    }

    private func registerMigrators() {
        appMigrator.register(migrator: fileSystemMigrator, for: "1.16.0")
        appMigrator.register(migrator: recitersPathMigrator, for: "1.19.1")
    }

    private func updateAudioIfNeeded() {
        // don't run audio updater after upgrading the app
        if case .sameVersion = appMigrator.launchVersion {
            Task {
                await audioUpdater.updateAudioIfNeeded()
            }
        }
    }
}

extension UIViewController {
    func launch(from window: UIWindow) {
        window.rootViewController = self
        window.makeKeyAndVisible()
    }

    func transition(to window: UIWindow, duration: TimeInterval, options: UIView.AnimationOptions) {
        window.switchRootViewController(to: self, duration: duration, options: options)
    }
}
