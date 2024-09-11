// Abstract: methods that handle cell configuration for Note Details collection view.

import UIKit
import MapKit

extension NoteDetailsController {
    
    func defaultConfiguration(cell: UICollectionViewListCell, at row: Row) {
        var content = cell.defaultContentConfiguration()
        content.text = getTextFor(row)
        cell.contentConfiguration = content
    }
    
    func headerConfiguration(cell: UICollectionViewListCell, at indexPath: IndexPath, title: String) {
        var content = cell.defaultContentConfiguration()
        /// This number is used to determine content of the header.
        /// It's derived from the `indexPath.section` number, and on `isEditing` adjusted by the number of extra sections in edit mode.
        let adjustedSectionNumber = isEditing ? indexPath.section + 2 : indexPath.section
        switch adjustedSectionNumber {
        case Section.viewNote.rawValue, Section.viewLocation.rawValue, Section.map.rawValue, Section.delete.rawValue:
            content.text = nil
        default:
            content.text = title
        }
        
        print("AdjustedNumber: \(adjustedSectionNumber) || Index.section = \(indexPath.section) ||| Title: \(title) ||| Delete section: \(Section.delete.rawValue)")
        
        cell.contentConfiguration = content
    }
    
    func mapConfiguration(cell: UICollectionViewListCell, location: CLLocationCoordinate2D) {
        var content = cell.mapConfiguration()
        content.location = location
        cell.contentConfiguration = content
    }
    
    private func getTextFor(_ row: Row) -> String? {
        switch row {
        case .header(let string):
            return string
        case .note:
            return isNewNote ? nil : note.body
        case .date:
            if isNewNote {
                return NSLocalizedString("Created: \(Date.now.dayAndTimeText)", comment: "Date created title.")
            } else {
                return NSLocalizedString("Last edited: \(note.dateModified!.dayAndTimeText)", comment: "Date modified title.")
            }
        case .map:
            return "Insert map here"
        case .deleteButton:
            return NSLocalizedString("Delete note", comment: "Delete note button text")
        case .locationSearchField:
            return "Edit location goes here"
        case .editNote(let note):
            return "This should edit note"
        case .location:
            return "Insert location here"
        case .locationResult(let autoCompleteResult):
            return autoCompleteResult
        }
    }
}
