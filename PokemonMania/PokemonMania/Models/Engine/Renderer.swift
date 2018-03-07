//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class Renderer {
    private weak var delegate: GameEngineDelegate?
    private var projectileViews: [Projectile: ProjectileView]
    private var bubbleViews: [Bubble: GridBubbleView]
    private let pauseView: UIVisualEffectView
    private let bubbleSize: CGSize
    private var launcherView = LauncherView()
    private var launcherStandView = StandView()
    private var bufferView = BufferView()
    private var didSetupLauncher = false

    init(delegate: GameEngineDelegate?) {
        self.delegate = delegate
        projectileViews = [:]
        bubbleViews = [:]
        pauseView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        let diameter = delegate?.getProjectileSize() ?? 0
        bubbleSize = CGSize(width: diameter, height: diameter)
    }

    func getView(of launcher: Launcher) -> LauncherView {
        return launcherView
    }

    func getView(of projectile: Projectile) -> ProjectileView? {
        return projectileViews[projectile]
    }

    func addView(of bubble: Bubble, at position: Position) {
        let index = IndexPath(item: position.column, section: position.row)
        guard let gridPosition = delegate?.getGridView().cellForItem(at: index)?.center else {
            return
        }
        let frame = CGRect(origin: CGPoint.zero, size: bubbleSize)
        let view = GridBubbleView(context: frame)
        let center = delegate?.getGridView().convert(gridPosition, to: delegate?.getMainView())
        view.center = center ?? CGPoint.zero
        view.setStyle(sprite: getAsset(for: bubble))
        if bubbleViews[bubble] != nil {
            removeView(of: bubble)
        }
        bubbleViews[bubble] = view
        updateSubview(view)
    }

    func animateAndRemoveView(of bubble: Bubble, _ isCleaning: Bool) {
        let viewToRemove = bubbleViews[bubble]
        animateView(of: bubble, isCleaning: isCleaning) { _ in
            viewToRemove?.removeFromSuperview()
            if self.bubbleViews[bubble] == viewToRemove {
                self.bubbleViews[bubble] = nil
            }
        }
    }

    func removeView(of projectile: Projectile) {
        projectileViews[projectile]?.removeFromSuperview()
        projectileViews[projectile] = nil
    }

    func removeView(of bubble: Bubble) {
        bubbleViews[bubble]?.overlay?.removeFromSuperview()
        bubbleViews[bubble]?.removeFromSuperview()
        bubbleViews[bubble] = nil
    }

    func redraw(_ launcher: Launcher) {
        if didSetupLauncher, let nextType = launcher.nextInBuffer {
            let angle = CGFloat(launcher.direction * .pi / Quadrant.second.rawValue)
            bufferView.image = bubbleImages[nextType]
            launcherView.transform = CGAffineTransform(rotationAngle: angle)
        }
        if !didSetupLauncher, let dockArea = delegate?.getDockArea(), let size = delegate?.getLauncherSize() {
            setupLauncher(ofSize: size, at: dockArea)
            setupLauncherBase(at: dockArea)
            setupBuffer(ofSize: size * Style.bufferRatio.rawValue)
            didSetupLauncher = true
        }
        updateSubview(bufferView)
        updateSubview(launcherView)
        updateSubview(launcherStandView)
        launcherStandView.superview?.bringSubview(toFront: launcherStandView)
    }

    func redraw(_ projectile: Projectile) {
        let size = projectileViews[projectile]?.frame.size ?? bubbleSize
        let frame = CGRect(origin: projectile.location, size: size)
        let view = projectileViews[projectile] ?? ProjectileView(context: frame)
        view.frame = frame
        if projectileViews[projectile] == nil {
            view.setStyle(sprite: getAsset(for: projectile))
            projectileViews[projectile] = view
        }
        updateSubview(view)
        launcherView.superview?.bringSubview(toFront: launcherView)
    }

    func animateView(of launcher: Launcher) {
        launcherView.stopAnimating()
        launcherView.startAnimating()
    }

    func animateView(of bubble: Bubble, isCleaning: Bool = false, completion: AnimationHandler? = nil) {
        guard let view = bubbleViews[bubble] else {
            return
        }
        let animator = UIViewPropertyAnimator(duration: Animations.duration.rawValue / 2, dampingRatio: 1) {
            let transform = CGAffineTransform(translationX: 0, y: CGFloat(Animations.displacement.rawValue))
            if isCleaning {
                view.alpha = 0
            } else {
                view.backgroundView?.alpha = 0
            }
            view.center = isCleaning ? view.center.applying(transform) : view.center
        }
        if let handler = completion {
            animator.addCompletion(handler)
        }
        animator.startAnimation()
        if !isCleaning {
            view.overlay?.startAnimating()
        }
    }

    func togglePauseScreen(_ isPaused: Bool) {
        if let dashboard = delegate?.getControlView(), isPaused {
            pauseView.frame = delegate?.getMainView().frame ?? CGRect.zero
            pauseView.layer.zPosition = Depth.middle.rawValue
            dashboard.layer.zPosition = Depth.front.rawValue
            updateSubview(pauseView)
            dashboard.superview?.bringSubview(toFront: dashboard)
        } else {
            pauseView.removeFromSuperview()
        }
    }

    private func setupLauncher(ofSize size: CGFloat, at dockArea: CGRect) {
        let launcherRatio = launcherImage.size.width / launcherImage.size.height
        launcherView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size * launcherRatio, height: size))
        launcherView.center = CGPoint(x: dockArea.midX, y: dockArea.midY)
    }

    private func setupLauncherBase(at dockArea: CGRect) {
        let baseRatio = launcherStandImage.size.height / launcherImage.size.width
        let width = launcherView.frame.width
        launcherStandView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: width * baseRatio))
        launcherStandView.center = CGPoint(x: dockArea.midX, y: dockArea.midY)
    }

    private func setupBuffer(ofSize size: CGFloat) {
        bufferView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size))
        bufferView.center = launcherView.center
    }

    private func updateSubview(_ subview: UIView) {
        guard let source = delegate else {
            return
        }
        subview.removeFromSuperview()
        source.getMainView().addSubview(subview)
    }

    private func getAsset(for projectile: Projectile) -> UIImageView? {
        guard let image = bubbleImages[projectile.type] else {
            return nil
        }
        return UIImageView(image: image)
    }

    private func getAsset(for bubble: Bubble) -> UIImageView? {
        guard let image = bubbleImages[bubble.getType()] else {
            return nil
        }
        return UIImageView(image: image)
    }

}
