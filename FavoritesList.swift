import Foundation

public final class FavoritesList {
    static let sharedFavoritesList = FavoritesList()
    private(set) var favorites: [Int]
    
    init() {
        let defaults = UserDefaults.standard
        let storedFavorites = defaults.object(forKey: "favorites") as? [Int]
        favorites = storedFavorites != nil ? storedFavorites! : []
    }
    
    func add(_ favorite: Int) {
        if !favorites.contains(favorite) {
            favorites.append(favorite)
            saveFavorites()
        }
    }
    
    func remove(_ favorite: Int) {
        if let index = favorites.index(of: favorite) {
            favorites.remove(at: index)
            saveFavorites()
        }
    }
    
    func contains(_ favorite: Int) -> Bool {
        return favorites.contains(favorite)
    }
    
    func swapAt(_ firstIndex: Int, _ secondIndex: Int) {
        favorites.swapAt(firstIndex, secondIndex)
        saveFavorites()
    }
    
    private func saveFavorites() {
        let defaults = UserDefaults.standard
        defaults.set(favorites, forKey: "favorites")
    }
}
