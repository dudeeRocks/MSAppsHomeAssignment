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
}
