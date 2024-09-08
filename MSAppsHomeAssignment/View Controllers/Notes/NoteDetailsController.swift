// Abstract: controller for managing note details screen.

import UIKit
import MapKit

class NoteDetailsController: UIViewController {
    
    var note: Note!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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

}
