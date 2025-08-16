//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Foundation

// MARK: - AchievementProgress

/// Represents the progress state of an achievement.
///
/// Progress can be expressed in one of several ways:
/// - `locked`: The achievement has not yet started.
/// - `unlocked`: The achievement has been fully completed.
/// - `counted`: Progress measured by an integer count toward a threshold.
/// - `progression`: Progress measured by a floating-point value toward a threshold.
///
/// This enum provides flexibility to represent both discrete and continuous
/// progress tracking for achievements.
///
public enum AchievementProgress: Codable, Sendable, Equatable {

    /// The achievement has not yet started.
    case locked

    /// The achievement has been fully completed.
    case unlocked

    /// Progress measured by an integer count toward a threshold.
    case counted(current: Int, threshold: Int)

    /// Progress measured by a floating-point value toward a threshold.
    case progression(current: Double, threshold: Double)

    /// A Boolean value indicating whether the achievement has been unlocked.
    ///
    /// - Returns: `true` if the achievement is in the `.unlocked` state,
    ///   or if its `counted`/`progression` progress has reached
    ///   or exceeded the threshold. Otherwise, `false`.
    ///
    public var isUnlocked: Bool {
        switch self {
        case .unlocked:
            return true
        case .counted(let current, let threshold):
            return current >= threshold
        case .progression(let current, let threshold):
            return current >= threshold
        default:
            return false
        }
    }

    /// A Boolean value indicating whether the achievement has not yet been unlocked.
    ///
    /// - Returns: `true` if the achievement is in the `.locked` state,
    ///   or if its `counted`/`progression` progress has not reached
    ///   the threshold. Otherwise, `false`.
    ///
    public var isLocked: Bool {
        switch self {
        case .locked:
            return true
        case .counted(let current, let threshold):
            return current < threshold
        case .progression(let current, let threshold):
            return current < threshold
        default:
            return false
        }
    }
}
