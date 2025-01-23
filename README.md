# WeatherAppSwiftUI

Welcome to the WeatherAppSwiftUI! This SwiftUI application provides a clean, intuitive interface
for checking current weather conditions, viewing forecasts, and managing your favorite weather
locations.Features

*   **Current Weather**: Get up-to-date weather information for your current location or any location you specify.
    
*   **5-Day Forecast**: View a forecast for the next five days, helping you plan ahead.
    
*   **Detailed Daily View**: Click on any day's forecast for a more detailed view including hourly forecasts.
    
*   **Favorites Management**:
    
    *   **Save Favorites**: Easily save locations you frequently check as favorites.
        
    *   **View Favorites**: Quickly access weather information for your saved locations.
        
    *   **Delete Favorites**: Remove locations from your favorites list when no longer needed.
        

## Project Structure: The project is organized into the following directories:

*   **Extensions**: Custom extensions for Swift and SwiftUI to enhance functionality.
    
*   **Views**: Contains all the SwiftUI view files for different screens and components of the app.
    
    *   HomeContentView.swift - Main view where users see current weather and forecast.
        
    *   DetailedWeatherView.swift - Shows detailed weather information for a selected day.
        
    *   FavoritesListView.swift - Displays a list of saved favorite locations.
        
*   **Resources**: Houses assets like images, icons, and any other static resources used in the app.
    
*   **Models**: Data models for weather data structures.
    
    *   CurrentWeatherModel.swift, ForecastListModel.swift, HourlyWeatherModel.swift, etc.
        
*   **ViewModels**: View models handle the logic and data for each view.
    
    *   WeatherViewModel.swift - Manages weather data for the main view and detailed views.
        
*   **Networking**: Contains network-related code for API calls.
    
    *   NetworkManager.swift - Manages network requests to fetch weather data.
        
*   **Tests**:
    
    *   WeatherAppSwiftUIUITests.swift - UI tests to ensure the app's interface functions as expected.
        

## Getting Started

**Prerequisites**

*   Xcode 13 or later
    
*   iOS 14.0 or later
    

**Installation**

1.  git clone \[repository-url\]cd WeatherAppSwiftUI
    
2.  **Open the project in Xcode:**
    
    *   Open WeatherAppSwiftUI.xcodeproj with Xcode.
        
3.  **Run the app:**
    
    *   Select an iOS simulator or connect a physical device.
        
    *   Press the run button or use Cmd + R.
        

**Usage**

*   **Current Weather**: Upon launching, the app uses your device's location to show current weather. You can also manually enter or search for other locations.
    
*   **Forecast**: Swipe or scroll down to see the 5-day forecast. Clicking on any day will open the detailed view.
    
*   **Detailed View**: Here, you'll see the hourly breakdown of weather conditions for the selected day.
    
*   **Favorites**:
    
    *   **Add to Favorites**: In the header of the current weather or forecast view, there's an option to save the current location to favorites.
        
    *   **View Favorites**: Access through the settings menu or a dedicated tab if implemented.
        
    *   **Delete from Favorites**: In the favorites list, you can delete entries.
        

**Testing**

*   The project includes UI tests in WeatherAppSwiftUIUITests. To run these:
    
    *   Navigate to **Product > Test** or use Cmd + U.
        

**Contributing**Contributions are welcome! Please feel free to fork the project, make your changes, and submit a pull request. Here are some guidelines:

*   Use SwiftUI best practices.
    
*   Write clear, concise code with comments where necessary.
    
*   Add unit or UI tests for new features or significant changes.
    

**License**This project is open-sourced under the MIT License (LICENSE.md).Happy coding, and enjoy forecasting with WeatherAppSwiftUI! If you encounter any issues or have suggestions, feel free to open an issue or submit a pull request.
