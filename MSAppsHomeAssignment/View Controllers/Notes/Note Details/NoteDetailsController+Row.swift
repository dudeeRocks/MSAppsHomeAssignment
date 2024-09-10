// Abstract: description of a row in note details view

import Foundation

extension NoteDetailsController {
    enum Row: Hashable {
        case header(String)
        case date
        case note
        case location
        case map
        case deleteButton
        case editNote(String?)
        case locationSearchField(String?)
        case locationResult(String)
    }
}
