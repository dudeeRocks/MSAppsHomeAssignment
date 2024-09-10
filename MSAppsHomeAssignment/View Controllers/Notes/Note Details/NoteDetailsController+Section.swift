// Abstract: sections for organizing the fields

import Foundation

extension NoteDetailsController {
    enum Section: Hashable {
        case view
        case note
        case location
        case editLocation
        case map
        case delete
        
        var name: String {
            switch self {
            case .note:
                return NSLocalizedString("Note", comment: "Title for note on note edit.")
            case .editLocation:
                return NSLocalizedString("Location", comment: "Title for location on note edit.")
            case .view:
                return ""
            case .delete:
                return " "
            case .map:
                return "  "
            case .location:
                return "   "
            }
        }
    }
}
