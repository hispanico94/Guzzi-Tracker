import UIKit

// MARK: - Definitions

struct SectionData {
    let sectionName: String
    let sectionElements: [CellRepresentable]
}

struct RowElement {
    let rowKey: String
    let rowValue: String
}

struct RowNote {
    let note: String
}

struct RowImage {
    let urls: [URL]
}

// MARK: - Conforming to CellRepresentable protocol

extension RowElement: CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MotorcycleInfoCell.defaultIdentifier)
            .getOrElse(MotorcycleInfoCell.getCell()) as! MotorcycleInfoCell
        return cell.set(withRowElement: self)
    }
}

extension RowNote: CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MotorcycleNotesCell.defaultIdentifier)
            .getOrElse(MotorcycleNotesCell.getCell()) as! MotorcycleNotesCell
        return cell.set(withRowNote: self)
    }
}

extension RowImage: CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MotorcycleImagesCell.defaultIdentifier)
            .getOrElse(MotorcycleImagesCell.getCell()) as! MotorcycleImagesCell
        return cell.setText(withElementNumber: self.urls.count)
    }
    
    var selectionBehavior: CellSelection {
        return .showImages(imageURLs: urls)
    }
}
