//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

enum Type: Hashable {

    enum Energy: String, Codable {
        case fire, water, grass, electric, normal, dark,
        ghost, bug, dragon, ice, fighting, flying, ground,
        poison, psychic, rock, steel, none
    }

    enum Effect: String, Codable {
        case copycat, explosion, payday, raindance, sunnyday
    }

    enum Obstacle: String, Codable {
        case grass, land, steel
    }

    enum Creature: String, Codable {
        case bulbasaur, charmander, pikachu, squirtle
    }

    enum Ball: String, Codable {
        case poke, great, ultra, master
    }

    case energyType(Energy)
    case effectType(Effect)
    case obstacleType(Obstacle)
    case creatureType(Creature)
    case ballType(Ball)

    var rawValue: String {
        switch self {
        case .energyType(let energy):
            return energy.rawValue
        case .effectType(let effect):
            return effect.rawValue
        case .obstacleType(let obstacle):
            return obstacle.rawValue
        case .creatureType(let creature):
            return creature.rawValue
        case .ballType(let ball):
            return ball.rawValue
        }
    }

    var hashValue: Int {
        switch self {
        case .energyType(let energy):
            return energy.hashValue
        case .effectType(let effect):
            return effect.hashValue
        case .obstacleType(let obstacle):
            return obstacle.hashValue
        case .creatureType(let creature):
            return creature.hashValue
        case .ballType(let ball):
            return ball.hashValue
        }
    }

    static func == (lhs: Type, rhs: Type) -> Bool {
        switch (lhs, rhs) {
        case let (.energyType(left), .energyType(right)):
            return left == right
        case let (.effectType(left), .effectType(right)):
            return left == right
        case let (.obstacleType(left), .obstacleType(right)):
            return left == right
        case let (.creatureType(left), .creatureType(right)):
            return left == right
        case let (.ballType(left), .ballType(right)):
            return left == right
        default:
            return false
        }
    }

}

extension Type: Codable {

    enum CodingKeys: String, CodingKey {
        case energyType, effectType, obstacleType, creatureType, ballType
    }

    enum CodingError: Error {
        case decoding(String)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let energyType = try? container.decode(String.self, forKey: .energyType),
            let energy = Energy(rawValue: energyType) {
            self = .energyType(energy)
            return
        }
        if let effectType = try? container.decode(String.self, forKey: .effectType),
            let effect = Effect(rawValue: effectType) {
            self = .effectType(effect)
            return
        }
        if let obstacleType = try? container.decode(String.self, forKey: .obstacleType),
            let obstacle = Obstacle(rawValue: obstacleType) {
            self = .obstacleType(obstacle)
            return
        }
        if let creatureType = try? container.decode(String.self, forKey: .creatureType),
            let creature = Creature(rawValue: creatureType) {
            self = .creatureType(creature)
            return
        }
        if let ballType = try? container.decode(String.self, forKey: .ballType),
            let ball = Ball(rawValue: ballType) {
            self = .ballType(ball)
            return
        }
        throw CodingError.decoding("Decoding failed for enum: Type.")
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .energyType(energy):
            try container.encode(energy.rawValue, forKey: .energyType)
        case let .effectType(effect):
            try container.encode(effect.rawValue, forKey: .effectType)
        case let .obstacleType(obstacle):
            try container.encode(obstacle.rawValue, forKey: .obstacleType)
        case let .creatureType(creature):
            try container.encode(creature.rawValue, forKey: .creatureType)
        case let .ballType(ball):
            try container.encode(ball.rawValue, forKey: .ballType)
        }
    }

}
