// Abstract: controller for managing note details screen.

import UIKit
import MapKit

protocol NoteDetailsDelegate: AnyObject {
    func didUpdateNote()
}

class NoteDetailsController: UIViewController {
    
    var note: Note!
    var delegate: NoteDetailsDelegate?
    
    var shouldDeleteNote: Bool = false
    var autoSaveTimer: Timer?
    
    var textViewHeightConstraint: NSLayoutConstraint?
    var textViewPlaceholder: UILabel = {
        let placeholder = UILabel()
        placeholder.text = "Start typing your note here..."
        placeholder.textColor = .placeholderText
        placeholder.textAlignment = .left
        placeholder.font = .preferredFont(forTextStyle: .body)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        return placeholder
    }()
    
    // MARK: Outlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - UI
    
    var doneButton: UIBarButtonItem!
    
    var deleteButton: UIBarButtonItem!
    
    var saveButton: UIBarButtonItem!
    
    var cancelButton: UIBarButtonItem!
    
    // MARK: - UIViewController Overrides
    
    override func viewWillAppear(_ animated: Bool) {
        updatePlaceholder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        prepareTextView()
        populateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if note != nil && !textView.hasText {
            shouldDeleteNote = true
        }
        
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
            textView.text = nil
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
            mapView.setUserTrackingMode(.follow, animated: true)
        } else {
            dateLabel.text = "Last modified: " + note.dateModified!.dayAndTimeText
            textView.text = note.body
            
            let coordinate = CLLocationCoordinate2D(latitude: note.location!.latitude, longitude: note.location!.longitude)
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = coordinate
            
            mapView.setUserTrackingMode(.none, animated: false)
            mapView.setCenter(coordinate, animated: true)
            mapView.addAnnotation(pointAnnotation)
        }
    }
    
    func setUpNavigationBar() {
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewNote))
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAddNote))
        
        if note == nil {
            navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
            navigationItem.title = "Add Note"
            navigationItem.leftBarButtonItem = cancelButton
            navigationItem.rightBarButtonItem = saveButton
            saveButton.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem = deleteButton
        }
    }
}
