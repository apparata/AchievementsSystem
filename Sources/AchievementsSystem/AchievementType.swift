//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Foundation

// MARK: - Achievement Type

/// Represents the type of progress tracking used for an achievement.
///
/// - immediate: The achievement is either locked or unlocked, with no partial progress.
/// - counted: Progress is tracked as an integer count toward a threshold.
/// - progression: Progress is tracked as a floating-point ratio toward a threshold.
///
public enum AchievementType: Hashable, Equatable, Sendable {

    /// The achievement is either locked or unlocked, with no partial progress.
    case immediate

    /// Progress is tracked as an integer count toward a threshold.
    ///
    /// - Parameter threshold: The integer count required to unlock the achievement.
    ///
    case counted(Int)

    /// Progress is tracked as a floating-point ratio toward a threshold.
    ///
    /// - Parameter threshold: The floating-point value required to unlock the achievement.
    /// 
    case progression(Double)
}

// MARK: - Codable Conformance

extension AchievementType: Codable {

    private enum CodingKeys: String, CodingKey {
        case type
        case thresholdInt
        case thresholdDouble
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case "immediate":
            self = .immediate
        case "counted":
            let threshold = try container.decode(Int.self, forKey: .thresholdInt)
            self = .counted(threshold)
        case "progression":
            let threshold = try container.decode(Double.self, forKey: .thresholdDouble)
            self = .progression(threshold)
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unknown AchievementType type: \(type)"
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .immediate:
            try container.encode("immediate", forKey: .type)
        case .counted(let threshold):
            try container.encode("counted", forKey: .type)
            try container.encode(threshold, forKey: .thresholdInt)
        case .progression(let threshold):
            try container.encode("progression", forKey: .type)
            try container.encode(threshold, forKey: .thresholdDouble)
        }
    }
}
