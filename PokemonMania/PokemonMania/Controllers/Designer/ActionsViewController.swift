//  Created by Huang Lie Jun on 2/3/18.
//  Copyright © 2018 nus.cs3217.a0123994. All rights reserved.

import UIKit

enum AlertType {
    case delete, load, reset, save, start
}

protocol ActionDelegate: class {
    func didReset()
    func didLoad(with templateName: String)
    func didDelete(with templateName: String, index: IndexPath)
    func didSave(with templateName: String, isPreset: Bool)
}

class ActionsViewController: UIViewController {
    weak var delegate: ActionDelegate?

    weak private var gameControl: GameViewController?
    weak private var templateControl: TemplateViewController?
    private var startAlert: UIAlertController?
    private var saveAlert: UIAlertController?
    private var resetAlert: UIAlertController?
    private var deleteAlert: UIAlertController?
    private var loadAlert: UIAlertController?

    private var templates = [String]()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination.childViewControllers.first as? TemplateViewController {
            templateControl = controller
            templateControl?.delegate = self
            templateControl?.setTemplates(templates)
        }
        if let controller = segue.destination as? GameViewController {
            gameControl = controller
            gameControl?.delegate = delegate as? GameDelegate
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func startGame(_ sender: Any) {
        startAlert = createAlert(ofType: .start)
        startAlert?.addAction(UIAlertAction(title: "Start", style: .destructive) { _ in
            self.performSegue(withIdentifier: "StartGameFromDesigner", sender: sender)
        })
        if let alert = startAlert {
            present(alert, animated: true)
        }
    }

    @IBAction func saveDesign(_ sender: Any) {
        let optionsAlert = UIAlertController(title: "Save Modes", message: "Pick Option", preferredStyle: .actionSheet)
        optionsAlert.addAction(UIAlertAction(title: "Preset", style: .default) { _ in
            self.saveAlert = self.getSaveAlert(isPreset: true)
            if let alert = self.saveAlert {
                self.present(alert, animated: true)
            }
        })
        optionsAlert.addAction(UIAlertAction(title: "Custom", style: .default) { _ in
            self.saveAlert = self.getSaveAlert(isPreset: false)
            if let alert = self.saveAlert {
                self.present(alert, animated: true)
            }
        })
        self.present(optionsAlert, animated: true)
    }

    @IBAction func resetDesign(_ sender: Any) {
        resetAlert = createAlert(ofType: .reset)
        resetAlert?.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in self.delegate?.didReset() })
        if let alert = resetAlert {
            present(alert, animated: true)
        }
    }

    @IBAction func cancelLoad(_ sender: Any) {
        dismiss(animated: true)
    }

    @objc
    func textDidChange(_ textField: UITextField) {
        saveAlert?.actions[1].isEnabled = isValidLevelTitle(textField.text)
    }

    func setSavedLevels(with savedLevels: [String], deleted index: IndexPath? = nil) {
        templates = savedLevels
        templateControl?.setTemplates(templates, deleted: index)
    }

    private func createAlert(ofType type: AlertType) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        switch type {
        case .delete:
            alert.title = "Delete Level"
            alert.message = "Are you sure you want to delete this level design?"
        case .load:
            alert.title = "Load Level"
            alert.message = "You are about to load a level design. Any unsaved changes will be lost. Continue?"
        case .reset:
            alert.title = "Reset Level"
            alert.message = "Are you sure you want to reset? Any unsaved changes will be lost."
        case .save:
            alert.title = "Save Level"
            alert.message = "You are about to save a level design. Please give this masterpiece a title."
        case .start:
            alert.title = "Start Game"
            alert.message = "You are about to start a game! Any unsaved changes will be lost. Continue?"
        }
        return alert
    }

    private func getSaveAlert(isPreset: Bool) -> UIAlertController? {
        let alert = createAlert(ofType: .save)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let title = alert.textFields?.first?.text {
                self.delegate?.didSave(with: title, isPreset: isPreset)
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "Enter level title..."
            textField.addTarget(self, action: #selector(self.textDidChange), for: .editingChanged)
        }
        alert.addAction(saveAction)
        alert.actions[1].isEnabled = false
        return alert
    }

    private func isValidLevelTitle(_ input: String?) -> Bool {
        guard let text = input else {
            return false
        }
        do {
            let regex = try NSRegularExpression(pattern: "[^a-zA-Z0-9_]+", options: .caseInsensitive)
            let range = NSRange(location: 0, length: text.count)
            let matches = regex.matches(in: text, options: [.withoutAnchoringBounds], range: range)
            return !text.isEmpty
                && !templates.contains(text)
                && matches.isEmpty
        } catch {
            return false
        }
    }

}

extension ActionsViewController: TemplateDelegate {

    func didLoadTemplate(name: String) {
        loadAlert = createAlert(ofType: .load)
        loadAlert?.addAction(UIAlertAction(title: "Load", style: .destructive) { _ in
            self.delegate?.didLoad(with: name)
            self.templateControl?.dismiss(animated: true)
        })
        if let alert = loadAlert {
            templateControl?.present(alert, animated: true)
        }
    }

    func didDeleteTemplate(name: String, index: IndexPath) {
        deleteAlert = createAlert(ofType: .delete)
        deleteAlert?.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.delegate?.didDelete(with: name, index: index)
        })
        if let alert = deleteAlert {
            templateControl?.present(alert, animated: true)
        }
    }

}
