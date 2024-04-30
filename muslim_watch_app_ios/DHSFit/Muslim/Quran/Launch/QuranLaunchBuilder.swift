//
//  QuranLaunchBuilder.swift
//  MuslimFit
//
//  Created by Azoz Salah on 30/04/2024.
//

import AppDependencies
import AppMigrationFeature
import AudioUpdater
import Foundation
import ReciterService
import SettingsService

@MainActor
public struct QuranLaunchBuilder {
    // MARK: Lifecycle

    public init(container: AppDependencies) {
        self.container = container
    }

    // MARK: Public

    public func launchStartup() -> QuranLaunchStartup {
        let audioUpdater = AudioUpdater(baseURL: container.appHost)
        let fileSystemMigrator = FileSystemMigrator(
            databasesURL: container.databasesURL,
            recitersRetreiver: ReciterDataRetriever()
        )
        return QuranLaunchStartup(
            appBuilder: QuranAppBuilder(container: container),
            audioUpdater: audioUpdater,
            fileSystemMigrator: fileSystemMigrator,
            recitersPathMigrator: RecitersPathMigrator(),
            reviewService: ReviewService(analytics: container.analytics)
        )
    }

    // MARK: Internal

    let container: AppDependencies
}
