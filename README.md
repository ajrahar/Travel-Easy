# TravelEasy 🇮🇩

A SwiftUI iOS app for discovering and exploring travel destinations across Indonesia.

## Features

- **Splash screen** — Brief intro before the main app
- **Authentication** — Simple auth flow with persistence via `@AppStorage`
- **Home** — Carousel of featured destinations, featured list, and popular experiences
- **Explore** — Browse destinations and regions
- **Favorites** — Save and view favorite places
- **Profile** — User profile section

## Destinations (sample data)

- **Bali** — Island of the Gods: beaches, temples, culture
- **Yogyakarta** — Cultural heart of Java (Borobudur, Prambanan)
- **Raja Ampat** — Diving and pristine reefs
- **Komodo** — Komodo dragon, pink beaches, island landscapes

## Requirements

- **Xcode** 15+ (or latest supporting your deployment target)
- **iOS** 17+ (or as set in the project)
- **Swift** 5.9+

## Getting started

1. Clone the repo:
   ```bash
   git clone <repository-url>
   cd traveleasy
   ```
2. Open the project in Xcode:
   ```bash
   open traveleasy.xcodeproj
   ```
3. Select a simulator or device and run (⌘R).

## Project structure

```
traveleasy/
├── traveleasyApp.swift      # App entry point
├── ContentView.swift        # Root: splash → auth → tab bar
├── SplashView.swift
├── AuthView.swift
├── HomeView.swift
├── ExploreView.swift
├── FavoritesView.swift
├── ProfileView.swift
├── Destination.swift        # Destination model & sample data
├── DestinationRow.swift
├── DestinationDetailView.swift
├── RegionDetailView.swift
├── ExperienceRow.swift
└── Assets.xcassets/
```

## License

Private / All rights reserved.
