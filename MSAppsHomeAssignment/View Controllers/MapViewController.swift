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
        setUpNavigationBar()
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
            noteAnnotations.removeAll()
            notes.forEach { note in
                let annotation = MKPointAnnotation()
                annotation.coordinate = note.location!.coordinate
                noteAnnotations[note] = annotation
            }
        } catch {
            fatalError("Failed to perform fetch: \(error.localizedDescription)")
        }
    }
    
    private func setUpNavigationBar() {
        let addNoteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        navigationItem.rightBarButtonItem = addNoteButton
        navigationItem.title = "Notes Map"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance

    }
    
    private func setUpLocationManager() {
        LocationManager.shared.setUpLocationManager(on: self)
    }
    
    private func prepareMapView() {
        mapView.isUserInteractionEnabled = true
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.delegate = self
    }
    
    private func updateAnnotations() {
        guard !noteAnnotations.isEmpty else { return }
        let oldAnnotations = mapView.annotations
        mapView.removeAnnotations(oldAnnotations)
        
        let annotations: [MKPointAnnotation] = Array<MKPointAnnotation>(noteAnnotations.values)
        mapView.addAnnotations(annotations)
    }
    
    private func setDefaultCenterPoint() {
        var coordinate = CLLocationCoordinate2D()
        let ditance: CLLocationDistance = 10000
        let region: MKCoordinateRegion

        if let firstNote = noteAnnotations.keys.sorted(by: { $0.dateModified! > $1.dateModified! }).first {
            coordinate = firstNote.location!.coordinate
        } else {
            switch LocationManager.shared.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                if let userCoordinate = LocationManager.shared.getUserLocationCoordinate() {
                    coordinate = userCoordinate
                } else {
                    fallthrough
                }
            default:
                coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
            }
        }
        region = MKCoordinateRegion(center: coordinate, latitudinalMeters: ditance, longitudinalMeters: ditance)
        
        mapView.setRegion(region, animated: true)
    }
    
    @objc func addNote() {
        if let noteDetailsVC = UIViewController.getViewController(withIdentifier: .noteDetails) as? NoteDetailsController {
            noteDetailsVC.delegate = self
            
            let navigationVC = UINavigationController(rootViewController: noteDetailsVC)
            present(navigationVC, animated: true)
        }
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard
            let pointAnnotation = view.annotation as? MKPointAnnotation,
            let note: Note = noteAnnotations.first(where: { $0.value == pointAnnotation })?.key
        else {
            return
        }
        
        if let noteDetailsVC = UIViewController.getViewController(withIdentifier: .noteDetails) as? NoteDetailsController {
            noteDetailsVC.note = note
            noteDetailsVC.delegate = self
            navigationController?.pushViewController(noteDetailsVC, animated: true)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        setDefaultCenterPoint()
    }
}

extension MapViewController: NoteDetailsDelegate {
    func didUpdateNote() {
        fetchNotes()
        updateAnnotations()
        setDefaultCenterPoint()
    }
}
