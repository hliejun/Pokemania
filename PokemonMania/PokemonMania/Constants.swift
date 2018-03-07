//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

typealias AnimationHandler = (UIViewAnimatingPosition) -> Void

enum Formats: String {
    case date = "dd/MM/YY HH:mm"
}

enum GameSettings: Int {
    case baseScore = 10
}

enum DisplaySettings: Int {
    case maxColumns = 12
    case maxRows = 14
}

enum Depth: CGFloat {
    case back = 100
    case middle = 200
    case front = 300
}

enum Style: CGFloat {
    case bufferRatio = 0.25
    case paddingToInsetRatio = 0.2
    case largeMargin = 24
    case largeInset = 20
}

enum Animations: Double {
    case displacement = 100
    case duration = 0.6
}

enum LaunchSettings: Double {
    case angleLimit = 10
    case rate = 0.15
    case strength = 0.02
}

enum Quadrant: Double {
    case first = 90
    case second = 180
    case third = 270
    case fourth = 0
}

let launcherStandImage = #imageLiteral(resourceName: "cannon-base")

let launcherImage = #imageLiteral(resourceName: "cannon-0")

let launcherImages = [#imageLiteral(resourceName: "cannon-1"), #imageLiteral(resourceName: "cannon-2"), #imageLiteral(resourceName: "cannon-3"), #imageLiteral(resourceName: "cannon-4"), #imageLiteral(resourceName: "cannon-5"), #imageLiteral(resourceName: "cannon-6"), #imageLiteral(resourceName: "cannon-7"), #imageLiteral(resourceName: "cannon-8"), #imageLiteral(resourceName: "cannon-9"), #imageLiteral(resourceName: "cannon-10"), #imageLiteral(resourceName: "cannon-11"), #imageLiteral(resourceName: "cannon-0")]

let bubbleBurstImages = [#imageLiteral(resourceName: "bubble-burst-1"), #imageLiteral(resourceName: "bubble-burst-2"), #imageLiteral(resourceName: "bubble-burst-3"), #imageLiteral(resourceName: "bubble-burst-4")]

let bubbleImages: [Type: UIImage] = [
    .energyType(.fire): #imageLiteral(resourceName: "bubble-fire"),
    .energyType(.water): #imageLiteral(resourceName: "bubble-water"),
    .energyType(.grass): #imageLiteral(resourceName: "bubble-grass"),
    .energyType(.electric): #imageLiteral(resourceName: "bubble-electric"),
    .energyType(.normal): #imageLiteral(resourceName: "bubble-normal"),
    .energyType(.dark): #imageLiteral(resourceName: "bubble-dark"),
    .energyType(.ghost): #imageLiteral(resourceName: "bubble-ghost"),
    .energyType(.bug): #imageLiteral(resourceName: "bubble-bug"),
    .energyType(.dragon): #imageLiteral(resourceName: "bubble-dragon"),
    .energyType(.ice): #imageLiteral(resourceName: "bubble-ice"),
    .energyType(.fighting): #imageLiteral(resourceName: "bubble-fighting"),
    .energyType(.flying): #imageLiteral(resourceName: "bubble-flying"),
    .energyType(.ground): #imageLiteral(resourceName: "bubble-ground"),
    .energyType(.poison): #imageLiteral(resourceName: "bubble-poison"),
    .energyType(.psychic): #imageLiteral(resourceName: "bubble-psychic"),
    .energyType(.rock): #imageLiteral(resourceName: "bubble-rock"),
    .energyType(.steel): #imageLiteral(resourceName: "bubble-steel"),
    .effectType(.explosion): #imageLiteral(resourceName: "bubble-bomb"),
    .effectType(.copycat): #imageLiteral(resourceName: "bubble-star"),
    .effectType(.thunderbolt): #imageLiteral(resourceName: "bubble-lightning"),
    .effectType(.raindance): #imageLiteral(resourceName: "raindance"),
    .effectType(.sunnyday): #imageLiteral(resourceName: "sunnyday"),
    .effectType(.payday): #imageLiteral(resourceName: "payday")
]

let globalLauncherActions = Set<Type>([
    .energyType(.fire),
    .energyType(.water),
    .energyType(.grass),
    .energyType(.electric)
])

let globalIndestructibles = Set<Type.Obstacle>([.magnet, .steelwall])

let globalEffects: [Type.Effect: Effect] = [
    .copycat: Effect(type: .copycat, targets: Set([]), radius: 0, multiplier: 1.5, energy: .none),
    .explosion: Effect(type: .explosion, targets: Set([]), radius: 1, multiplier: 1.5, energy: .none),
    .payday: Effect(type: .payday, targets: Set([]), radius: 0, multiplier: 5.0, energy: .none),
    .raindance: Effect(type: .raindance, targets: Set([.water]), radius: 0, multiplier: 1.5, energy: .water),
    .sunnyday: Effect(type: .sunnyday, targets: Set([.fire, .grass]), radius: 0, multiplier: 1.5, energy: .fire),
    .thunderbolt: Effect(type: .thunderbolt, targets: Set([]), radius: 0, multiplier: 1.5, energy: .electric)
]

let globalObstacles: [Type.Obstacle: Obstacle] = [
    .steelwall: Obstacle(type: .steelwall, weaknesses: Set(), tolerance: 0),
    .magnet: Obstacle(type: .magnet, weaknesses: Set(), tolerance: 0),
    .tree: Obstacle(type: .tree, weaknesses: Set([.fire]), tolerance: 3)
]

let globalCreatures: [Type.Creature: Creature] = [
    .pikachu: Creature(type: .pikachu, energy: .electric, rarity: 0.01, isShiny: false),
    .bulbasaur: Creature(type: .bulbasaur, energy: .grass, rarity: 0.05, isShiny: false),
    .charmander: Creature(type: .charmander, energy: .fire, rarity: 0.03, isShiny: false),
    .squirtle: Creature(type: .squirtle, energy: .water, rarity: 0.04, isShiny: false)
]

let globalTemplateBubbles = [
    Bubble(at: Position(row: 0, column: 4), energy: .electric),
    Bubble(at: Position(row: 0, column: 5), energy: .water),
    Bubble(at: Position(row: 0, column: 6), energy: .grass),
    Bubble(at: Position(row: 0, column: 7), energy: .fire),
    Bubble(at: Position(row: 1, column: 4), energy: .electric),
    Bubble(at: Position(row: 1, column: 5), energy: .water),
    Bubble(at: Position(row: 1, column: 6), energy: .grass),
    Bubble(at: Position(row: 2, column: 5), energy: .fire),
    Bubble(at: Position(row: 2, column: 6), energy: .fire)
]
