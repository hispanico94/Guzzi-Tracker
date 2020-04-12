import Foundation

/// Handles the initialization and update of the models (motorcycles and filters)
/// when the app is launched and the JSON stored in the app's library directory,
/// or downloaded from the remote, is parsed.
final class MotorcycleData {
    
    private let dataManager: DataManager
    
    private var jsonFile: JsonFile? {
        didSet {
            let motorcycles: [Motorcycle] = jsonFile?.getMotorcycleList() ?? []
            
            self.motorcycleStorage.value = motorcycles
            
            let filters = self.dataManager.getFilters(fromMotorcycles: motorcycles)
            self.filterStorage.value = filters
            self.originalFilters = filters
        }
    }
    
    /// Storage of the array containing the motorcycles extracted from the JSON.
    /// The parsing of a new JSON updates the value of this storage
    let motorcycleStorage: Ref<Array<Motorcycle>>
    
    /// Filters made from the motorcycles extracted from the JSON. This parameter
    /// is modified only by this class when a new JSON is parsed.
    private(set) var originalFilters: [FilterProvider]
    
    /// Storage of the filters made from the motorcycles extracted from the JSON.
    /// The filters in this storage are modified by FiltersViewController and it's
    /// used for passing filters to MotorcyclesViewController. The parsing of a new
    /// JSON updates (and in fact resets) the filters stored in this storage.
    let filterStorage: Ref<Array<FilterProvider>>
    
    /// Storage of the orders applied to the motorcycles in MotorcyclesViewController.
    /// Orders are added and removed in this storage by FiltersViewController and it's
    /// used for passing orders to MotorcyclesViewController
    let orderStorage: Ref<Array<Order>>
    
    /// Save the bundle's info_moto.json in the library directory if it doesn't already exists.
    init() {
        self.dataManager = DataManager()
        self.dataManager.saveBundleJsonToLibrary()
        
        self.jsonFile = self.dataManager.getJsonFileFromLibrary()
        
        let motorcycles: [Motorcycle] = self.jsonFile?.getMotorcycleList() ?? []
        
        self.motorcycleStorage = Ref<Array<Motorcycle>>.init(motorcycles)
        
        let filters = self.dataManager.getFilters(fromMotorcycles: motorcycles)
        self.originalFilters = filters
        self.filterStorage = Ref<Array<FilterProvider>>.init(filters)
        
        self.orderStorage = Ref<Array<Order>>.init([MotorcycleOrder.yearDescending])
    }
    
    func updateJson() {
        DispatchQueue.global().async { [weak self] in
            if let updatedJson = self?.dataManager.checkForUpdatedJson(currentVersion: self?.jsonFile?.version ?? 0) {
                DispatchQueue.main.async { [weak self] in
                    self?.jsonFile = updatedJson
                    
                }
            }
        }
    }
}

/// Handles the read, write, download from the remote, and parsing of the JSON
/// containing the data of the motorcycles.
/// This class works paired with the MotorcycleData class.
fileprivate struct DataManager {
    
    private let fileName = "info_moto"
    private let fileExtension = "json"
    private var fileNameWithExtension: String {
        return fileName + "." + fileExtension
    }
    
    private let remoteJsonUrl = "https://raw.githubusercontent.com/hispanico94/Guzzi-Tracker/master/Guzzi%20Tracker/info_moto.json"
    
    /// Save the bundle's info_moto.json in the library directory if it doesn't already exists.
    func saveBundleJsonToLibrary() {
        let libraryUrls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        let infoMotoJsonUrl = libraryUrls.first!.appendingPathComponent(self.fileNameWithExtension)
        
        let jsonBundleUrl = Bundle.main.url(forResource: self.fileName, withExtension: self.fileExtension)
        let jsonData = try! Data(contentsOf: jsonBundleUrl!)
        
        if !FileManager().fileExists(atPath: infoMotoJsonUrl.path) {
            try! jsonData.write(to: infoMotoJsonUrl, options: .atomic)
        }
    }
    
    /// Creates and returns a JsonFile (containing json version, motorcycle list and localized texts) from the json in the library directory
    /// - returns: a JsonFile containing file version, an array of Motorcycle and a dictionary [String: Texts], nil if the data acquisition or the parsing fail
    func getJsonFileFromLibrary() -> JsonFile? {
        let libraryUrls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        guard
            let url = libraryUrls.first?.appendingPathComponent(self.fileNameWithExtension),
            let jsonData = try? Data(contentsOf: url)
            else {
                print("An error occurred while reading the \(self.fileNameWithExtension) in the local library")
                return nil
        }
        return getJsonFile(fromData: jsonData)
    }
    
    /// Creates and returns an array containing the filter providers for the given list of motorcycles
    /// - parameter motorcycles: the list of motorcycles on which to create the filters
    /// - returns: the list of FilteProviders
    func getFilters(fromMotorcycles motorcycles: [Motorcycle]) -> [FilterProvider] {
        return [MinMaxYear(),
                Family(motorcycleList: motorcycles),
                Weight(motorcycleList: motorcycles),
                Displacement(motorcycleList: motorcycles),
                Bore(motorcycleList: motorcycles),
                Stroke(motorcycleList: motorcycles),
                Power(motorcycleList: motorcycles),
                Wheelbase(motorcycleList: motorcycles),
                StrokeCycle()]
    }
    
    /// Downloads the online json and checks if it is a newer version compared to the current version.
    /// If it's newer it saves the new json in the library directory and returns the JsonFile of the newer version.
    /// - parameter version: the current version saved in the library directory
    /// - returns: the `JsonFile` of the newer version if present, nil if a newer version was not found or if data acquision
    /// or the parsing fails
    func checkForUpdatedJson(currentVersion version: Int) -> JsonFile? {
        guard
            let url = URL(string: self.remoteJsonUrl),
            let jsonData = try? Data(contentsOf: url)
            else {
                print("An error occurred while generating the URL or retrieving the data (DataManager.checkForUpdateJson(version:))")
                return nil
        }
        
        guard let jsonFile = getJsonFile(fromData: jsonData) else { return nil }
        
        if jsonFile.version > version {
            let libraryUrls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
            let infoMotoJsonUrl = libraryUrls.first!.appendingPathComponent(self.fileNameWithExtension)
            try? jsonData.write(to: infoMotoJsonUrl, options: .atomic)
            
            return jsonFile
        }
        return nil
    }
    
    /// Creates and returns a JsonFile (containing json version and motorcycle list) from a Data object
    /// - parameter data: the data from which extract the JsonFile
    /// - returns: a JsonFile containing file version and an array of MotorcycleJson, nil if the data acquisition or the parsing fail
    private func getJsonFile(fromData data: Data) -> JsonFile? {
        var result: JsonFile? = nil
        
        do {
            result = try JSONDecoder().decode(JsonFile.self, from: data)
        } catch let error {
            print("An error occurred while decoding json in DataManager.getJsonFile(data:)")
            print(error)
        }
        
        return result
    }
}

func getFoundationYear() -> Int { return 1921 }
func getCurrentYear() -> Int { return Calendar(identifier: .gregorian).component(.year, from: Date()) }
