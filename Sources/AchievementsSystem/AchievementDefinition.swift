//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Foundation

// MARK: - AchievementDefinition

public struct AchievementDefinition: Codable, Sendable, Identifiable, Hashable {

    public let id: AchievementID

    public let title: String

    public let description: String

    public let type: AchievementType

    public let points: Int

    public init(
        id: AchievementID,
        title: String,
        description: String,
        type: AchievementType,
        points: Int
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.points = points
    }
}
