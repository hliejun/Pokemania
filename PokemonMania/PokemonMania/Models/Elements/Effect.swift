//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

struct Effect: Codable {
    let type: Type.Effect
    let targets: Set<Type.Energy>
    let radius: Int
    let multiplier: Double
    let energy: Type.Energy

    init(type: Type.Effect, targets: Set<Type.Energy> = Set<Type.Energy>(),
         radius: Int = 0, multiplier: Double = 1, energy: Type.Energy) {
        self.targets = targets
        self.radius = radius
        self.multiplier = multiplier
        self.type = type
        self.energy = energy
    }

}

extension Effect: Hashable {

    var hashValue: Int {
        return type.hashValue ^ targets.hashValue ^ radius.hashValue ^ multiplier.hashValue ^ energy.hashValue
    }

    static func == (lhs: Effect, rhs: Effect) -> Bool {
        return lhs.type == rhs.type
            && lhs.targets.isSubset(of: rhs.targets)
            && rhs.targets.isSubset(of: rhs.targets)
            && lhs.radius == rhs.radius
            && lhs.multiplier == rhs.multiplier
            && lhs.energy == rhs.energy
    }

}
