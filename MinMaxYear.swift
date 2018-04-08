import UIKit

class MinMaxYear {
    var isActive: Bool = false
    var minYear: Int = getFoundationYear() {
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
    var maxYear: Int = getCurrentYear() {
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
    let title = "Years Interval"
    var caption: String {
        get {
            return "From \(minYear) To \(maxYear)"
        }
    }
    var yearRange = CountableClosedRange(getFoundationYear()...getCurrentYear())
}

extension MinMaxYear: FilterProvider {
    func getViewController() -> UIViewController {
        return MinMaxYearFilterViewController(minMaxYear: self)
    }
    
    func getFilter() -> Filter {
        if isActive {
            return Filter(id: .minMaxYear, title: self.title, caption: self.caption, predicate: { motorcycle in
                let lastYear = motorcycle.generalInfo.lastYear ?? getCurrentYear()
                return lastYear >= self.minYear && motorcycle.generalInfo.firstYear <= self.maxYear
            })
        }
        return Filter(id: .minMaxYear, title: self.title, caption: "From 1921 to 2018", predicate: { _ in
            return true
        })
    }
    
}
