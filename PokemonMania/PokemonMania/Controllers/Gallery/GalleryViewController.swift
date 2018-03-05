//  Created by Huang Lie Jun on 5/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

class GalleryViewController: UIViewController, UICollectionViewDelegate,
UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet private var levelList: UICollectionView!
    private var levels: [String: Stage] = [:]
    private var gameControl: GameViewController?
    private var stageToSegue: Stage = Stage()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? GameViewController {
            gameControl = controller
            gameControl?.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Load saved levels from file to levels collection...
        // Need to sort by identifier index, and also store the last unlocked level...
        // Selectively display levels by saved last unlocked level...
        levels = Storage.read(.levels, as: [String: Stage].self) ?? [:]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cancelLoad(_ sender: Any) {
        dismiss(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCell", for: indexPath)
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        guard let levelCell = cell as? TemplateCell else {
            fatalError("Fatal: LevelCell cannot be used.")
        }
        if let level = levels[String(format: "%02d", indexPath.item + 1)] {
            let title = level.getTitle()
            let imageView = UIImageView(image: UIImage(contentsOfFile: Storage.getImagePath(for: title)))
            levelCell.setStyle(preview: imageView, title: title)
        }
        return levelCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.bounds.width
        width = width < 600 ? width - 40 : (width - 80) / 3
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

    @objc
    func didTap(_ recognizer: UITapGestureRecognizer) {
        let tapPosition = recognizer.location(in: levelList)
        if let index = levelList.indexPathForItem(at: tapPosition),
           let level = levels[String(format: "%02d", index.item + 1)] {
            stageToSegue = Stage(from: level)
            self.performSegue(withIdentifier: "StartGameFromGallery", sender: recognizer.view)
        }
    }

}

extension GalleryViewController: GameDelegate {

    func getGameStage() -> Stage {
        return stageToSegue
    }

}
