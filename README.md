
* * * * *

WeatherAppSwiftUI
=================

Welcome to **WeatherAppSwiftUI**! This SwiftUI application offers a clean, intuitive interface for checking current weather conditions, viewing forecasts, and managing your favorite weather locations.

Features
--------

-   **Current Weather**: Get up-to-date weather information for your current location or any location you specify.
-   **5-Day Forecast**: View a forecast for the next five days to plan ahead.
-   **Detailed Daily View**: Click on any day's forecast to see detailed weather data, including hourly forecasts.
-   **Favorites Management**:
    -   **Save Favorites**: Easily save locations you frequently check.
    -   **View Favorites**: Quickly access weather information for your saved locations.
    -   **Delete Favorites**: Remove locations from your favorites list when no longer needed.

* * * * *

Project Structure
-----------------

The project is organized into the following directories:

### **Extensions**

Custom extensions for Swift and SwiftUI to enhance functionality.

### **Views**

Contains all the SwiftUI view files for different screens and components of the app.

-   **HomeContentView.swift**: Main view displaying current weather and forecast.
-   **DetailedWeatherView.swift**: Displays detailed weather information for a selected day.
-   **FavoritesListView.swift**: Shows a list of saved favorite locations.

### **Resources**

Houses assets like images, icons, and other static resources.

### **Models**

Data models for weather data structures.

-   **CurrentWeatherModel.swift**
-   **ForecastListModel.swift**
-   **HourlyWeatherModel.swift**

### **ViewModels**

Handles the logic and data for each view.

-   **WeatherViewModel.swift**: Manages weather data for the main and detailed views.

### **Networking**

Contains network-related code for API calls.

-   **NetworkManager.swift**: Manages network requests to fetch weather data.

### **Tests**

Contains UI tests to ensure the app's interface functions as expected.

-   **WeatherAppSwiftUIUITests.swift**

* * * * *

Getting Started
---------------

### Prerequisites

-   Xcode 13 or later
-   iOS 14.0 or later

### Installation

1.  Clone the repository:\
    `git clone [repository-url]`

2.  Navigate to the project directory:\
    `cd WeatherAppSwiftUI`

3.  Open the project in Xcode:\
    `open WeatherAppSwiftUI.xcodeproj`

4.  Run the app:

    -   Select an iOS simulator or connect a physical device.
    -   Press the **Run** button (or use `Cmd + R`).

* * * * *

Usage
-----

-   **Current Weather**: Upon launching, the app automatically uses your device's location to display the current weather. You can also manually enter or search for other locations.
-   **5-Day Forecast**: Scroll down to see the 5-day forecast. Tap on any day to view more detailed information.
-   **Detailed View**: View hourly breakdowns of weather conditions for the selected day.
-   **Favorites**:
    -   **Add to Favorites**: In the current weather or forecast view, there's an option to save the location to your favorites.
    -   **View Favorites**: Access your favorites through the settings menu or a dedicated tab.
    -   **Delete from Favorites**: Remove locations from the favorites list by swiping to delete.

* * * * *

Testing
-------

This project includes UI tests in `WeatherAppSwiftUIUITests`. To run these tests:

-   Navigate to **Product > Test** or use `Cmd + U`.

* * * * *

Screenshots
-----------

<img src="https://github.com/user-attachments/assets/0f2c50f4-7f75-42ed-bdd4-edd01ae09a51" alt="loading" width="200"/>
<img src="https://github.com/user-attachments/assets/a4fed63b-3d03-4197-90dd-da5ae2e9e3d6" alt="home" width="200"/>
<img src="https://github.com/user-attachments/assets/eeaa2f99-6e37-4054-9dff-b1981adfb673" alt="home_menu" width="200"/>
<img src="https://github.com/user-attachments/assets/7307fddf-4d26-4a9d-9dc7-ad565738dc40" alt="detailed" width="200"/><br>

* * * * *

Contributing
------------

Contributions are welcome! Please feel free to fork the project, make your changes, and submit a pull request. Here are some guidelines:

-   Follow SwiftUI best practices.
-   Write clear, concise code with comments where necessary.
-   Add unit or UI tests for new features or significant changes.

* * * * *

License
-------

This project is open-sourced under the **MIT License**.

* * * * *

*Happy coding, and enjoy forecasting with WeatherAppSwiftUI! If you encounter any issues or have suggestions, feel free to open an issue or submit a pull request.*

* * * * *
