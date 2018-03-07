//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit
import Foundation

protocol GameDelegate: class {
    func getGameStage() -> Stage
}

class GameViewController: UIViewController, GameEngineDelegate, GameGridDelegate, DashboardDelegate {
    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private var dashboard: UIView!
    @IBOutlet private var gameArea: UIView!
    @IBOutlet private var dock: UIView!
    weak var delegate: GameDelegate?
    private var dashboardControl: DashboardViewController?
    private var gridControl: GameGridController?
    private var gameEngine: GameEngine?
    private var loadedStage: Stage?
    private var isBackgroundSet: Bool = false

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let seguedController = segue.destination
        if let controller = seguedController as? GameGridController {
            gridControl = controller
            gridControl?.delegate = self
        }
        if let controller = seguedController as? DashboardViewController {
            dashboardControl = controller
            dashboardControl?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDemoStage()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isBackgroundSet {
            setBackground(with: #imageLiteral(resourceName: "background"))
            isBackgroundSet = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setup() {
        let stage = delegate?.getGameStage() ?? loadedStage ?? Stage()
        gameEngine = gameEngine ?? GameEngine(stage: stage, delegate: self)
    }

    func getGameArea() -> CGRect {
        return gameArea.frame
    }

    func getDockArea() -> CGRect {
        return dock.frame
    }

    func getLauncherSize() -> CGFloat {
        return dock.frame.height
    }

    func getProjectileSize() -> CGFloat {
        return gridControl?.cellSize ?? 0
    }

    func getMainView() -> UIView {
        return view
    }

    func getGridView() -> UICollectionView {
        guard let grid = gridControl?.collectionView else {
            fatalError("Fatal: No grid provided for game engine.")
        }
        return grid
    }

    func getControlView() -> UIView {
        return dashboard
    }

    func pauseGame(_ isPaused: Bool) {
        gameEngine?.pauseGame(isPaused)
    }

    func quitGame() {
        gameEngine?.endGame()
        dismiss(animated: true)
    }

    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true)
    }

    private func setupDemoStage() {
        guard loadedStage == nil else {
            return
        }
        loadedStage = Stage()
        globalTemplateBubbles.forEach { bubble in loadedStage?.insertBubble(bubble) }
    }

    private func setBackground(with backgroundImage: UIImage) {
        let background = UIImageView(image: backgroundImage)
        background.frame = CGRect(origin: CGPoint.zero, size: backgroundView.bounds.size)
        backgroundView.addSubview(background)
    }

}
