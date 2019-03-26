import UIKit
import Kingfisher


class ImagesViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let imageAspectRatio = CGFloat(1.77778)
    private let pinnedDistanceImageViewInCell = CGFloat(4)
    
    private let imageUrls: [URL]
    private let motorcycleName: String
    private var imageUrlRequests: [URLRequest] {
        var imageUrlRequests: [URLRequest] = []
        for url in imageUrls {
            imageUrlRequests.append(URLRequest(url: url))
        }
        return imageUrlRequests
    }
    
    // MARK: - Initialization
    
    init(motorcycleName name: String, imagesUrls urls: [URL], nibName: String?, bundle: Bundle?) {
        motorcycleName = name
        imageUrls = urls
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImagePrefetcher(urls: imageUrls).start()
        navigationItem.title = motorcycleName
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.rowHeight = calculateRowHeight(withWidth: tableView.bounds.width)
    }

    // MARK: - View transition
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        tableView.rowHeight = calculateRowHeight(withWidth: size.width)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageUrls.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return imageUrls[indexPath.row].makeTableViewCell(forTableView: tableView)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath) as? ImageCell,
            let image = cell.motorcycleImageView.image,
            image != UIImage(named: "motorcycle_image_placeholder")
        else { return }
        
        present(SingleImageViewController(imageToBeDisplayed: image), animated: true, completion: nil)
    }
    
    // MARK: - Private instance methods
    
    private func calculateRowHeight(withWidth width: CGFloat) -> CGFloat {
        return (width / imageAspectRatio) + pinnedDistanceImageViewInCell
    }
}
