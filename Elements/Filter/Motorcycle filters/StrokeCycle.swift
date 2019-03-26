import UIKit

struct StrokeCycle {
    var selectedStrokeCycle: Motorcycle.Engine.StrokeCycle? = nil
    let title = NSLocalizedString("Stroke cycle", comment: "Engine Stroke cycle")
    private var caption: String {
        guard let selected = selectedStrokeCycle else { return "" }
        switch selected {
        case .twoStroke:
            return NSLocalizedString("2-stroke", comment: "2-stroke (engine)")
        case .fourStroke:
            return NSLocalizedString("4-stroke", comment: "4-stroke (engine)")
        }
    }
}

extension StrokeCycle: FilterProvider {
    var filterId: FilterId {
        return .strokeCycle
    }
    
    func getViewController(_ callback: @escaping (FilterProvider) -> ()) -> UIViewController {
        return StrokeCycleFilterTableViewController(filter: self, callback)
    }
    
    func getFilter() -> Filter {
        return Filter(id: self.filterId,
                      title: self.title,
                      caption: self.caption,
                      predicate: { motorcycle in
                        guard let selected = self.selectedStrokeCycle else { return true }
                        let strokeCycle = motorcycle.engine.strokeCycle
                        return strokeCycle == selected
        })
    }
}
