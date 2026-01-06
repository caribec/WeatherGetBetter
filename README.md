# WeatherGetBetter ☀️🌧️

WeatherGetBetter is an iOS weather application built with **SwiftUI** that provides users with clear, accessible, and visually engaging weather information. The app focuses on simplicity, real-time data, and intuitive navigation while showcasing modern iOS development practices.

---

## 📱 Features

* 🔍 **City Search** using Open-Meteo Geocoding API
* ❤️ **Favorites System** to save frequently viewed locations
* 🌡️ **Current Weather Conditions** (temperature, precipitation, wind, humidity)
* ⏰ **Hourly Forecast View** with interactive charts
* 📅 **7-Day Forecast** with weather icons and daily highs/lows
* 🧭 **Seamless Navigation** using TabView and NavigationStack
* 💾 **Persistent Favorites** using UserDefaults

---
## 📸 Screenshots

<p align="center">
  <img src="WeatherGetBetter/screenshots/Home.png" width="200"/>

</p>


## 🛠️ Technologies Used

* **Swift & SwiftUI** – UI development and state management
* **Combine** – Data flow and API updates
* **Open-Meteo APIs** – Weather and geolocation data
* **SF Symbols** – Dynamic weather icons
* **UserDefaults** – Persistent storage for favorites
* **MVVM-inspired architecture** – Clean separation of concerns

---

## 🧩 Architecture Overview

* **Models**: `WeatherRecord`, `GeolocationRecord`, `DailyWeatherResult`
* **ViewModels / Services**: `WeatherAPI`, `GeolocationAPI`
* **Views**:

  * `StartupView` – Entry point with search
  * `HomeView` – Current conditions overview
  * `HourlyDetailView` – Hourly chart and metrics
  * `DailyForecastView` – 7-day forecast
  * `FavoritesView` – Saved locations
* **Shared State**:

  * `FavoritesStore` – Manages saved locations
  * `AppSelectionManager` – Tracks selected city and active tab

---

## 🔗 APIs Used

* **Open-Meteo Geocoding API** – Converts city names into coordinates
* **Open-Meteo Weather Forecast API** – Provides hourly and daily weather data

All data is fetched dynamically and decoded using Swift’s `Decodable` protocol.

---

## 🎨 Design Goals

* Minimal, clean interface focused on readability
* Clear visual hierarchy for weather data
* Smooth transitions between views
* Accessibility-friendly font sizes and color contrast

---

## 🚀 Getting Started

1. Clone the repository
2. Open `WeatherGetBetter.xcodeproj` in Xcode
3. Select an iOS Simulator or physical device
4. Build and run the project

No API keys are required.

---

## 📌 Future Enhancements

* Dynamic background based on weather or time of day
* Weather alerts and notifications

---

## 👩‍💻 Author

**Carissa Becerra**
Computer Science Graduate – Software Design
University of Houston

**Alejandro Galvez**
Computer Science Graduate
University of Houston

---

