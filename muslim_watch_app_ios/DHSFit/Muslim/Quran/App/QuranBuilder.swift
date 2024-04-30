//
//  QuranBuilder.swift
//  MuslimFit
//
//  Created by Azoz Salah on 29/04/2024.
//

import AppStructureFeature
import AppDependencies
import UIKit

@MainActor
struct QuranAppBuilder {
    let container: AppDependencies

    func build() -> UIViewController {
        let interactor = QuranAppInteractor(
            supportsCloudKit: container.supportsCloudKit,
            analytics: container.analytics,
            lastPagePersistence: container.lastPagePersistence,
            tabs: [
                HomeTabBuilder(container: container),
                NotesTabBuilder(container: container),
                BookmarksTabBuilder(container: container),
                SearchTabBuilder(container: container),
                SettingsTabBuilder(container: container),
            ]
        )
        let viewController = QuranAppViewController(
            analytics: container.analytics,
            interactor: interactor
        )
        return viewController
    }
}
