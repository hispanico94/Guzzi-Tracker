import UIKit

struct MinMaxYear {
    private var minYear: Int {
        didSet {
            let foundationYear = getFoundationYear()
            let currentYear = getCurrentYear()
            if (minYear < foundationYear) {
                minYear = foundationYear
            } else if (minYear > currentYear) {
                minYear = currentYear
            }
            if (minYear > maxYear) {
                maxYear = minYear
            }
        }
    }
    private var maxYear: Int {
        didSet {
            let foundationYear = getFoundationYear()
            let currentYear = getCurrentYear()
            if (maxYear < foundationYear) {
                maxYear = foundationYear
            } else if (maxYear > currentYear) {
                maxYear = currentYear
            }
            if (maxYear < minYear) {
                minYear = maxYear
            }
        }
    }
    let title = NSLocalizedString("Years", comment: "Interval of years")
    private var caption: String {
        get {
            let fromString = NSLocalizedString("from", comment: "lowercase from")
            let toString = NSLocalizedString("to", comment: "lowercase to")
            return fromString + " \(minYear) " + toString + " \(maxYear)"
        }
    }
    
    init(minYear: Int = getFoundationYear(), maxYear: Int = getCurrentYear()) {
        self.minYear = minYear
        self.maxYear = maxYear
    }
}

extension MinMaxYear: FilterProvider {
    var filterId: FilterId {
        return .minMaxYear
    }
    
    func getViewController(_ callback: @escaping (FilterProvider) -> ()) -> UIViewController {
        return MinMaxYearFilterViewController(minYear: self.minYear, maxYear: self.maxYear, callback)
    }

    func getFilter() -> Filter {
        return Filter(id: .minMaxYear,
                      title: self.title,
                      caption: self.caption,
                      predicate: { motorcycle in
                        let lastYear = motorcycle.generalInfo.lastYear ?? getCurrentYear()
                        return lastYear >= self.minYear && motorcycle.generalInfo.firstYear <= self.maxYear
        })
    }
}
