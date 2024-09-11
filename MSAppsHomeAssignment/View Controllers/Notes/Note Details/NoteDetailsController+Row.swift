// Abstract: description of a row in note details view

import Foundation

extension NoteDetailsController {
    enum Row: Hashable {
        case header(String)
        case viewNote
        case viewLocation
        case editNote(String?)
        case editLocation(String?)
        case editLocationResult(String)
        case date
        case map
        case deleteButton
    }
}
