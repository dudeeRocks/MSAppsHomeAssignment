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

<p align="center">
    <img src="Images/02_app_structure_diagram.png" alt="Notes app structure" />
</p>

## Data Structure

The app relies on Core Data for persistent storage. There are two main entities supported by two related lesser entities: `UserEntity` with `UserAvatar` and `Note` with `NoteLocation`.

### Users

User data is defined as `UserEntity` with `UserAvatar` representing cached data image.

<p align="center">
    <img src="Images/03_users_data.png" alt="Notes app structure" width="600" />
</p>

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
