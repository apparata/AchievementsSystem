//
//  Copyright © 2025 Apparata AB. All rights reserved.
//

import Foundation

// MARK: - AchievementID

/// A unique identifier that identifies an achievement within the system.
public struct AchievementID: Identifiable, Hashable, Equatable, Sendable, CustomStringConvertible, Codable
{
    /// Returns the identifier string used to conform to `Identifiable`.
    public var id: String { value }
    
    /// Returns a textual description of the achievement ID (the same as the underlying value).
    public var description: String { value }
    
    /// The raw string backing the achievement ID.
    public let value: String
    
    /// Creates a new `AchievementID` with the given string value.
    public init(_ value: String) {
        self.value = value
    }
}
