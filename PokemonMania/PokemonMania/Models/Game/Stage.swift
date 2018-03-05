//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

class Stage: Codable {
    private var bubbles: [Position: Bubble]
    var background: Field.Background
    var music: Field.Music
    var effect: Field.Effect
    private var title = ""
    private var date = ""
    private var score = 0

    init() {
        bubbles = [Position: Bubble]()
        background = .standard
        music = .standard
        effect = .none
    }

    init(from stage: Stage) {
        bubbles = stage.getBubbles()
        background = stage.background
        music = stage.music
        effect = stage.effect
    }

    func getBubbles() -> [Position: Bubble] {
        return bubbles
    }

    func insertBubble(type: Type, at position: Position) {
        var bubble: Bubble
        switch type {
        case .energyType(let energy):
            bubble = Bubble(at: position, type: type, energy: energy)
        case .effectType(let effect):
            guard let effectData = effects[effect] else {
                return
            }
            bubble = EffectBubble(at: position, effect: effectData)
        case .obstacleType(let obstacle):
            guard let obstacleData = obstacles[obstacle] else {
                return
            }
            bubble = ObstacleBubble(at: position, obstacle: obstacleData)
        case .creatureType(let creature):
            guard let creatureData = creatures[creature] else {
                return
            }
            bubble = CreatureBubble(at: position, creature: creatureData)
        case .ballType(let ball):
            bubble = CaptureBubble(at: position, ball: ball)
        }
        insertBubble(bubble)
    }

    func insertBubble(_ bubble: Bubble) {
        bubbles[bubble.getPosition()] = bubble
    }

    func removeBubble(_ bubble: Bubble) {
        bubbles[bubble.getPosition()] = nil
    }

    func resetBubbles() {
        bubbles = [:]
    }

    func updateScore(increment: Int) {
        score += increment
    }

    func saveAs(title: String, date: String) {
        self.title = title
        self.date = date
    }

    func getTitle() -> String {
        return title
    }

}
