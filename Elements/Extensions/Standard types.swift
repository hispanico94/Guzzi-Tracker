import UIKit
import Argo
import Curry

// MARK: - Conforming to Argo.Decodable protocol

extension URL: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<URL> {
        guard case .string(let path) = json else {
            return Decoded.failure(.typeMismatch(expected: "String", actual: "\(json)"))
        }
        guard let url = URL(string: path) else {
            return Decoded.failure(.custom("Cannot create URL from string \(path)"))
        }
        return Decoded.success(url)
    }
}

extension Array: Argo.Decodable where Element: Argo.Decodable, Element.DecodedType == Element {
    public typealias DecodedType = Array
    
    public static func decode(_ json: JSON) -> Decoded<Array> {
        guard case let .array(array) = json else {
            return .typeMismatch(expected: "array", actual: json)
        }
        
        return .materialize {
            try array.map { internalJson in
                try Element.decode(internalJson).dematerialize()
            }
        }
    }
}

extension Dictionary: Argo.Decodable where Key == String, Value: Argo.Decodable, Value.DecodedType == Value {
    public typealias DecodedType = Dictionary
    
    public static func decode(_ json: JSON) -> Decoded<Dictionary<Key, Value>> {
        guard case let .object(dict) = json else {
            return .typeMismatch(expected: "object", actual: json)
        }
        
        return .materialize {
            try dict.mapValues { internalJson in
                try Value.decode(internalJson).dematerialize()
            }
        }
    }
}

//extension Optional: Argo.Decodable where Wrapped: Argo.Decodable, Wrapped.DecodedType == Wrapped {
//    public typealias DecodedType = Optional
//
//    public static func decode(_ json: JSON) -> Decoded<Optional<Wrapped>> {
//        if case .null = json {
//            return .success(nil)
//        }
//
//        return Wrapped.decode(json).map { Optional($0) }
//    }
//}

// MARK: - Conforming to CellRepresentable protocol

extension URL: CellRepresentable {
    func makeTableViewCell(forTableView tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.defaultIdentifier)
            .getOrElse(ImageCell.getCell()) as! ImageCell
        return cell.set(withImageURL: self)
    }
}

// MARK: - Optional extensions

extension Optional {
    func getOrElse(_ elseValue: @autoclosure () -> Wrapped ) -> Wrapped {
        switch self {
        case .none:
            return elseValue()
        case .some(let value):
            return value
        }
    }
}

// MARK: - Array extensions

extension Array {
    
    /// Replace the element at index `index` with `newElement` and returns the old element.
    /// - parameter newElement: the element that replaces the old one
    /// - parameter index: the index locating the old element
    /// - returns: the old element
    mutating func replaceElement(with newElement: Element, at index: Index) -> Element {
        let oldElement = remove(at: index)
        insert(newElement, at: index)
        return oldElement
    }
}

extension Array {
    
    /// Sort the elements in place using `comparator` as the comparing function.
    /// - parameter comparator: the `Comparator<Element>` that handles the comparison
    mutating func sort(by comparator: Comparator<Element>) {
        self.sort { comparator.call(($0, $1)) == .lt }
    }
}

extension Array {
    
    /// returns `self` with the new element appended at the end
    /// - parameter element: the element to be appended
    /// - returns: `self` with `element` appended at the end
    func appending (_ element: Element) -> Array {
        var mutatingSelf = self
        mutatingSelf.append(element)
        return mutatingSelf
    }
}

extension Array where Element: Comparable {
    
    /// Sort the elements and remove duplicates.
    /// - returns: the array sorted and without duplicates
    func removeDuplicates() -> Array {
        return self
            .sorted() { $0 < $1 }
            .reduce([]) { (accumulator, element) in
                if let last = accumulator.last, last == element {
                    return accumulator
                } else {
                    return accumulator.appending(element)
                }
        }
    }
}

// MARK: - Collection extensions

extension Collection where Element: Equatable {
    
    /// Check if `self` and `array` have at least one element in common and
    /// returns the index of the first common element in `self`, `nil` if no
    /// common elements are found.
    /// - parameter array: The array to be compared to `self`.
    /// - returns: the index of the first common element in `self`, `nil` if
    /// no common elements are found.
    func index(fromFirstMatch array: [Element]) -> Index? {
        for element in array {
            if let index = firstIndex(of: element) {
                return index
            }
        }
        return nil
    }
}

// MARK: - UnitVolume extensions

extension UnitVolume {
    static let engineCubicCentimeters = UnitVolume(symbol: "cc", converter: UnitConverterLinear(coefficient: 0.001))
    static let engineCubicInches = UnitVolume(symbol: "cu in", converter: UnitConverterLinear(coefficient: 0.016387064))
}

// MARK: - Measurement extensions

extension Measurement {
    /// Returns a string of the measurement formatted according to the locale of the user. If the value
    /// doesn't contains any decimals (e.g. 10.0) it is converted without decimal point (e.g. 10.0 -> "10")
    var customLocalizedDescription: String {
        let formatter = MeasurementFormatter()
        
        let roundedValue = self.value.rounded(.down)
        guard (self.value - roundedValue).isZero else {
            // Thsi step is necessary in order to avoid that the MeasurementFormatter
            // changes the unit of measure because of the locale
            // (also, strange behaviour was experienced where '80 mm' was converted to '0 km')
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let numberString = numberFormatter.string(from: NSNumber(value: self.value)) ?? self.value.description
            return numberString + " " + formatter.string(from: self.unit)
        }
        
        return String(format: "%.0f", self.value) + " " + formatter.string(from: self.unit)
    }
}

// MARK: - Double extensions

extension Double {
    /// Returns a string containing the number without decimal point if no decimals are present (e.g. 10.0 is
    /// converted as "10"). If decimals are present they are included and the number is formatted according
    /// to the locale of the user.
    var customLocalizedDescription: String {
        let roundedValue = self.rounded(.down)
        guard (self - roundedValue).isZero else {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return numberFormatter.string(from: NSNumber(value: self)) ?? self.description
        }
        
        return String(format: "%.0f", self)
    }
}

// MARK: -
// MARK: UIKit extensions
// MARK: -

// MARK: UIColor extensions

// Colors used in the app
extension UIColor {
    static let legnanoGreen = UIColor(displayP3Red: 181.0/255.0, green: 208.0/255.0, blue: 81.0/255.0, alpha: 1.0)
    static let lightLegnanoGreen = UIColor(displayP3Red: 238.0/255.0, green: 244.0/255.0, blue: 215.0/255.0, alpha: 1)
    static let guzziRed = UIColor(displayP3Red: 195.0/255.0, green: 21.0/255.0, blue: 26.0/255.0, alpha: 1.0)
}

// MARK: - UISearchBar extensions

extension UISearchBar {
    private func getViewElement<T>(type: T.Type) -> T? {
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    /// Returns the text field of the search bar
    func getTextField() -> UITextField? {
        return getViewElement(type: UITextField.self)
    }
    
    /// Set the placeholder text and text color
    /// - parameter text: the text for the placeholder
    /// - parameter color: the color for the placeholder text
    func setPlaceholderText(_ text: String, withColor color: UIColor) {
        if let textField = getTextField() {
            textField.attributedPlaceholder = NSAttributedString(
                string: text,
                attributes: [.foregroundColor: color]
            )
        }
    }
    
    /// Set the search icon color in the search bar's text field
    /// - parameter color: the new color for the search icon
    func setIconColor(_ color: UIColor) {
        if let imageView = getTextField()?.leftView as? UIImageView,
            let newImage = imageView.image?.transform(withNewColor: color) {
            imageView.image = newImage
        }
    }
}

// MARK: - UIImage extensions

extension UIImage {
    
    /// Change the color of self
    /// - parameter color: the new color for self
    /// - returns: a new instance of self with the new color, nil if the transformation fails.
    func transform(withNewColor color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)
        
        color.setFill()
        context.fill(rect)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return newImage
    }
}

// MARK: - UIViewController extensions

extension UIViewController {
    
    /// Handles the selection of a UITableViewCell defined from a type that conforms to CellRepresentable protocol.
    /// Checks the selecetionBehavior (passed as first parameter as CellSelection) and performs the requested
    /// action consequently. If the action is the pushing of a new view controller (e.g. `CellSelection.showImages`)
    /// the next view controller title is required, otherwise no action will be performed.
    /// - parameter cellSelection: the required behavior of the selected cell
    /// - parameter nextViewControllerTitle: the title for the next view controller if the action require so, default is `nil`
    func handle(cellSelection: CellSelection, nextViewControllerTitle: String? = nil) {
        switch cellSelection {
            
        case let .showImages(imageURLs) where nextViewControllerTitle != nil:
            navigationController?.pushViewController(ImagesViewController(motorcycleName: nextViewControllerTitle!,
                                                                          imagesUrls: imageURLs,
                                                                          nibName: "ImagesViewController",
                                                                          bundle: nil),
                                                     animated: true)
            
        case let .openURL(linkURL):
            guard let url = linkURL else {
                let alert = UIAlertController(title: NSLocalizedString("Error", comment: "action error"),
                                              message: NSLocalizedString("(URL ERROR)", comment: "error during the safe unwrapping of a optional that should have contained a URL"), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true)
                return
            }
            UIApplication.shared.open(url, options: [:])
            
        default:
            break
        }
    }
}

// MARK: - UITableView extensions

extension UITableView {
    func addFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        self.tableFooterView = footerView
        
        let greenFooterView = UIView(frame: .zero)
        greenFooterView.translatesAutoresizingMaskIntoConstraints = false
        greenFooterView.backgroundColor = .lightLegnanoGreen
        footerView.addSubview(greenFooterView)
        
        greenFooterView.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
        greenFooterView.leftAnchor.constraint(equalTo: footerView.leftAnchor).isActive = true
        greenFooterView.rightAnchor.constraint(equalTo: footerView.rightAnchor).isActive = true
        greenFooterView.heightAnchor.constraint(equalToConstant: 10000).isActive = true
    }
}

// MARK: - UIDevice extensions

extension UIDevice {
    static var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
