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
            guard let effectData = globalEffects[effect] else {
                return
            }
            bubble = EffectBubble(at: position, effect: effectData)
        case .obstacleType(let obstacle):
            guard let obstacleData = globalObstacles[obstacle] else {
                return
            }
            bubble = ObstacleBubble(at: position, obstacle: obstacleData)
        case .creatureType(let creature):
            guard let creatureData = globalCreatures[creature] else {
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

    func getScore() -> Int {
        return score
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

    func getBubblesConnected(to target: Bubble) -> Set<Bubble> {
        let energy = target.getEnergy()
        var neighbours = Queue<Bubble>()
        var group = Set<Bubble>()
        neighbours.enqueue(target)
        while let bubble = neighbours.dequeue() {
            if bubble.getEnergy() == energy, !group.contains(bubble) {
                // Handle matching obstacles using a switch-case
                group.insert(bubble)
                getNeighbours(of: bubble).forEach { neighbour in neighbours.enqueue(neighbour) }
            }
        }
        return group
    }

    func getBubblesConnected(to rootBubbles: Set<Bubble>) -> Set<Bubble> {
        var neighbours = Queue<Bubble>()
        var group = Set<Bubble>()
        rootBubbles.forEach { rootBubble in neighbours.enqueue(rootBubble) }
        while let bubble = neighbours.dequeue() {
            if !group.contains(bubble) {
                group.insert(bubble)
                getNeighbours(of: bubble).forEach { neighbour in neighbours.enqueue(neighbour) }
            }
        }
        return group
    }

    func getEffectableNeighbours(of target: Bubble) -> Set<EffectBubble> {
        var effectableBubbles = Set<EffectBubble>()
        getNeighbours(of: target).forEach { bubble in
            if let effectBubble = bubble as? EffectBubble {
                effectableBubbles.insert(effectBubble)
            }
        }
        return effectableBubbles
    }

    func getNeighbours(of target: Bubble, in radius: Int = 1) -> Set<Bubble> {
        if radius == 0 {
            return Set(bubbles.values)
        }
        let location = target.getPosition()
        let isEvenRow = location.row % 2 == 0
        let neighbours = bubbles.filter { position, _ in
            let rowGap = location.row - position.row
            let columnGap = location.column - position.column
            if rowGap == 0 {
                return columnGap.magnitude == 1
            } else if rowGap.magnitude == 1 {
                return columnGap == 0 || columnGap == (isEvenRow ? 1 : -1)
            }
            return false
        }
        if radius == 1 {
            return Set(neighbours.values)
        }
        return neighbours.reduce(into: Set<Bubble>()) { set, entry in
            set = set.union(getNeighbours(of: entry.value, in: radius - 1))
        }
    }

}
