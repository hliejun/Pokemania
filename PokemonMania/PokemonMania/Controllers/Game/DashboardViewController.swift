//  Created by Huang Lie Jun on 5/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

protocol DashboardDelegate: class {
    func pauseGame(_ isPaused: Bool)
    func quitGame()
}

class DashboardViewController: UIViewController {
    weak var delegate: DashboardDelegate?
    private var isPaused = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    @IBAction func didPause(_ sender: UIButton) {
        isPaused = !isPaused
        delegate?.pauseGame(isPaused)
        let title = isPaused ? "Resume" : "Pause"
        let animator = UIViewPropertyAnimator(duration: Animations.duration.rawValue, dampingRatio: 0.6) {
            sender.setTitle(title, for: .normal)
        }
        animator.startAnimation()
    }

    @IBAction func didQuit(_ sender: UIButton) {
        delegate?.quitGame()
    }

}
