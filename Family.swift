import UIKit

struct Family {
    let families: [String]
    var selectedFamilies: [String] = []
    let title = NSLocalizedString("Families", comment: "Families (of motorcycles)")
    private var caption: String {
        let n = selectedFamilies.count
        if n >= 1 {
            let formatString = NSLocalizedString("%d families selected", comment: "%d families selected (%d >= 1, adjust 'families' and 'selected' accordingly)")
            return String.localizedStringWithFormat(formatString, n)
        }
        return ""
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
