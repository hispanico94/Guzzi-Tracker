import UIKit

protocol CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell
}

protocol ArrayConvertible {
    func convertToArray() -> [CellRepresentable]
}

protocol FilterProvider {
    var filterId: FilterId { get }
    func getViewController(_ callback: @escaping (FilterProvider) -> ()) -> UIViewController
    func getFilter() -> Filter
}

protocol Monoid {
    static func <> (lhs: Self, rhs: Self) -> Self
    static var empty: Self { get }
}
