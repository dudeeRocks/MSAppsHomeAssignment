// Abstract: description of a row in note details view

import MapKit

extension NoteDetailsController {
    enum Row: Hashable {
        case header(String)
        case viewNote
        case viewLocation
        case editNote
        case editLocation
        case editLocationResult(MKMapItem)
        case date
        case map
        case deleteButton
    }
}
