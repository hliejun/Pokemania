//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class Renderer {
    private weak var delegate: GameEngineDelegate?
    private let projectileSize: CGSize
    private var projectileViews: [Projectile: ProjectileView]
    private var launcherView: LauncherView
    private var bufferView: UIImageView

    init(delegate: GameEngineDelegate?) {
        self.delegate = delegate
        launcherView = LauncherView()
        bufferView = UIImageView()
        projectileViews = [:]
        let diameter: CGFloat = delegate?.getProjectileSize() ?? 0
        projectileSize = CGSize(width: diameter, height: diameter)
    }

    func getView(of launcher: Launcher) -> LauncherView {
        return launcherView
    }

    func getView(of projectile: Projectile) -> ProjectileView? {
        return projectileViews[projectile]
    }

    func removeView(of projectile: Projectile) {
        projectileViews[projectile]?.removeFromSuperview()
        projectileViews[projectile] = nil
    }

    func redraw(_ launcher: Launcher) {
        if launcherView.image != nil {
            if let nextType = launcher.nextInBuffer {
                bufferView.image = assets[nextType]
                launcherView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
            launcherView.transform = CGAffineTransform(rotationAngle: CGFloat(launcher.direction * .pi / 180.0))
        } else if let dockArea = delegate?.getDockArea(), let size = delegate?.getLauncherSize() {
            launcherView.image = launcherAsset
            launcherView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size))
            launcherView.center = CGPoint(x: dockArea.midX, y: dockArea.midY)
            bufferView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size / 3, height: size / 3))
            bufferView.center = launcherView.center
            bufferView.layer.borderWidth = 2
            bufferView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            bufferView.layer.cornerRadius = bufferView.frame.width / 2
        }
        updateSubview(launcherView)
        updateSubview(bufferView)
    }

    func redraw(_ projectile: Projectile) {
        var view = ProjectileView()
        var size = projectileSize
        if let existingView = projectileViews[projectile] {
            view = existingView
            size = existingView.frame.size
        } else {
            view.setStyle(sprite: getAssetForProjectile(projectile))
            projectileViews[projectile] = view
        }
        view.frame = CGRect(origin: projectile.location, size: size)
        updateSubview(view)
    }

    func animateView(of bubble: Bubble, shouldFlash: Bool = false, completion: ((Bool) -> Void)? = nil) {
        let position = bubble.getPosition()
        guard let grid = delegate?.getGridView(),
            let view = grid.cellForItem(at: IndexPath(item: position.column, section: position.row)) as? BubbleCell,
            let contentView = view.backgroundView else {
                return
        }
        let options: UIViewAnimationOptions = shouldFlash ? [.curveEaseInOut, .autoreverse] : .curveEaseOut
        let animations: () -> Void = { contentView.alpha = 0.0 }
        UIView.animate(withDuration: 0.3, delay: 0, options: options, animations: animations, completion: completion)
    }

    private func getAssetForProjectile(_ projectile: Projectile) -> UIImageView? {
        guard let image = assets[projectile.type] else {
            return nil
        }
        return UIImageView(image: image)
    }

    private func updateSubview(_ subview: UIView) {
        guard let source = delegate else {
            return
        }
        subview.removeFromSuperview()
        source.getMainView().addSubview(subview)
    }

}
