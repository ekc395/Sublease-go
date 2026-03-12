# Sublease-go

Sublease-go is an iOS application built with SwiftUI that helps UW students find and post short-term subleases. The app allows verified university users to browse available listings, post their own listings, and communicate with other users through an in-app messaging system. This project was built as part of a class project and demonstrates the use of modern iOS development tools, including SwiftUI, Firebase, and real-time database integration.

## Features

### Browse Listings
- View available sublease listings in a feed
- Listings show key information such as:
  - Title
  - Price
  - Number of bedrooms
  - Apartment/building
  - Furnished status
  - Description

### Filters
- Users can filter listings by:
  - Maximum price
  - Minimum number of bedrooms
  - Furnished only

### Create Listings
- Users can post their own sublease listing which includes:
  - Title
  - Price
  - Bedrooms
  - Apartment/building
  - Furnished status
  - Description
- After posting, the listing appears in the main feed automatically.

### Messaging
- Users can message listing owners directly
- Conversations are organized into message threads
- Threads update in real time

### Profile
- Each user has a profile page showing:
  - Verified UW email
  - Listings posted by that user
  - Ability to delete listings
  - Sign out functionality

## Tech Stack

### Frontend
- Swift
- SwiftUI
- NavigationStack and TabView for navigation

### Backend
- Firebase Firestore (database)
- Firebase Authentication

### Architecture
- Service layer for Firebase communication
- FirebaseListingsService
- FirebaseMessagingService

Project Structure
sublease-go/
│
├── Models
│   ├── Listing.swift
│   └── Thread.swift
│
├── Services
│   ├── AuthManager.swift
│   ├── FirebaseListingService.swift
│   └── FirebaseMessagingService.swift
│
├── UIComponents
│   └── (Reusable UI components)
│
├── Views
│   ├── ChatThreadView.swift
│   ├── ContentView.swift
│   ├── CreateListingView.swift
│   ├── FiltersView.swift
│   ├── HomeView.swift
│   ├── ListingDetailView.swift
│   ├── ListingFeedView.swift
│   ├── LoginView.swift
│   ├── MainTabView.swift
│   ├── MessagesView.swift
│   └── ProfileView.swift
│
├── Assets.xcassets
├── GoogleService-Info.plist
└── sublease-goApp.swift
