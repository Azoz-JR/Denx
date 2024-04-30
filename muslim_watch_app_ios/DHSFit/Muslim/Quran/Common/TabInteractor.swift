//
//  TabInteractor.swift
//  MuslimFit
//
//  Created by Azoz Salah on 30/04/2024.
//

import FeaturesSupport
import QuranContentFeature
import QuranKit
import QuranViewFeature
import UIKit

protocol TabPresenter: UINavigationController {
}

class TabInteractor: QuranNavigator {
    // MARK: Lifecycle

    init(quranBuilder: QuranBuilder) {
        self.quranBuilder = quranBuilder
    }

    // MARK: Internal

    weak var presenter: TabPresenter?

    func navigateTo(page: Page, lastPage: Page?, highlightingSearchAyah: AyahNumber?) {
        let input = QuranInput(initialPage: page, lastPage: lastPage, highlightingSearchAyah: highlightingSearchAyah)
        let viewController = quranBuilder.build(input: input)
        presenter?.pushViewController(viewController, animated: true)
    }

    func start() {
    }

    // MARK: Private

    private let quranBuilder: QuranBuilder
}
