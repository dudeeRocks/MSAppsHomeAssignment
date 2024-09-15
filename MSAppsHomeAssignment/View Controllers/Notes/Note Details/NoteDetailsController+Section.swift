// Abstract: sections for organizing the fields

import Foundation

extension NoteDetailsController {
    /// Used to determine the sections in `NoteDetailsController`.
    /// The case order is important, because it determines whether the section name will be shown during `headerConfiguration(cell:at:title:)`.
    enum Section: Int, Hashable {
        case viewNote
        case viewLocation
        case editNote
        case editLocation
        case locationResults
        case map
        case delete
        
        /// Section title to display.
        /// Produces values for all sections to make sure `Snapshot` is applied when switching between edit and view modes.
        var title: String {
            switch self {
            case .editNote:
                return "Note"
            case .editLocation:
                return "Location"
            case .viewNote:
                return "view"
            case .delete:
                return "delete"
            case .map:
                return "map"
            case .viewLocation:
                return "location"
            case .locationResults:
                return "locationResults"
            }
        }
    }
}
