//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class DesignerViewController: UIViewController {
    @IBOutlet private var gameArea: UIView!

    internal var gridControl: BubbleGridViewController?
    internal var paletteControl: PaletteViewController?
    internal var actionsControl: ActionsViewController?

    internal var designer: LevelDesigner?
    internal var selectedType: Type?
    internal var editMode: EditMode = .select
    internal var isBackgroundSet = false

    let assets: [Type: UIImage] = [
        .energyType(.fire): #imageLiteral(resourceName: "bubble-red"),
        .energyType(.water): #imageLiteral(resourceName: "bubble-blue"),
        .energyType(.grass): #imageLiteral(resourceName: "bubble-green"),
        .energyType(.electric): #imageLiteral(resourceName: "bubble-orange")
    ]

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        designer = designer == nil ? LevelDesigner() : designer
        let seguedController = segue.destination
        if let controller = seguedController as? BubbleGridViewController {
            gridControl = controller
            gridControl?.delegate = self
            gridControl?.setAssets(assets)
            gridControl?.setGrid(with: designer?.bubbles ?? [:])
        }
        if let controller = seguedController as? PaletteViewController {
            paletteControl = controller
            paletteControl?.delegate = self
            paletteControl?.setPalette(assets)
        }
        if let controller = seguedController as? ActionsViewController {
            actionsControl = controller
            actionsControl?.delegate = self
            actionsControl?.setSavedLevels(with: designer?.levels ?? [])
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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

    private func setBackground(with backgroundImage: UIImage) {
        let background = UIImageView(image: backgroundImage)
        background.frame = CGRect(origin: CGPoint.zero, size: gameArea.bounds.size)
        gameArea.addSubview(background)
    }

}
