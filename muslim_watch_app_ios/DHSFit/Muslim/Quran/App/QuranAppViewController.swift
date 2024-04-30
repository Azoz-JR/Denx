//
//  QuranAppViewController.swift
//  MuslimFit
//
//  Created by Azoz Salah on 30/04/2024.
//

import Analytics
import UIKit
import WhatsNewFeature

protocol QuranAppPresenter: UITabBarController {
}

class QuranAppViewController: UITabBarController, UITabBarControllerDelegate, QuranAppPresenter {
    // MARK: Lifecycle

    init(analytics: AnalyticsLibrary, interactor: QuranAppInteractor) {
        self.interactor = interactor
        whatsNewController = AppWhatsNewController(analytics: analytics)
        super.init(nibName: nil, bundle: nil)
        interactor.presenter = self
        interactor.start()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Open

    override open var shouldAutorotate: Bool {
        visibleViewController?.shouldAutorotate ?? super.shouldAutorotate
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        visibleViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let targetMask = tabBarController.supportedInterfaceOrientations
        if let currentMask = tabBarController.view.window?.windowScene?.interfaceOrientation.asMask {
            if !targetMask.contains(currentMask) {
                if let interface = targetMask.asOrientation {
                    UIDevice.current.setValue(interface.rawValue, forKey: "orientation")
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // show whats new controller if needed
        whatsNewController.presentWhatsNewIfNeeded(from: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: Private

    private let interactor: QuranAppInteractor
    private let whatsNewController: AppWhatsNewController

    private var visibleViewController: UIViewController? {
        presentedViewController ?? selectedViewController
    }
}

private extension UIInterfaceOrientation {
    var asMask: UIInterfaceOrientationMask? {
        switch self {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        default: return nil
        }
    }
}

private extension UIInterfaceOrientationMask {
    var asOrientation: UIInterfaceOrientation? {
        if contains(.portrait) {
            return .portrait
        } else if contains(.landscapeLeft) {
            return .landscapeLeft
        } else if contains(.landscapeRight) {
            return .landscapeRight
        } else if contains(.portraitUpsideDown) {
            return .portraitUpsideDown
        } else {
            return nil
        }
    }
}
