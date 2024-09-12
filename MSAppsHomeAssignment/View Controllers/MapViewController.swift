// Abstract: controller for the map screen.

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    var notes: [Note] = []
    var annotations: [MKPointAnnotation] = []
    
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
            notes = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
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
        guard !notes.isEmpty else { return }
        
//        let oldAnnotations = mapView.annotations
//        mapView.removeAnnotations(oldAnnotations)
        
        notes.forEach { note in
            let annotation = MKPointAnnotation()
            annotation.coordinate = note.location!.coordinate
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
    }
    
    private func setDefaultCenterPoint() {
        var coordinate = CLLocationCoordinate2D()
        if let firstNote = notes.first {
            coordinate = firstNote.location!.coordinate
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
        let annotation = MKMarkerAnnotationView(frame: .zero)
        annotation.animatesWhenAdded = true
        annotation.markerTintColor = .systemBlue
        return annotation
    }
}


class LocationManager {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    var authorizationStatus: CLAuthorizationStatus { locationManager.authorizationStatus }
    
    func setUpLocationManager(on delegate: CLLocationManagerDelegate) {
        locationManager.delegate = delegate
        locationManager.requestWhenInUseAuthorization()
        if locationManager.authorizationStatus == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    private init() {
        
    }
}
