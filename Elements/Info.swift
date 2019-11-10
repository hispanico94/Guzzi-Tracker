import UIKit

// MARK: - Information definition

struct Information {
    let version: Version
    let about: About
    let contacts: [Contact]
    let review: Review
    
    
    struct Version {
        let appName: String
        let version: String?
        
        var text: String {
            var text = appName + " "
            text += version ?? NSLocalizedString("(Version not available)", comment: "(application version)")
            return text
        }
    }
    
    struct About {
        let text: String
    }
    
    struct Contact {
        let text: String
        let link: URL?
    }
    
    struct Review {
        let text: String
        let link: URL?
    }
}

// MARK: - Conforming Information.* to CellRepresentable protocol

extension Information.Version: CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "versionIdentifier") ?? UITableViewCell(style: .default, reuseIdentifier: "versionIdentifier")
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = text
        return cell
    }
}

extension Information.About: CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutIdentifier") ?? UITableViewCell(style: .default, reuseIdentifier: "aboutIdentifier")
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = text
        return cell
    }
}

extension Information.Contact: CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactIdentifier") ?? UITableViewCell(style: .default, reuseIdentifier: "contactIdentifier")
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .guzziRed
        cell.textLabel?.text = text
        return cell
    }
    
    var selectionBehavior: CellSelection {
        return .openURL(linkURL: link)
    }
}

extension Information.Review: CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewIdentifier") ?? UITableViewCell(style: .default, reuseIdentifier: "reviewIdentifier")
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .guzziRed
        cell.textLabel?.text = text
        return cell
    }

    var selectionBehavior: CellSelection {
        return .openURL(linkURL: link)
    }
}

// MARK: - Information defaults and SectionData array

extension Information {
    static var defaultInformations: Information {
        let version = Version(appName: "Guzzi Tracker", version: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)
        let about = About(text: NSLocalizedString("(APP DESCRIPTION)", comment: "write the app description as in the english and italian localizable files"))
        
        let modelID = UIDevice.modelIdentifier
        let iOSVersion = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        let emailUrlEncoded = "mailto:guzzitracker@gmail.com?body=\n\n(\(version.text) - \(modelID) - \(iOSVersion))"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let emailURL = emailUrlEncoded ?? "mailto:guzzitracker@gmail.com"
        
        let contacts = [ Contact(text: "email: guzzitracker@gmail.com", link: URL(string: emailURL)),
                         Contact(text: "GitHub", link: URL(string: "https://github.com/hispanico94/Guzzi-Tracker")) ]
        let review = Review(text: NSLocalizedString("Write a review!", comment: "write a review in the app store"), link: URL(string: "https://itunes.apple.com/app/guzzi-tracker/id1435726246?action=write-review"))
        
        return Information(version: version, about: about, contacts: contacts, review: review)
    }
    
    func makeArray() -> [SectionData] {
        var elements: [SectionData] = []
        elements.reserveCapacity(4)
        
        elements.append(SectionData(sectionName: NSLocalizedString("About the app", comment: "about the app"),
                                    sectionElements: [about]))
        elements.append(SectionData(sectionName: NSLocalizedString("Contacts", comment: "(or contact the developer)"),
                                    sectionElements: contacts))
        elements.append(SectionData(sectionName: NSLocalizedString("Reviews", comment: "Reviews"),
                                    sectionElements: [review]))
        elements.append(SectionData(sectionName: NSLocalizedString("Version", comment: "application version"),
        sectionElements: [version]))
        
        return elements
    }
}

