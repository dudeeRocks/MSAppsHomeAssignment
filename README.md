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

