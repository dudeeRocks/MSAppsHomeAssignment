<p align="center">
    <img src="Images/01_icon+logo.png" alt="Notes logo" width="600" />
</p>

# Home Assignment Project

Home assignment project for iOS Developer role.

## Task

Create a notes app with ability to view notes on the map, fetch and store data from web API, and basic login.

## Overview

- Interface: **UIKit**
- Layout: **Main.storyboard**
- Persistent storage: **Core Data**
- Login: **UserDefaults**

## App Structure

App navigation is layed out in *Main.storyboard* with behaviors provided by custom view controllers. View controllers fetch data with the help of shared `CoreDataStack` object that handles data in `DataModel` on their behalf. All web API calls are managed by singleton `WebAPICaller` object. `LocationManager` class serves as a single point of access to user location for UI that displays a map. Login and registration logic is defined within `AuthManager`.

<img src="Images/02_app_structure_diagram.png" alt="Notes app structure diagram" />

## Data Structure

The app relies on Core Data for persistent storage. There are two main entities supported by two related lesser entities: `UserEntity` with `UserAvatar` and `Note` with `NoteLocation`.

### Users

User data is defined as `UserEntity` with `UserAvatar` representing cached data image.

<img src="Images/03_users_data.png" alt="Users data diagram" height="400" />

On first app launch the users data is fetched by `WebAPICaller` that decodes JSON into `User` objects, which are then used by `CoreDataStack` to create `UserEntity` for every fetched `User`.

```swift
let users = try await WebAPICaller.shared.fetchUsers()
            
try await persistentContainer.performBackgroundTask { context in
    try users.forEach { user in
        try self.saveUserEntity(for: user, in: context)
    }
}
```

The images for user avatars are fetched as necessary when user scrolls the users list. The images are then cached as `UserAvatar` entities and attached to corresponding `UserEntity`.

```swift
extension UIImageView {
    func loadImage(for user: UserEntity) {
        self.image = UIImage(systemName: "person.fill")
        
        if let avatar = user.image, let imageData = avatar.imageData, let image = UIImage(data: imageData) {
            self.image = image
        } else {
            Task(priority: .high) {
                do {
                    let data = try await WebAPICaller.shared.fetchImage(for: user)
                    self.image = UIImage(data: data)
                    try CoreDataStack.shared.saveUserAvatar(for: user, data: data)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
```

### Notes

Note data is described as `Note` entity with `NoteLocation` entity defining the location of the note on map. 

<img src="Images/04_notes_data.png" alt="Notes data diagram" height="400" />

`Note` entities are created by the user in `NoteDetailsController` view controller on save action. `NoteLocation` entities are created automatically during `Note` creation.

```swift
func createNote(withText body: String, at coordinates: CLLocationCoordinate2D, locationName: String, date: Date) throws {
    let context = viewContext
    
    let location = NoteLocation(context: context)
    location.latitude = coordinates.latitude
    location.longitude = coordinates.longitude
    location.displayName = locationName
    
    let note = Note(context: context)
    note.body = body
    note.dateModified = date
    note.location = location
    
    location.note = note
    
    do {
        try context.save()
    } catch {
        throw CoreDataError(kind: .noteSave, note: note)
    }
}
```

## User Interface

The app's navigation is layed out in *Main.storyboard* with custom view controllers providing behaviors.

### Login: `LoginViewController`

<img src="Images/05_login_screen.png" alt="Login screen" height="600" />

Login and registration UI is managed by `LoginViewController` that uses `AuthManager` to model authentication logic. For simplicity, this home assignment project uses `UserDefaults` to store registered user credantials.

The `SceneDelegate` determines whether to show the login screen on app launch.

```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let _ = (scene as? UIWindowScene) else { return }
        
    if AuthManager.isLoggedIn {
        window?.rootViewController = .getViewController(withIdentifier: .main)
    } else {
        window?.rootViewController = .getViewController(withIdentifier: .login)
    }
}
```

### Notes List: `NotesListController`

<img src="Images/06_notes_list.png" alt="Notes list screen" height="600" />

Because notes are a dynamic user-generated data they’re displayed using `UITableViewController` with `UITableViewDiffableDataSource` for dynamic list updates. Empty state is shown when notes list is empty.

`NotesListController` view controller serves as a `NoteDetailsDelegate` delegate for `NoteDetailsController` in order to update notes list if a new note was created or an existing note was deleted from note details screen.

```swift
extension NotesListController: NoteDetailsDelegate {
    func didUpdateNote() {
        updateNotesList()
        checkIfNotesExist()
    }
}
```

### Note Details: `NoteDetailsController`

<img src="Images/07_note_details.png" alt="Note details screen" height="600" />

Note details screen is implemented as `UICollectionViewController` and utilizes `UICollectionViewDiffableDataSource` for dynamic switching between note editing and viewing modes, and for location search results fetching during editing.

```swift
func updateUI(for updateCase: UpdateCase, animated: Bool = true) {
    updateNavigationBar(for: updateCase)
    switch updateCase {
    case .view:
        isEditing = false
        updateSnapshotForViewing(animated: animated)
    case .edit:
        isEditing = true
        updateSnapshotForEditing(animated: animated)
    case .searchResults(let results):
        updateSnapshotWithSearchResults(results, animated: animated)
    }
}
```

Most cells are defined as custom views using `UIContentView` protocol. Some custom cells accept completion handlers during cell configuration, which are used by `NoteDetailsController` to communicate between cells.

```swift
func mapConfiguration(cell: UICollectionViewListCell) {
    var content = cell.mapConfiguration()
    content.location = note?.location
    content.onLocationUpdate = { coordinate, locationName in
        self.newLocation = coordinate
        self.newLocationName = locationName
    }
    cell.contentConfiguration = content
}
```

When a note is saved or deleted, `NoteDetailsController` calls `didUpdateNote()` method on its `NoteDetailsDelegate`, that depends on which view controller has presented the `NoteDetailsController`.

```swift
CoreDataStack.shared.saveViewContext()
delegate?.didUpdateNote()
updateUI(for: .view)
```





