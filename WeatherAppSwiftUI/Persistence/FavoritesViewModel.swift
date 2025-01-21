//
//  FavoritesViewModel.swift
//  WeatherAppSwiftUI
//
//  Created by Kevin on 20/01/2025.
//

import Combine
import CoreLocation
import CoreData

// Assuming you have these entities in your CoreData model
@objc(FavoriteLocation)
public class FavoriteLocation: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var lastUpdated: Date?
}

class FavoritesViewModel: ObservableObject {
    @Published var favorites: [FavoriteLocation] = []
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchFavorites()
    }
    
    func fetchFavorites() {
//        let fetchRequest: NSFetchRequest<FavoriteLocation> = FavoriteLocation.fetchRequest()
//        do {
//            favorites = try context.fetch(fetchRequest)
//        } catch {
//            print("Failed to fetch favorites: \(error)")
//        }
    }
    
    func addFavorite(name: String, coordinates: CLLocationCoordinate2D) {
        let newFavorite = FavoriteLocation(context: context)
        newFavorite.name = name
        newFavorite.latitude = coordinates.latitude
        newFavorite.longitude = coordinates.longitude
        newFavorite.lastUpdated = Date()
        
        do {
            try context.save()
            fetchFavorites()
        } catch {
            print("Failed saving favorite: \(error)")
        }
    }
    
    func removeFavorite(_ location: FavoriteLocation) {
        context.delete(location)
        do {
            try context.save()
            fetchFavorites()
        } catch {
            print("Failed deleting favorite: \(error)")
        }
    }
}
