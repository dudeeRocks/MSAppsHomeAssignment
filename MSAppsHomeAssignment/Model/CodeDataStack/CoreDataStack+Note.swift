// Abstract: methods for handling notes

import CoreData
import MapKit

extension CoreDataStack {
    
    private var unknownLocationString: String {
        NSLocalizedString("Unknown location", comment: "Description for unknown location")
    }
    
    /// Saves `Note` entity with passed text and location.
    func createNote(withText body: String, at coordinates: CLLocationCoordinate2D, date: Date) async throws -> Note {
        let context = viewContext
        
        let location = NoteLocation(context: context)
        location.latitude = coordinates.latitude
        location.longitude = coordinates.longitude
        location.displayName = await getDisplayName(for: coordinates)
        
        let note = Note(context: context)
        note.body = body
        note.dateModified = date
        note.location = location
        
        location.note = note
        
        do {
            try context.save()
            print("Saved note: \(body.prefix(10)), last modified \(date.dayAndTimeText).")
            return note
        } catch {
            throw CoreDataError(kind: .noteSave, note: note)
        }
    }
    
    func getDisplayName(for coordinate: CLLocationCoordinate2D) async -> String {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            
            if let placemark = placemarks.first {
                return getAddressDescription(placemark: placemark)
            } else {
                return unknownLocationString
            }
        } catch {
            Log.main.log(error: "Failed to get decription for location: \(location)")
            return unknownLocationString
        }
    }
    
    private func getAddressDescription(placemark: CLPlacemark) -> String {
        if let streetAddress = placemark.thoroughfare {
            return streetAddress
        } else if let locality = placemark.locality {
            return locality
        } else if let inLandWater = placemark.inlandWater {
            return inLandWater
        } else if let ocean = placemark.ocean {
            return ocean
        } else {
            return unknownLocationString
        }
    }
}
