//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

class EffectBubble: Bubble {
    let effect: Effect

    enum CodingKeys: String, CodingKey {
        case effect
    }

    init(at position: Position, effect: Effect) {
        self.effect = effect
        super.init(at: position, type: .effectType(effect.type), energy: effect.energy)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        effect = try container.decode(Effect.self, forKey: .effect)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try container.encode(effect, forKey: .effect)
    }

    static func == (lhs: EffectBubble, rhs: EffectBubble) -> Bool {
        let superLeft: Bubble = lhs
        let superRight: Bubble = rhs
        return lhs.effect == rhs.effect && superLeft == superRight
    }

}
