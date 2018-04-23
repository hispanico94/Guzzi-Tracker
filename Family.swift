import UIKit

struct Family {
    let families: [String]
    var selectedFamilies: [String] = []
    let title = "Families"
    private var caption: String {
        let n = selectedFamilies.count
        if n > 1 {
            return "\(n) families selected"
        } else if n == 1 {
            return "1 family selected"
        } else {
            return ""
        }
    }
    
    init(motorcycleList: [Motorcycle]?) {
        guard let unwrapMotorcycleList = motorcycleList else {
            self.families = []
            return
        }
        self.families = MotorcycleElements.families(unwrapMotorcycleList)
    }
}

extension Family: FilterProvider {
    var filterId: FilterId {
        return .families
    }
    
    func getViewController(_ callback: @escaping (FilterProvider) -> ()) -> UIViewController {
        return FamilyFilterViewController(filter: self, callback: callback)
    }
    
    func getFilter() -> Filter {
        return Filter(id: self.filterId,
                      title: self.title,
                      caption: self.caption,
                      predicate: { motorcycle in
                        guard !self.selectedFamilies.isEmpty else { return true }
                        guard let family = motorcycle.generalInfo.family else { return false }
                        return self.selectedFamilies.contains(family)
        })
    }
}
