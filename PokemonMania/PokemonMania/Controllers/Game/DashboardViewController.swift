//  Created by Huang Lie Jun on 5/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet private var scoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    @IBAction func didQuit(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func didPause(_ sender: UIButton) {
    }

}
