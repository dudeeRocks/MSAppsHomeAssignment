// Abstract: controller for the map screen.

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    var noteAnnotations: [Note: MKPointAnnotation] = [:]
    
    // MARK: - IBOutlet
    
    @IBOutlet var mapView: MKMapView!
    
    
    // MARK: - UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        fetchNotes()
        updateAnnotations()
        setDefaultCenterPoint()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        prepareMapView()
    }
    
    // MARK: - Methods
    
    private func fetchNotes() {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Note.dateModified, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let notes = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            notes.forEach { note in
                let annotation = MKPointAnnotation()
                annotation.coordinate = note.location!.coordinate
                noteAnnotations[note] = annotation
            }
        } catch {
            fatalError("Failed to perform fetch: \(error.localizedDescription)")
        }
    }
    
    private func setUpLocationManager() {
        LocationManager.shared.setUpLocationManager(on: self)
    }
    
    private func prepareMapView() {
        mapView.isUserInteractionEnabled = true
        mapView.showsUserLocation = false
        mapView.showsCompass = true
        mapView.setCameraZoomRange(MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 10_000), animated: false)
        mapView.delegate = self
    }
    
    private func updateAnnotations() {
        guard !noteAnnotations.isEmpty else { return }
        
        var annotations: [MKPointAnnotation] = Array<MKPointAnnotation>(noteAnnotations.values)
        mapView.addAnnotations(annotations)
    }
    
    private func setDefaultCenterPoint() {
        var coordinate = CLLocationCoordinate2D()
        if let firstNote = noteAnnotations.first {
            coordinate = firstNote.key.location!.coordinate
        } else {
            if case .authorizedWhenInUse = LocationManager.shared.authorizationStatus {
                coordinate = mapView.userLocation.coordinate
            } else {
                coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            }
        }
        mapView.setCenter(coordinate, animated: false)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        guard 
            let pointAnnotation = annotation as? MKPointAnnotation,
            let note: Note = noteAnnotations.first(where: { $0.value == pointAnnotation })?.key,
            let noteText: String = note.body
        else { return nil }
        
        let annotationView = MKMarkerAnnotationView(frame: .zero)
        annotationView.animatesWhenAdded = true
        annotationView.markerTintColor = .systemBlue
        annotationView.canShowCallout = true
        
        let noteTextLabel = UILabel()
        noteTextLabel.text = String(noteText.prefix(30))
        noteTextLabel.textColor = .label
        noteTextLabel.textAlignment = .left
        noteTextLabel.font = .preferredFont(forTextStyle: .body)
        noteTextLabel.numberOfLines = 1
        
        let noteLocationLabel = UILabel()
        noteLocationLabel.text = String(note.dateModified!.dayAndTimeText + " • " + note.location!.displayName!)
        noteLocationLabel.textColor = .secondaryLabel
        noteLocationLabel.textAlignment = .left
        noteLocationLabel.font = .preferredFont(forTextStyle: .caption1)
        noteLocationLabel.numberOfLines = 1
        
        let detailCalloutAccessoryView = UIStackView(arrangedSubviews: [noteTextLabel, noteLocationLabel])
        detailCalloutAccessoryView.axis = .vertical
        detailCalloutAccessoryView.spacing = 4
        detailCalloutAccessoryView.distribution = .equalSpacing
        detailCalloutAccessoryView.translatesAutoresizingMaskIntoConstraints = false
        detailCalloutAccessoryView.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        
        let symbol = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .body), scale: .medium))
        
        let rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        rightCalloutAccessoryView.setImage(symbol, for: .normal)
        rightCalloutAccessoryView.tintColor = .secondaryLabel
        
        annotationView.detailCalloutAccessoryView = detailCalloutAccessoryView
        annotationView.rightCalloutAccessoryView = rightCalloutAccessoryView
        return annotationView
    }
}
