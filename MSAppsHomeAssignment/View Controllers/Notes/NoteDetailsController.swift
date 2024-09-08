// Abstract: controller for managing note details screen.

import UIKit
import MapKit

class NoteDetailsController: UIViewController {
    
    var note: Note!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var doneButton: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
    }
    
    var deleteButton: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
    }
    
    private var wasDeleted: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegate()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if wasDeleted {
            // TODO: Delete note here
        } else {
            // TODO: Auto-save here
        }
        print("Going back to list")
    }
    
    func goBackToNotesList() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Toolbar
    
    private func setUpToolBar() {
        let toolbarItems: [UIBarButtonItem] = [
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote)),
        ]
    }
    
    // MARK: - Actions
    
    @objc func saveNote() {
        guard let text = textField.text else {
            return
        }
        
        let location = mapView.centerCoordinate
        
        do {
            try CoreDataStack.shared.saveNote(withText: text, at: location)
        } catch {
            fatalError("Failed to save a note. Error: \(error.localizedDescription)")// TODO: Handle errors here
        }
    }
    
    @objc func deleteNote() {
        guard let noteToDelete = note else {
            print("There's no note to delete.")
            return
        }
        wasDeleted = true
        goBackToNotesList()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
