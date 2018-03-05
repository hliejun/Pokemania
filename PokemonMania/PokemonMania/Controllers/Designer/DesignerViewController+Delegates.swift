//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

extension DesignerViewController: PaletteDelegate, DesignDelegate, ActionDelegate, GameDelegate {

    func didSelect(position: Position) {
        switch editMode {
        case .select:
            if let type = selectedType {
                designer?.insertBubble(at: position, ofType: type)
            }
        case .cycle:
            if let type = designer?.getBubbleType(at: position),
               let labels = paletteControl?.getLabels(), !labels.isEmpty {
                let nextIndex = ((labels.index(of: type) ?? -1) + 1) % labels.count
                designer?.insertBubble(at: position, ofType: labels[nextIndex])
            }
        case .remove:
            designer?.removeBubble(at: position)
        }
        refreshGrid(at: position)
    }

    func didForceRemove(position: Position) {
        designer?.removeBubble(at: position)
        refreshGrid(at: position)
    }

    func didUpdateEditToggle(_ editMode: EditMode) {
        self.editMode = editMode
    }

    func didUpdateBubbleOption(_ type: Type?) {
        self.selectedType = type
    }

    func didReset() {
        designer?.resetDesign()
        refreshGrid()
    }

    func didLoad(with templateName: String) {
        designer?.loadLevel(ofTitle: templateName)
        refreshGrid()
    }

    func didSave(with templateName: String, isPreset: Bool = false) {
        let image = gridControl?.getPreviewImage() ?? #imageLiteral(resourceName: "background")
        if let imageData = UIImagePNGRepresentation(image) {
            NSMutableData(data: imageData).write(toFile: Storage.getImagePath(for: templateName), atomically: true)
            designer?.saveLevel(ofTitle: templateName, isPreset: isPreset)
        }
        refreshSavedLevels()
    }

    func didDelete(with templateName: String, index: IndexPath) {
        designer?.deleteLevel(ofTitle: templateName)
        refreshSavedLevels(at: index)
    }

    func getGameStage() -> Stage {
        return designer?.getCopyOfStage() ?? Stage()
    }

    private func refreshGrid(at position: Position? = nil) {
        guard let updatedBubbles = designer?.bubbles else {
            return
        }
        if let updatePosition = position {
            gridControl?.setGrid(with: updatedBubbles, position: updatePosition)
        } else {
            gridControl?.setGrid(with: updatedBubbles, reset: true)
        }
    }

    private func refreshSavedLevels(at index: IndexPath? = nil) {
        guard let levels = designer?.levels else {
            return
        }
        actionsControl?.setSavedLevels(with: levels, deleted: index)
    }

}
