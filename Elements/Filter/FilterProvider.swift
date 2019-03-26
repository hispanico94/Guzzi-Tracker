import UIKit

protocol FilterProvider {
    var filterId: FilterId { get }
    func getViewController(_ callback: @escaping (FilterProvider) -> ()) -> UIViewController
    func getFilter() -> Filter
}
