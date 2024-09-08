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
        
        
        setToolbarItems(<#T##toolbarItems: [UIBarButtonItem]?##[UIBarButtonItem]?#>, animated: <#T##Bool#>)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - Toolbar
    
    private func setUpToolBar() {
        let toolbarItems: [UIBarButtonItem] = [
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote)),
            UIBarButtonItem(barButtonSystemItem: .trash, target: <#T##Any?#>, action: <#T##Selector?#>)
        ]
    }
    
    // MARK: - Actions
    
    @objc func saveNote() {
        
    }

}
