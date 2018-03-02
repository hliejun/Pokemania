//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

class CreatureBubble: Bubble {
    let creature: Creature

    enum CodingKeys: String, CodingKey {
        case creature
    }

    init(at position: Position, creature: Creature) {
        self.creature = creature
        super.init(at: position, type: .creatureType(creature.type), energy: creature.energy)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        creature = try container.decode(Creature.self, forKey: .creature)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try container.encode(creature, forKey: .creature)
    }

    static func == (lhs: CreatureBubble, rhs: CreatureBubble) -> Bool {
        let superLeft: Bubble = lhs
        let superRight: Bubble = rhs
        return lhs.creature == rhs.creature && superLeft == superRight
    }

}
