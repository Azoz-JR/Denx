//
//  HomeTab.swift
//  MuslimFit
//
//  Created by Azoz Salah on 30/04/2024.
//

import AppStructureFeature
import AppDependencies
import HomeFeature
import Localization
import QuranViewFeature
import UIKit

struct HomeTabBuilder: TabBuildable {
    let container: AppDependencies

    func build() -> UIViewController {
        let interactor = HomeTabInteractor(
            quranBuilder: QuranBuilder(container: container),
            homeBuilder: HomeBuilder(container: container)
        )
        let viewController = HomeTabViewController(interactor: interactor)
        viewController.navigationBar.prefersLargeTitles = true
        return viewController
    }
}

private final class HomeTabInteractor: TabInteractor {
    // MARK: Lifecycle

    init(quranBuilder: QuranBuilder, homeBuilder: HomeBuilder) {
        self.homeBuilder = homeBuilder
        super.init(quranBuilder: quranBuilder)
    }

    // MARK: Internal

    override func start() {
        let rootViewController = homeBuilder.build(withListener: self)
        presenter?.setViewControllers([rootViewController], animated: false)
    }

    // MARK: Private

    private let homeBuilder: HomeBuilder
}

private final class HomeTabViewController: TabViewController {
    override func getTabBarItem() -> UITabBarItem {
        UITabBarItem(
            title: "\(lAndroid("quran_sura")) / \(lAndroid("quran_juz2"))",
            image: .symbol("doc.text"),
            selectedImage: .symbol("doc.text.fill")
        )
    }
}
