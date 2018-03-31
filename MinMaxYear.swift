import Foundation

struct MinMaxYear {
    var isActive: Bool = false
}

extension MinMaxYear: FilterProvider {
    func getFilter() -> Filter {
        if isActive {
            return Filter(id: .minMaxYear, title: "Intervallo di date", caption: "minimo 1950", predicate: { motorcycle in
                motorcycle.generalInfo.firstYear >= 1950
            })
        }
        return Filter(id: .minMaxYear, title: "Intervallo di date", caption: "da 1921 a 2018", predicate: { _ in
            return true
        })
    }
}
