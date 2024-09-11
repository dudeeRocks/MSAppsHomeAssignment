// Abstract: controller for managing note details screen.

import UIKit
import MapKit

protocol NoteDetailsDelegate: AnyObject {
    func didUpdateNote()
}

class NoteDetailsController: UICollectionViewController {

    var note: Note!
    var dataSource: DataSource!
    var delegate: NoteDetailsDelegate?
    
    var newNoteText: String = ""
    var newLocation: CLLocationCoordinate2D = .init()
    var isSaveEnabled: Bool { newNoteText.isEmpty }
    
    var shouldDeleteNote: Bool = false
    var isNewNote: Bool { note == nil }
    
    let locationManager = CLLocationManager()
    
    // MARK: - UI
    
    var saveButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    var cancelEditButton: UIBarButtonItem!
    var cancelAddButton: UIBarButtonItem!
    
    // MARK: - UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        attachTapGesture()
        configureDataSource()
        configureCollectionViewLayout()
        updateUI(for: isNewNote ? .edit : .view, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if shouldDeleteNote {
            CoreDataStack.shared.viewContext.delete(note)
            CoreDataStack.shared.saveViewContext()
        } else if note != nil {
            // TODO: Get back HERE!
        }
    }
    
    // MARK: - Layout
    
    func setUpNavigationBar() {
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewNote))
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editNote))
        cancelAddButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAddNote))
        cancelEditButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditing))
        
        navigationItem.style = .navigator
        navigationItem.largeTitleDisplayMode = .never
        if isNewNote {
            navigationItem.title = NSLocalizedString("Add note", comment: "Title for add note screen.")
            saveButton.isEnabled = false
        } else {
            navigationItem.title = NSLocalizedString("Note", comment: "Title for existing note.")
            navigationItem.rightBarButtonItem = editButton
        }
    }
    
    func updateNavigationBar(for updateCase: UpdateCase) {
        switch updateCase {
        case .view:
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = editButton
        case .edit:
            navigationItem.leftBarButtonItem = isNewNote ? cancelAddButton : cancelEditButton
            navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    func updateSaveButton() {
        if isSaveEnabled {
            self.saveButton.isEnabled = false
        } else {
            self.saveButton.isEnabled = true
        }
    }
    
    func attachTapGesture() {
        let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapToDismissKeyboard)
    }
}
