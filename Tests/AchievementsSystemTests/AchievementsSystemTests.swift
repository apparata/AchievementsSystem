import Testing
import AchievementsSystem

struct TestInput: Sendable {
    var zombiesKilled: Int = 0
}

extension AchievementID {
    static let killAtLeastOneZombie = AchievementID("killAtLeastOneZombie")
    static let kill10Zombies = AchievementID("kill10Zombies")
    static let killHalfOf10Zombies = AchievementID("killHalfOf10Zombies")
}

@Test("Immediate achievement unlocks immediately") func testImmediateAchievementUnlocksImmediately() async {
    let achievement = Achievement<TestInput>(
        definition: AchievementDefinition(
            id: .killAtLeastOneZombie,
            title: "Instant Slayer",
            description: "Kill at least one zombie.",
            type: .immediate,
            points: 10
        )
    ) { input, current in
        if input.zombiesKilled > 0 {
            return .unlocked
        } else {
            return .locked
        }
    }

    let manager = await AchievementsSystem(achievements: [achievement])
    let state = await manager.currentProgress()
    #expect(state[.killAtLeastOneZombie]?.isUnlocked == false)
    await manager.updateProgress(input: TestInput(zombiesKilled: 2))
    let unlockedState = await manager.currentProgress()
    #expect(unlockedState[.killAtLeastOneZombie]?.isUnlocked == true)
}

@Test("Counted achievement unlocks after threshold") func exampleTest() async {

    let achievement = Achievement<TestInput>(
        definition: AchievementDefinition(
            id: .kill10Zombies,
            title: "Zombie Slayer",
            description: "Kill 10 zombies.",
            type: .counted(10),
            points: 100
        )
    ) { input, current in
        guard case .counted(_, let threshold) = current else {
            return current
        }
        if input.zombiesKilled >= threshold {
            return .unlocked
        } else {
            return .counted(current: input.zombiesKilled, threshold: threshold)
        }
    }

    let manager = await AchievementsSystem(achievements: [achievement])

    for i in 0...10 {
        let state = await manager.currentProgress()
        #expect(state[.kill10Zombies]?.isUnlocked == false)
        await manager.updateProgress(input: TestInput(zombiesKilled: i))
    }

    let state = await manager.currentProgress()
    #expect(state[.kill10Zombies]?.isUnlocked == true)
}

@Test("Progression achievement unlocks after threshold") func testProgressionAchievementUnlocksAfterThreshold() async {
    let achievement = Achievement<TestInput>(
        definition: AchievementDefinition(
            id: .killHalfOf10Zombies,
            title: "Halfway Zombie Slayer",
            description: "Kill half of 10 zombies.",
            type: .progression(0.5),
            points: 50
        )
    ) { input, current in
        guard case .progression(_, let threshold) = current else {
            return current
        }
        let progress = Double(input.zombiesKilled) / 10.0
        if progress >= threshold {
            return .unlocked
        } else {
            return .progression(current: progress, threshold: threshold)
        }
    }

    let manager = await AchievementsSystem(achievements: [achievement])

    for i in 0...10 {
        await manager.updateProgress(input: TestInput(zombiesKilled: i))
        let state = await manager.currentProgress()
        if i < 5 {
            #expect(state[.killHalfOf10Zombies]?.isUnlocked == false)
        } else {
            #expect(state[.killHalfOf10Zombies]?.isUnlocked == true)
        }
    }
}
