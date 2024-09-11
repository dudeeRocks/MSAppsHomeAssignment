// Abstract: methods to get map related data from a Note

import MapKit

extension NoteLocation {
    /// Returns a `CLLocationCoordinate2D` for the stored `location` property of the note.
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
