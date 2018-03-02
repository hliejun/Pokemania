//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

struct Preset: Codable {
    let effects: [Type.Effect: Effect]
    let obstacles: [Type.Obstacle: Obstacle]
    let creatures: [Type.Creature: Creature]

    init(effects: [Type.Effect: Effect], obstacles: [Type.Obstacle: Obstacle], creatures: [Type.Creature: Creature]) {
        self.effects = effects
        self.obstacles = obstacles
        self.creatures = creatures
    }

}
