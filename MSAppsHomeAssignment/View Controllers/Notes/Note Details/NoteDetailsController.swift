// Abstract: controller for managing note details screen.

import UIKit
import MapKit

class NoteDetailsController: UIViewController {
    
    var note: Note!
    var shouldDeleteNote: Bool = false
    var autoSaveTimer: Timer?
    var isSaveButtonEnabled: Bool {
        print("is save button enabled: \(textField.hasText)")
        return textField.hasText
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - UI
    
    var doneButton: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
    }
    
    var deleteButton: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
    }
    
    var saveButton: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewNote))
    }
    
    var cancelButton: UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAddNote))
    }
    
    // MARK: - UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegate()
        populateViews()
        showDeleteButtonIfNeeded()
        setUpNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if shouldDeleteNote {
            CoreDataStack.shared.viewContext.delete(note)
            CoreDataStack.shared.saveViewContext()
        } else if note != nil {
            autoSaveExistingNote()
        }
    }
    
    // MARK: - Layout
    
    func populateViews() {
        if note == nil {
            dateLabel.text = "Created: " + Date.now.dayAndTimeText
            textField.text = nil
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
            mapView.setUserTrackingMode(.follow, animated: true)
        } else {
            dateLabel.text = "Last modified: " + note.dateModified!.dayAndTimeText
            textField.text = note.body
            
            let coordinate = CLLocationCoordinate2D(latitude: note.location!.latitude, longitude: note.location!.longitude)
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = coordinate
            
            mapView.setUserTrackingMode(.none, animated: false)
            mapView.setCenter(coordinate, animated: true)
            mapView.addAnnotation(pointAnnotation)
        }
    }
    
    func showDeleteButtonIfNeeded() {
        if note != nil {
            navigationItem.rightBarButtonItem = deleteButton
        }
    }
    
    func setUpNavigationBar() {
        if note == nil {
            navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
            navigationItem.title = "Add Note"
            navigationItem.leftBarButtonItem = cancelButton
            saveButton.isEnabled = isSaveButtonEnabled
            navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    func goBackToNotesList() {
        navigationController?.popViewController(animated: true)
    }
}
