// Abstract: methods that handle cell configuration for Note Details collection view.

import UIKit
import MapKit

extension NoteDetailsController {
    
    /// Used for view mode.
    func defaultConfiguration(cell: UICollectionViewListCell, at row: Row) {
        var content = cell.defaultContentConfiguration()
        content.text = getTextForViewing(row)
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
        
        cell.contentConfiguration = content
    }
    
    func dateConfiguration(cell: UICollectionViewListCell) {
        var content = cell.defaultContentConfiguration()
        if isNewNote {
            content.secondaryText = NSLocalizedString("Created: \(Date.now.dayAndTimeText)", comment: "Date created title.")
        } else {
            content.secondaryText = NSLocalizedString("Last edited: \(note.dateModified!.dayAndTimeText)", comment: "Date modified title.")
        }
        content.secondaryTextProperties.color = .secondaryLabel
        cell.contentConfiguration = content
    }
    
    func mapConfiguration(cell: UICollectionViewListCell) {
        var content = cell.mapConfiguration()
        if isNewNote {
            content.location = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        } else {
            content.location = CLLocationCoordinate2D(latitude: note.location!.latitude, longitude: note.location!.longitude)
        }
        cell.contentConfiguration = content
    }
    
    private func getTextForViewing(_ row: Row) -> String? {
        switch row {
        case .viewNote:
            return note.body
        case .viewLocation:
            // TODO: get location here. async busts my balls
        default:
            return nil
        }
    }
}
