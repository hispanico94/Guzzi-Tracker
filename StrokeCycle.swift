import UIKit

struct StrokeCycle {
    var selectedStrokeCycle: Motorcycle.Engine.StrokeCycle? = nil
    let title = "Stroke cycles"
    private var caption: String {
        guard let selected = selectedStrokeCycle else { return "" }
        switch selected {
        case .twoStroke:
            return "2-stroke"
        case .fourStroke:
            return "4-stroke"
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
