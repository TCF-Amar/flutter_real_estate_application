# 🏠 real_estate_app

A modern, high-performance real estate application built with Flutter, designed to provide a seamless property discovery and booking experience.

---

## 🚀 Key Features

### 🔍 Property Discovery
- **Dynamic Home Screen**: Featured properties, top developers, and curated categories.
- **Advanced Search & Filter**: Find properties based on location, price range, property type, and more.
- **Explore Mode**: Map-based and list-based discovery of trending real estate.

### 🏢 Property Details
- **Premium UI**: Modular property details page using Slivers for smooth scrolling and dynamic headers.
- **Virtual Tours**: Immersive 360° panorama views and high-quality video walkthroughs.
- **Map Integration**: Real-time location previews and nearby amenity information.
- **Ratings & Reviews**: Transparent user feedback system with detailed rating metrics.

### 📅 Booking & Site Visits
- **Site Visit Management**: Easy booking flow for property visits with real-time status updates (Confirmed, Pending, Cancelled).
- **Modular Visit Details**: Detailed breakdown of visit information, property summary, and visitor profiles.
- **Interactive Feedback**: Leave reviews and ratings directly after a completed site visit.

### 👤 User Experience
- **Favorites & Saved**: Keep track of your dream properties in a dedicated wishlist.
- **Secure Authentication**: Robust user login and profile management.
- **Premium Design**: Modern aesthetics using Glassmorphism, smooth animations, and curated color palettes.

---

## 🛠️ Tech Stack & Architecture

### **Core Framework**
- **Flutter**: Cross-platform development using Material 3 UI.

### **State Management & Routing**
- **GetX**: High-performance state management, dependency injection, and intuitive navigation.

### **Networking & Data**
- **Dio**: Powerful HTTP client for efficient API communication.
- **JSON Serializable**: Robust data parsing and serialization.
- **Dartz**: Implementation of functional patterns (Either) for predictable error handling.

### **UI & Animations**
- **Slivers**: Advanced scroll effects and optimized lists.
- **Shimmer**: Elegant loading states for a premium feel.
- **Flutter SVG**: High-quality vector icons and illustrations.

### **Media & Utilities**
- **Panorama Viewer**: Immersive 360° property views.
- **Chewie & Video Player**: Integrated smooth video playback.
- **Geolocator**: Real-time location services for property discovery.

---

## 🏗️ Project Structure

The project follows a **Feature-First Architecture** for maximum scalability and maintainability:

```text
lib/
├── core/               # App-wide constants, themes, services, and utilities
├── features/           # Modular feature folders
│   ├── auth/          # Authentication & Onboarding
│   ├── home/          # Main dashboard & discovery
│   ├── property/      # Property listings & details
│   ├── my_booking/    # Site visits & booking management
│   ├── search/        # Advanced search functionality
│   └── shared/        # Reusable feature-specific widgets
└── main.dart          # Entry point and app initialization
```

---

## 🛠️ Getting Started

### Prerequisites
- Flutter SDK (^3.10.4)
- Dart SDK
- Android Studio / VS Code

### Installation
1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-repo/real_estate_app.git
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the application:**
    ```bash
    flutter run
    ```

---

## 🤝 Contributions

Developed by **Amarjeet Mistri**. Feel free to reach out for collaborations or feedback!

---

_This project is continuously evolving. Stay tuned for more features! 🚀_
