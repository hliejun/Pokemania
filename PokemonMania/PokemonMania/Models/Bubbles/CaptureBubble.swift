//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

class CaptureBubble: Bubble {
    let ball: Type.Ball

    enum CodingKeys: String, CodingKey {
        case ball
    }

    init(at position: Position, ball: Type.Ball) {
        self.ball = ball
        super.init(at: position, type: .ballType(ball))
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ball = try container.decode(Type.Ball.self, forKey: .ball)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try container.encode(ball, forKey: .ball)
    }

    static func == (lhs: CaptureBubble, rhs: CaptureBubble) -> Bool {
        let superLeft: Bubble = lhs
        let superRight: Bubble = rhs
        return lhs.ball == rhs.ball && superLeft == superRight
    }

}
