//
//  QuranBookmarksTab.swift
//  MuslimFit
//
//  Created by Azoz Salah on 30/04/2024.
//

import AppDependencies
import BookmarksFeature
import Localization
import QuranViewFeature
import UIKit

struct BookmarksTabBuilder: TabBuildable {
    let container: AppDependencies

    func build() -> UIViewController {
        let interactor = BookmarksTabInteractor(
            quranBuilder: QuranBuilder(container: container),
            bookmarksBuilder: BookmarksBuilder(container: container)
        )
        let viewController = BookmarksTabViewController(interactor: interactor)
        viewController.navigationBar.prefersLargeTitles = true
        return viewController
    }
}

private final class BookmarksTabInteractor: TabInteractor {
    // MARK: Lifecycle

    init(quranBuilder: QuranBuilder, bookmarksBuilder: BookmarksBuilder) {
        self.bookmarksBuilder = bookmarksBuilder
        super.init(quranBuilder: quranBuilder)
    }

    // MARK: Internal

    override func start() {
        let rootViewController = bookmarksBuilder.build(withListener: self)
        presenter?.setViewControllers([rootViewController], animated: false)
    }

    // MARK: Private

    private let bookmarksBuilder: BookmarksBuilder
}

private class BookmarksTabViewController: TabViewController {
    override func getTabBarItem() -> UITabBarItem {
        UITabBarItem(
            title: lAndroid("menu_bookmarks"),
            image: .symbol("bookmark"),
            selectedImage: .symbol("bookmark.fill")
        )
    }
}
