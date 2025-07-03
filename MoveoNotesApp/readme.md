# Moveo Notes App

A location note-taking app built with SwiftUI and The Composable Architecture (TCA), featuring Firebase authentication and real-time data sync.

## Features

- 🔐 **Authentication**: Sign in/Sign up with Firebase Auth
- 📝 **Note Management**: Create, edit, delete, and search notes
- 📍 **Location Integration**: Automatic location tagging for notes
- 🗺️ **Map View**: Visualize notes on an interactive map
- 🔍 **Search**: Find notes by title or content
- ☁️ **Cloud Sync**: Real-time data synchronization with Firestore

## Setup Instructions

### Prerequisites

- Xcode 16.0+
- iOS 17.0+
- Firebase project with Authentication and Firestore enabled

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd MoveoNotesApp
   ```

2. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Enable Authentication (Email/Password provider)
   - Enable Firestore Database
   - Download `GoogleService-Info.plist` and add it to your Xcode project

3. **Install Dependencies**
   - Open `MoveoNotesApp.xcodeproj` in Xcode
   - Firebase SDK is integrated via Swift Package Manager
   - Build and run the project

4. **Location Permissions**
   - The app requests location permission for note tagging
   - Grant location access when prompted for full functionality

## Architecture Overview

### The Composable Architecture (TCA)

This app follows TCA principles for predictable state management:

- **State**: Immutable data structures representing app state
- **Actions**: Events that can happen in the app
- **Reducers**: Pure functions that evolve state based on actions
- **Effects**: Handle side effects like API calls

### Project Structure

```
MoveoNotesApp/
├── App/
│   ├── MoveoNotesAppApp.swift      # App entry point
│   ├── RootReducer.swift            
│   └── RootView.swift               
├── Features/
│   ├── Authentication/
│   │   ├── AuthenticationFeature.swift
│   │   └── AuthenticationView.swift
│   ├── Welcome/
│   │   ├── WelcomeFeature.swift
│   │   └── WelcomeView.swift
│   ├── NotesList/
│   │   ├── NotesListFeature.swift
│   │   ├── NotesListView.swift
│   │   └── Components/
│   ├── EditNote/
│   │   ├── EditNoteFeature.swift
│   │   └── EditNoteView.swift
│   └── NotesMap/
│       ├── NotesMapFeature.swift
│       └── NotesMapView.swift
├── Models/
│   └── Note.swift                  # Core data model
├── Clients/
│   ├── AuthenticationClient.swift  # Firebase Auth wrapper
│   ├── NotesClient.swift          # Firestore operations
│   └── LocationClient.swift       # Core Location wrapper
└── Helpers/
    ├── Helpers.swift              # Utility extensions
    └── MNLocationManager.swift    # Location manager
```

## Key Architecture Decisions

### 1. Feature-Based Organization
Each major feature (Authentication, Notes List, etc.) is self-contained with its own:
- Feature reducer handling business logic
- SwiftUI view for presentation
- Associated actions and state

### 2. Client Pattern for External Dependencies
External services are wrapped in client protocols:
- `AuthenticationClient`: Firebase Auth operations
- `NotesClient`: Firestore CRUD operations  
- `LocationClient`: Core Location services

### 3. Location Integration
- Automatic location capture when creating notes
- Custom `MNLocationManager` for async location handling
- `EquatableCoordinate` wrapper for TCA compatibility

### 4. Error Handling
- Centralized error handling through action results
- User-friendly error messages
- Graceful fallbacks for location and network issues


## Future Enhancements

- [ ] Image attachments
- [ ] Offline support
- [ ] Focus state
- [ ] Landscape support
- [ ] Center map on last note
- [ ] More Error Handling


