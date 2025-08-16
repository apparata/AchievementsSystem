//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Foundation

// MARK: - Achievement

/// An `Achievement` represents a progress-based goal.
///
/// Each achievement has a definition describing what it is, and
/// a closure that updates its progress when new input is provided.
///
/// ### Example
///
/// ```swift
/// let achievement = Achievement<TestInput>(
///     definition: AchievementDefinition(
///         id: .kill10Zombies,
///         title: "Zombie Slayer",
///         description: "Kill 10 zombies.",
///         type: .counted(10),
///         points: 100
///     )
/// ) { input, current in
///     guard case .counted(_, let threshold) = current else {
///         return current
///     }
///     if input.zombiesKilled >= threshold {
///         return .unlocked
///     } else {
///         return .counted(current: input.zombiesKilled, threshold: threshold)
///     }
/// }
/// ```
///
/// - Note: `Achievement` is generic over the type of input used to
///   evaluate progress, allowing flexibility in how progress is tracked.

public struct Achievement<Input: Sendable>: Sendable {

    /// The metadata and static information describing the achievement,
    /// such as its identifier, name, and thresholds.
    public let definition: AchievementDefinition

    /// A closure that computes the new progress of the achievement,
    /// given some input and the current progress.
    ///
    /// - Parameters:
    ///   - input: The new input value used to update progress.
    ///   - current: The current progress state of the achievement.
    /// - Returns: The updated progress for the achievement.
    public let updateProgress: @Sendable (_ input: Input, _ current: AchievementProgress) -> AchievementProgress

    /// Creates a new achievement.
    ///
    /// - Parameters:
    ///   - definition: The static definition of the achievement.
    ///   - evaluator: A closure that updates the achievement's progress
    ///     based on input and current progress.
    public init(
        definition: AchievementDefinition,
        update: @escaping @Sendable (_ input: Input, _ current: AchievementProgress) -> AchievementProgress
    ) {
        self.definition = definition
        self.updateProgress = update
    }
}
