# AchievementsSystem

A flexible Swift package for managing achievement progress and unlocking logic in iOS and macOS applications.

## Features

- **Generic Input System**: Flexible achievement evaluation based on any input type
- **Multiple Achievement Types**: Support for immediate, counted, and progression-based achievements
- **Thread-Safe**: Built with Swift 6 concurrency in mind using `@MainActor`
- **State Management**: Save, load, and reset achievement progress
- **Type-Safe IDs**: Strongly-typed achievement identifiers
- **Codable Support**: Built-in serialization for persistence

## License

This project is licensed under the BSD Zero Clause License. See [LICENSE](LICENSE) for details.

## Usage

### Basic Setup

```swift
import AchievementsSystem

// Define your input state
struct GameState {
    let zombiesKilled: Int
    let distanceTraveled: Double
    let levelsCompleted: Int
}

// Create achievement definitions
let zombieSlayerAchievement = Achievement<GameState>(
    definition: AchievementDefinition(
        id: .zombieSlayer,
        title: "Zombie Slayer",
        description: "Kill 10 zombies",
        type: .counted(10),
        points: 100
    )
) { gameState, currentProgress in
    guard case .counted(_, let threshold) = currentProgress else {
        return currentProgress
    }
    
    if gameState.zombiesKilled >= threshold {
        return .unlocked
    } else {
        return .counted(current: gameState.zombiesKilled, threshold: threshold)
    }
}

// Initialize the achievements system
let achievementsSystem = AchievementsSystem(achievements: [zombieSlayerAchievement])
```

### Achievement Types

The package supports three types of achievements:

#### Immediate Achievements
For binary unlock conditions:

```swift
.immediate
```

#### Counted Achievements
For integer-based progress tracking:

```swift
.counted(10) // Unlock after reaching count of 10
```

#### Progression Achievements
For floating-point progress tracking:

```swift
.progression(100.0) // Unlock after reaching 100.0
```

### Updating Progress

```swift
let gameState = GameState(
    zombiesKilled: 5,
    distanceTraveled: 1000.0,
    levelsCompleted: 2
)

// Update progress and get newly unlocked achievements
let newlyUnlocked = achievementsSystem.updateProgress(input: gameState)

if !newlyUnlocked.isEmpty {
    print("Congratulations! You unlocked \(newlyUnlocked.count) new achievements!")
}
```

### Querying State

```swift
// Get all current progress
let progress = achievementsSystem.currentProgress()

// Get unlocked achievements
let unlockedAchievements = achievementsSystem.unlockedAchievements()

// Get the complete state for persistence
let state = achievementsSystem.currentState()
```

### State Persistence

```swift
// Save state
let state = achievementsSystem.currentState()
let data = try JSONEncoder().encode(state)
UserDefaults.standard.set(data, forKey: "achievements")

// Load state
if let data = UserDefaults.standard.data(forKey: "achievements"),
   let state = try? JSONDecoder().decode(AchievementsState.self, from: data) {
    achievementsSystem.loadState(state)
}

// Reset all progress
achievementsSystem.reset()
```

## Architecture

### Core Components

- **`AchievementsSystem`**: Main coordinator class that manages all achievements
- **`Achievement`**: Individual achievement with definition and evaluation logic
- **`AchievementDefinition`**: Static metadata describing an achievement
- **`AchievementProgress`**: Current progress state of an achievement
- **`AchievementType`**: Enum defining the type of progress tracking
- **`AchievementID`**: Type-safe identifier for achievements
- **`AchievementsState`**: Container for all achievement progress data

### Concurrency

This package is designed for Swift 6 concurrency:
- The main `AchievementsSystem` class is annotated with `@MainActor`
- All achievement evaluation closures are `@Sendable`
- Strict concurrency checking is enabled
