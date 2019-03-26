import UIKit

// MARK: - enum CellSelection

enum CellSelection {
    case ignored
    case showImages(imageURLs: [URL])
    case openURL(linkURL: URL?)
}

// MARK: - protocol CellRepresentable

protocol CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell
    var selectionBehavior: CellSelection { get }
}

extension CellRepresentable {
    var selectionBehavior: CellSelection {
        return .ignored
    }
}

// MARK: - protcol ArrayConvertible

protocol ArrayConvertible {
    func convertToArray() -> [CellRepresentable]
}
