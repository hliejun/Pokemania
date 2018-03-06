//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

struct Obstacle: Codable {
    let type: Type.Obstacle
    let weaknesses: Set<Type.Energy>
    let tolerance: Int

    init(type: Type.Obstacle, weaknesses: Set<Type.Energy> = Set<Type.Energy>(), tolerance: Int = 1) {
        self.type = type
        self.weaknesses = weaknesses
        self.tolerance = tolerance
    }

}

extension Obstacle: Hashable {

    var hashValue: Int {
        return type.hashValue
    }

    static func == (lhs: Obstacle, rhs: Obstacle) -> Bool {
        return lhs.weaknesses.isSubset(of: rhs.weaknesses)
            && rhs.weaknesses.isSubset(of: rhs.weaknesses)
            && lhs.type == rhs.type
            && lhs.tolerance == rhs.tolerance
    }

}
