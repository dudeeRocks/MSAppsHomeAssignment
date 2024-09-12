// Abstract: methods that handle cell configuration for Note Details collection view.

import UIKit
import MapKit

extension NoteDetailsController {
    
    /// Used for view mode.
    func viewConfiguration(cell: UICollectionViewListCell, at row: Row) {
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
    
    func textViewConfiguration(cell: UICollectionViewListCell) {
        var content = cell.textViewConfiguration()
        content.text = isNewNote ? nil : note.body
        content.onChange = { [weak self] text in
            guard let self = self else { return }
            newNoteText = text
            updateSaveButton()
        }
        cell.contentConfiguration = content
    }
    
    func locationTextFieldConfiguration(cell: UICollectionViewListCell) {
        var content = cell.locationSearchFieldConfiguration()
        content.text = isNewNote ? nil : note.location!.displayName
        content.coordinate = isNewNote ? CLLocationCoordinate2D(latitude: 0, longitude: 0) : note.location!.coordinate
        content.onResultsUpdate = { [weak self] results in
            guard let self = self else { return }
            let cappedResults = results.prefix(5)
            var searchResultsRows: [Row] = []
            for result in cappedResults {
                let newRow = Row.editLocationResult(result)
                searchResultsRows.append(newRow)
            }
            updateUI(for: .searchResults(searchResultsRows))
        }
        cell.contentConfiguration = content
    }
    
    func locationSearchResultConfiguration(cell: UICollectionViewListCell, searchCompletion: MKLocalSearchCompletion) {
        var content = cell.defaultContentConfiguration()
        content.attributedText = createHighlightedString(text: searchCompletion.title, rangeValues: searchCompletion.titleHighlightRanges)
        content.secondaryAttributedText = createHighlightedString(text: searchCompletion.subtitle, rangeValues: searchCompletion.subtitleHighlightRanges)
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
        content.location = note?.location
        content.onLocationUpdate = { coordinate in
            self.newLocation = coordinate
        }
        cell.contentConfiguration = content
    }
    
    func deleteButtonConfiguration(cell: UICollectionViewListCell) {
        var content = cell.deleteButtonConfiguration()
        content.text = NSLocalizedString("Delete note", comment: "Delete button on edit note.")
        content.onTap = deleteNote
        cell.contentConfiguration = content
    }
    
    private func getTextForViewing(_ row: Row) -> String? {
        switch row {
        case .viewNote:
            return note.body
        case .viewLocation:
            return note.location?.displayName
        default:
            return nil
        }
    }
    
    private func createHighlightedString(text: String, rangeValues: [NSValue]) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.backgroundColor: UIColor.systemYellow ]
        let highlightedString = NSMutableAttributedString(string: text)


        // Each `NSValue` wraps an `NSRange` that functions as a style attribute's range with `NSAttributedString`.
        let ranges = rangeValues.map { $0.rangeValue }
        ranges.forEach { (range) in
            highlightedString.addAttributes(attributes, range: range)
        }


        return highlightedString
    }
}
