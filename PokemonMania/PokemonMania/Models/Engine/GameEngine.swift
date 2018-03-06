//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit
import PhysicsEngine

protocol GameEngineDelegate: class {
    func getGameArea() -> CGRect
    func getDockArea() -> CGRect
    func getLauncherSize() -> CGFloat
    func getProjectileSize() -> CGFloat
    func getMainView() -> UIView
    func getControlView() -> UIView
    func getGridView() -> UICollectionView
}

class GameEngine {
    private weak var delegate: GameEngineDelegate?
    private var physics: PhysicsEngine
    private var renderer: Renderer
    private var stage: Stage
    private var launcher: Launcher
    private var projectiles: Set<Projectile> = Set()
    private var launchTimer: Timer?

    private lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(stepGameState))
        displayLink.add(to: .current, forMode: .defaultRunLoopMode)
        return displayLink
    }()

    var bubbles: [Position: Bubble] {
        return stage.getBubbles()
    }

    var origin: CGPoint {
        let dockArea = delegate?.getDockArea() ?? CGRect.zero
        return CGPoint(x: dockArea.midX, y: dockArea.midY)
    }

    var projectileSize: CGFloat {
        return delegate?.getProjectileSize() ?? 0
    }

    var parent: UIView? {
        return delegate?.getMainView()
    }

    var grid: UICollectionView? {
        return delegate?.getGridView()
    }

    init?(stage: Stage, delegate: GameEngineDelegate?) {
        guard let viewDelegate = delegate, let launcher = Launcher(using: launcherOptions) else {
            return nil
        }
        self.delegate = viewDelegate
        self.stage = stage
        self.launcher = launcher
        physics = PhysicsEngine(bounds: viewDelegate.getGameArea())
        renderer = Renderer(delegate: viewDelegate)
        setupLauncherGestures(on: parent)
        setupLoadedBubbles()
        displayLink.isPaused = false
    }

    func pauseGame(_ isPaused: Bool) {
        displayLink.isPaused = isPaused
        renderer.togglePauseScreen(isPaused)
    }

    func endGame() {
        displayLink.remove(from: .current, forMode: .defaultRunLoopMode)
    }

    private func addBubble(type: Type, at nearestSlot: Position) {
        stage.insertBubble(type: type, at: nearestSlot)
        if let bubble = bubbles[nearestSlot] {
            renderer.addView(of: bubble, at: nearestSlot)
            findAndScoreMatches(of: bubble, minimumCount: 3)
        }
    }

    private func removeBubble(_ bubble: Bubble, matched: Bool = true) {
        stage.removeBubble(bubble)
        renderer.animateView(of: bubble, isCleaning: !matched) { _ in
            if self.bubbles[bubble.getPosition()] == nil {
                self.renderer.removeView(of: bubble)
            }
        }
    }

    private func setLauncher(pointAt location: CGPoint) {
        let angle = physics.getAngle(of: location, from: origin)
        launcher.direction = angle
    }

    private func updateScore(with bubbles: Set<Bubble>) {
        stage.updateScore(increment: GameSettings.baseScore.rawValue)
    }

    private func updateState(of projectile: Projectile) {
        let points = physics.getPoints(from: projectile.collider).map { point in return getPointInGrid(at: point) }
        if physics.willCollide(projectile, with: getObstacles(near: points)) {
            if let slot = getNearestSlot(to: projectile, using: points) {
                addBubble(type: projectile.type, at: slot)
            }
            renderer.removeView(of: projectile)
            projectiles.remove(projectile)
            return
        } else if let wall = physics.willDeflectWithWall(projectile) {
            physics.deflect(projectile, against: wall)
        }
        physics.move(projectile)
        renderer.redraw(projectile)
    }

    private func findAndScoreMatches(of bubble: Bubble, minimumCount: Int) {
        let matchedBubbles = getBubblesConnected(to: Set([bubble]), with: bubble.getEnergy())
        if matchedBubbles.count >= minimumCount {
            matchedBubbles.forEach { matched in removeBubble(matched) }
            updateScore(with: matchedBubbles)
        }
    }

    private func findAndRemoveDisconnectedBubbles() {
        var rootBubbles = bubbles.filter { position, _ in return position.row == 0 }
        Set(bubbles.values).subtracting(getBubblesConnected(to: Set(rootBubbles.values)))
            .forEach { bubble in removeBubble(bubble, matched: false) }
    }

    private func getBubblesConnected(to rootBubbles: Set<Bubble>, with energy: Type.Energy? = nil) -> Set<Bubble> {
        var neighbours = Queue<Bubble>()
        var group = Set<Bubble>()
        rootBubbles.forEach { rootBubble in neighbours.enqueue(rootBubble) }
        while let bubble = neighbours.dequeue() {
            let isMatch = energy == nil || (energy != nil && bubble.getEnergy() == energy)
            if isMatch, !group.contains(bubble) {
                group.insert(bubble)
                getNeighbours(of: bubble).forEach { neighbour in neighbours.enqueue(neighbour) }
            }
        }
        return group
    }

    private func getNeighbours(of target: Bubble) -> Set<Bubble> {
        let location = target.getPosition()
        let isEvenRow = location.row % 2 == 0
        let neighbours = bubbles.filter { position, _ in
            let rowGap = location.row - position.row
            let columnGap = location.column - position.column
            if rowGap == 0 {
                return columnGap.magnitude == 1
            } else if rowGap.magnitude == 1 {
                return columnGap == 0 || columnGap == (isEvenRow ? 1 : -1)
            }
            return false
        }
        return Set(neighbours.values)
    }

    private func setupLauncherGestures(on delegatedView: UIView?) {
        delegatedView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDelegate)))
        delegatedView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPanDelegate)))
    }

    private func setupLoadedBubbles() {
        bubbles.forEach { position, bubble in renderer.addView(of: bubble, at: position) }
    }

    private func getObstacles(near points: [CGPoint]) -> [CGRect] {
        return points.reduce(into: [CGRect]()) { list, point in
            guard let source = grid, let indexPath = source.indexPathForItem(at: point) else {
                return
            }
            let position = Position(row: indexPath.section, column: indexPath.item)
            if let collider = source.cellForItem(at: indexPath)?.frame, bubbles[position] != nil {
                list.append(source.convert(collider, to: parent))
            }
        }
    }

    private func getNearestSlot(to projectile: Projectile, using coordinates: [CGPoint]) -> Position? {
        var emptySlot: Position? = nil
        var smallestDistance = CGFloat.greatestFiniteMagnitude
        let center = getPointInGrid(at: physics.getCenter(from: projectile.collider))
        coordinates.forEach { location in
            guard let index = grid?.indexPathForItem(at: location), let cell = grid?.cellForItem(at: index) else {
                return
            }
            let slot = Position(row: index.section, column: index.item)
            let distance = physics.getDistance(between: center, and: cell.center)
            if bubbles[slot] == nil, distance < smallestDistance {
                smallestDistance = distance
                emptySlot = slot
            }
        }
        return emptySlot
    }

    private func getPointInGrid(at coordinate: CGPoint) -> CGPoint {
        return parent?.convert(coordinate, to: grid) ?? CGPoint.zero
    }

    @objc
    func launchBubble() {
        if let projectile = launcher.launch(from: origin, diameter: projectileSize, using: physics),
            !displayLink.isPaused {
            projectiles.insert(projectile)
            renderer.animateView(of: launcher)
        }
    }

    @objc
    func stepGameState() {
        renderer.redraw(launcher)
        projectiles.forEach { projectile in updateState(of: projectile) }
        findAndRemoveDisconnectedBubbles()
    }

    @objc
    func didTapDelegate(_ recognizer: UITapGestureRecognizer) {
        setLauncher(pointAt: recognizer.location(in: recognizer.view))
        launchTimer?.invalidate()
        launchTimer = Timer.scheduledTimer(timeInterval: LaunchSettings.rate.rawValue,
                                           target: self,
                                           selector: #selector(self.launchBubble),
                                           userInfo: nil,
                                           repeats: false)
    }

    @objc
    func didPanDelegate(_ recognizer: UIPanGestureRecognizer) {
        setLauncher(pointAt: recognizer.location(in: recognizer.view))
        switch recognizer.state {
        case .began:
            launcher.isAssistEnabled = true
        case .ended:
            launchBubble()
            launcher.isAssistEnabled = false
        default:
            return
        }
    }

}
