//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Foundation

// MARK: - AchievementsState

/// A struct representing the state of all achievements, including their current progress.
///
/// Use this type to track and update the progress of various achievements in an app.
///
public struct AchievementsState: Codable, Sendable {

    /// A dictionary mapping each achievement's identifier to its current progress state.
    public internal(set) var progressByID: [AchievementID: AchievementProgress]

    /// Creates a new achievements state initialized with the default progress values
    /// for the provided achievement definitions.
    ///
    /// - Parameter definitions: The definitions used to initialize each achievement's progress.
    ///
    public init(for definitions: [AchievementDefinition]) {
        self.progressByID = Dictionary(
            uniqueKeysWithValues: definitions.map { definition in
                let id = definition.id
                return switch definition.type {
                case .immediate:
                    (id, .locked)
                case .counted(let threshold):
                    (id, .counted(current: 0, threshold: threshold))
                case .progression(let threshold):
                    (id, .progression(current: 0.0, threshold: threshold))
                }
            }
        )
    }

    internal init(progressByID: [AchievementID: AchievementProgress]) {
        self.progressByID = progressByID
    }

    /// Applies another achievements state to the current one, updating progress
    /// values for matching achievement identifiers.
    ///
    /// - Parameter state: The state to apply on top of the current one.
    /// - Returns: A new `AchievementsState` with updated progress values.
    ///
    public func applying(_ state: AchievementsState) -> AchievementsState {
        var progressByID = self.progressByID
        for id in progressByID.keys {
            if let progress = state.progressByID[id] {
                progressByID[id] = progress
            }
        }
        return AchievementsState(progressByID: progressByID)
    }

    /// Returns the progress of the specified achievement.
    ///
    /// - Parameter id: The identifier of the achievement.
    /// - Returns: The progress associated with the achievement.
    /// - Note: This method will crash if the provided ID is not found in the state.
    ///
    public func progress(for id: AchievementID) -> AchievementProgress {
        // We're going to assume that the ID is in the dictionary.
        guard let progress = progressByID[id] else {
            fatalError("Invalid progress ID")
        }
        return progress
    }
}
