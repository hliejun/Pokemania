//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

class ObstacleBubble: Bubble {
    let obstacle: Obstacle

    enum CodingKeys: String, CodingKey {
        case obstacle
    }

    init(at position: Position, obstacle: Obstacle) {
        self.obstacle = obstacle
        super.init(at: position, type: .obstacleType(obstacle.type))
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        obstacle = try container.decode(Obstacle.self, forKey: .obstacle)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try container.encode(obstacle, forKey: .obstacle)
    }

    static func == (lhs: ObstacleBubble, rhs: ObstacleBubble) -> Bool {
        let superLeft: Bubble = lhs
        let superRight: Bubble = rhs
        return lhs.obstacle == rhs.obstacle && superLeft == superRight
    }

}
