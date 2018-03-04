//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import Foundation

class LevelDesigner {
    private var level: Stage
    private var savedLevels: [String: Stage]
    private var savedPresets: Preset

    var effects: [Type.Effect: Effect] {
        return savedPresets.effects
    }

    var obstacles: [Type.Obstacle: Obstacle] {
        return savedPresets.obstacles
    }

    var creatures: [Type.Creature: Creature] {
        return savedPresets.creatures
    }

    var bubbles: [Position: Bubble] {
        return level.getBubbles()
    }

    var levels: [String] {
        return Array(savedLevels.keys).sorted()
    }

    init() {
        LevelDesigner.savePresets()
        guard let presets = LevelDesigner.loadPresets() else {
            fatalError("Fatal: Presets cannot be loaded.")
        }
        savedPresets = presets
        savedLevels = LevelDesigner.loadLevels()
        level = Stage()
    }

    func getStage() -> Stage {
        return level
    }

    func getCopyOfStage() -> Stage {
        return Stage(from: level)
    }

    func getBubbleType(at position: Position) -> Type? {
        return level.getBubbles()[position]?.getType()
    }

    func insertBubble(at position: Position, ofType type: Type) {
        switch type {
        case .energyType(let energyType):
            level.insertBubble(Bubble(at: position, type: type, energy: energyType))
        case .effectType(let effectType):
            if let effect = effects[effectType] {
                level.insertBubble(EffectBubble(at: position, effect: effect))
            }
        case .obstacleType(let obstacleType):
            if let obstacle = obstacles[obstacleType] {
                level.insertBubble(ObstacleBubble(at: position, obstacle: obstacle))
            }
        case .creatureType(let creatureType):
            if let creature = creatures[creatureType] {
                level.insertBubble(CreatureBubble(at: position, creature: creature))
            }
        case .ballType(let ballType):
            level.insertBubble(CaptureBubble(at: position, ball: ballType))
        }
    }

    func removeBubble(at position: Position) {
        level.removeBubble(Bubble(at: position))
    }

    func resetDesign() {
        level.resetBubbles()
    }

    func setFieldEffect(ofType type: Field.Effect) {
        level.effect = type
    }

    func setBackground(ofType type: Field.Background) {
        level.background = type
    }

    func setMusic(ofType type: Field.Music) {
        level.music = type
    }

    func isValidDesign() -> Bool {
        // Implement validation (check no disconnected graph)
        return true
    }

    func saveLevel(ofTitle title: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YY HH:mm"
        let date = formatter.string(from: Date(timeIntervalSinceNow: 0))
        level.saveAs(title: title, date: date)
        savedLevels[title] = level
        Storage.write(savedLevels, to: .levels)
        savedLevels = LevelDesigner.loadLevels()
    }

    func loadLevel(ofTitle title: String) {
        guard let loadedLevel = savedLevels[title] else {
            fatalError("Fatal: Saved level cannot be loaded.")
        }
        level = Stage(from: loadedLevel)
    }

    func deleteLevel(ofTitle title: String) {
        savedLevels[title] = nil
        Storage.write(savedLevels, to: .levels)
        savedLevels = LevelDesigner.loadLevels()
    }

    static func savePresets() {
        let effects: [Type.Effect: Effect] = [
            .sunny: Effect(type: .sunny, targets: Set([.fire, .grass]),
                           radius: 0,
                           multiplier: 2.0,
                           energy: .fire)
        ]

        let obstacles: [Type.Obstacle: Obstacle] = [
            .steel: Obstacle(type: .steel, weaknesses: Set([.ice, .fire]),
                             tolerance: 3)
        ]

        let creatures: [Type.Creature: Creature] = [
            .pikachu: Creature(type: .pikachu, energy: .electric, rarity: 0.2, isShiny: true)
        ]

        let preset = Preset(effects: effects, obstacles: obstacles, creatures: creatures)
        Storage.write(preset, to: .presets)
    }

    static func loadPresets() -> Preset? {
        return Storage.read(.presets, as: Preset.self)
    }

    static func loadLevels() -> [String: Stage] {
        return Storage.read(.levels, as: [String: Stage].self) ?? [:]
    }

}
