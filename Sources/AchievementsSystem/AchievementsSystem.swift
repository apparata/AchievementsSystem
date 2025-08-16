//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Foundation

// MARK: - AchievementsSystem

/// A system for managing achievement progress and unlocking logic.
@MainActor public class AchievementsSystem<InputState: Sendable>: Sendable {

    /// Achievement definitions
    private let achievements: [Achievement<InputState>]

    /// The current state, i.e. progress, of the achievements.
    private(set) var state: AchievementsState

    /// Creates a new achievement system with the provided achievements.
    ///
    /// - Parameter achievements: An array of `Achievement` instances that the system manages.
    ///
    public init(achievements: [Achievement<InputState>]) {
        self.achievements = achievements
        self.state = AchievementsState(for: achievements.map(\.definition))
    }

    /// Updates the progress of each achievement based on the provided input.
    ///
    /// - Parameter input: The input used to evaluate and update achievements.
    /// - Returns: A list of achievement IDs that were newly unlocked as a result of the update.
    ///
    @discardableResult
    public func updateProgress(input: InputState) -> [AchievementID] {
        var stateSnapshot = state
        for achievement in achievements {
            guard let current = state.progressByID[achievement.definition.id] else {
                continue
            }
            let updated = achievement.updateProgress(input, current)
            stateSnapshot.progressByID[achievement.definition.id] = updated
        }
        let unlockedBefore = Set(state.progressByID
            .filter { $0.value.isUnlocked }
            .map { $0.key })
        let unlockedAfter = Set(stateSnapshot.progressByID
            .filter { $0.value.isUnlocked }
            .map { $0.key })
        let newlyUnlocked = unlockedAfter.subtracting(unlockedBefore)
        state = stateSnapshot
        return Array(newlyUnlocked)
    }

    /// Returns the current progress of all achievements.
    ///
    /// - Returns: A dictionary mapping achievement IDs to their progress.
    ///
    public func currentProgress() -> [AchievementID: AchievementProgress] {
        return state.progressByID
    }

    /// Returns a list of IDs for achievements that have been unlocked.
    ///
    /// - Returns: An array of unlocked achievement IDs.
    ///
    public func unlockedAchievements() -> [AchievementID] {
        state.progressByID
            .filter { $0.value.isUnlocked }
            .map(\.key)
    }

    /// Returns the internal state of all achievements.
    ///
    /// - Returns: The `AchievementsState` representing current progress and unlocks.
    ///
    public func currentState() -> AchievementsState {
        state
    }

    /// Loads a new achievements state into the system.
    ///
    /// - Parameter newState: The new state to load.
    ///
    public func loadState(_ newState: AchievementsState) {
        self.state = newState
    }

    /// Resets the progress of all achievements to their initial state.
    public func reset() {
        state = AchievementsState(for: achievements.map(\.definition))
    }
}
