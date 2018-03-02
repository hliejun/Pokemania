//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

struct Creature: Codable {
    let type: Type.Creature
    let energy: Type.Energy
    let rarity: Double
    let isShiny: Bool

    init(type: Type.Creature, energy: Type.Energy, rarity: Double, isShiny: Bool = false) {
        self.type = type
        self.energy = energy
        self.rarity = rarity
        self.isShiny = isShiny
    }

}

extension Creature: Hashable {

    var hashValue: Int {
        return type.rawValue.hashValue
    }

    static func == (lhs: Creature, rhs: Creature) -> Bool {
        return lhs.type == rhs.type
            && lhs.energy == rhs.energy
            && lhs.rarity == rhs.rarity
            && lhs.isShiny == rhs.isShiny
    }

}
