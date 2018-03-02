//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

enum Field: Hashable {

    enum Effect: String, Codable {
        case gravity, fast, mixed, random, slowmo, none
    }

    enum Background: String, Codable {
        case dark, ghost, normal, standard
    }

    enum Music: String, Codable {
        case gym, center, flute, standard
    }

    case effectType(Effect)
    case backgroundType(Background)
    case musicType(Music)

    var rawValue: String {
        switch self {
        case .effectType(let effect):
            return effect.rawValue
        case .backgroundType(let background):
            return background.rawValue
        case .musicType(let music):
            return music.rawValue
        }
    }

    var hashValue: Int {
        switch self {
        case .effectType(let effect):
            return effect.hashValue
        case .backgroundType(let background):
            return background.hashValue
        case .musicType(let music):
            return music.hashValue
        }
    }

    static func == (lhs: Field, rhs: Field) -> Bool {
        switch (lhs, rhs) {
        case let (.effectType(left), .effectType(right)):
            return left == right
        case let (.backgroundType(left), .backgroundType(right)):
            return left == right
        case let (.musicType(left), .musicType(right)):
            return left == right
        default:
            return false
        }
    }

}

extension Field: Codable {

    enum CodingKeys: String, CodingKey {
        case effectType, backgroundType, musicType
    }

    enum CodingError: Error {
        case decoding(String)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let effectType = try? container.decode(String.self, forKey: .effectType),
            let effect = Effect(rawValue: effectType) {
            self = .effectType(effect)
            return
        }
        if let backgroundType = try? container.decode(String.self, forKey: .backgroundType),
            let background = Background(rawValue: backgroundType) {
            self = .backgroundType(background)
            return
        }
        if let musicType = try? container.decode(String.self, forKey: .musicType),
            let music = Music(rawValue: musicType) {
            self = .musicType(music)
            return
        }
        throw CodingError.decoding("Decoding failed for enum: Field.")
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .effectType(effect):
            try container.encode(effect.rawValue, forKey: .effectType)
        case let .backgroundType(background):
            try container.encode(background.rawValue, forKey: .backgroundType)
        case let .musicType(music):
            try container.encode(music.rawValue, forKey: .musicType)
        }
    }

}
