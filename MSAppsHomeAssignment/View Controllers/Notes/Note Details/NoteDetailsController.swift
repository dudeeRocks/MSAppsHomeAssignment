// Abstract: controller for managing note details screen.

import UIKit
import MapKit

class NoteDetailsController: UIViewController {
    
    var note: Note!
    var shouldDeleteNote: Bool = false
    var autoSaveTimer: Timer?
    
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
    
    // MARK: - UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegate()
        populateViews()
        showDeleteButtonIfNeeded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if shouldDeleteNote {
            CoreDataStack.shared.persistentContainer.viewContext.delete(note)
            CoreDataStack.shared.saveContext()
        } else if note != nil {
            saveNote()
        }
    }
    
    // MARK: - Methods
    
    func populateViews() {
        if note == nil {
            dateLabel.text = "Last modified: " + Date.now.dayAndTimeText
            textField.text = nil
            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
            mapView.setUserTrackingMode(.follow, animated: true)
        } else {
            dateLabel.text = note.dateModified?.dayAndTimeText
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
    
    func goBackToNotesList() {
        navigationController?.popViewController(animated: true)
    }
}
