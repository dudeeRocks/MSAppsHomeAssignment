// Abstract: methods to get map related data from a Note

import MapKit

extension Note {
    /// Returns a `CLLocationCoordinate2D` for the stored `location` property of the note.
    var coordinate: CLLocationCoordinate2D {
        if let location = location {
            return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        } else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
    
    private var unknownLocationString: String {
        NSLocalizedString("Unknown location", comment: "Description for unknown location")
    }
    
    func getLocationDescription() async -> String { // TODO: Gotta get the desc here.
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
