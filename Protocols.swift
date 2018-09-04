import UIKit

protocol CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell
    var selectionBehavior: CellSelection { get }
}

extension CellRepresentable {
    var selectionBehavior: CellSelection {
        return .ignored
    }
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



enum CellSelection {
    case ignored
    case showImages(imageURLs: [URL])
    case openURL(linkURL: URL?)
}
