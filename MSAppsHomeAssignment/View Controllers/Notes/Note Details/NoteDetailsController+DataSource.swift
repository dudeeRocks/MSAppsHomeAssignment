// Abstract: methods for configuring diffable data source and snapshots for note details view

import UIKit

extension NoteDetailsController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    enum UpdateCase { case view, edit }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }
    
    func configureCollectionViewLayout() {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        collectionView.collectionViewLayout = listLayout
    }
    
    func updateUI(for updateCase: UpdateCase, animated: Bool = true, locationResults: [Row]? = nil) {
        updateNavigationBar(for: updateCase)
        switch updateCase {
        case .view:
            updateSnapshotForViewing(animated: animated)
        case .edit:
            updateSnapshotForEditing(animated: animated)
        }
    }
    
    private func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        var content = cell.defaultContentConfiguration()
        content.text = getTextFor(row)
        cell.contentConfiguration = content
    }
    
    private func updateSnapshotForViewing(animated: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.view, .location])
        snapshot.appendItems([
            .header(Section.view.name),
            .date,
            .note
        ], toSection: .view)
        snapshot.appendItems([
            .header(Section.location.name),
            .location,
            .map
        ], toSection: .location)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func updateSnapshotForEditing(animated: Bool = true, locationResults: [Row]? = nil) {
        var snapshot = Snapshot()
        snapshot.appendSections([.note, .editLocation, .map, .delete])
        snapshot.appendItems([
            .header(Section.note.name),
            .editNote(note?.body)
        ], toSection: .note)
        snapshot.appendItems([
            .header(Section.editLocation.name),
            .locationSearchField("120 Derech nam|"),
        ], toSection: .editLocation)
        if let locationResults = locationResults {
            snapshot.appendItems(locationResults, toSection: .editLocation)
        }
        snapshot.appendItems([
            .header(Section.map.name),
            .map
        ], toSection: .map)
        snapshot.appendItems([
            .header(Section.delete.name),
            .deleteButton
        ], toSection: .delete)
        dataSource.apply(snapshot, animatingDifferences: animated)
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
