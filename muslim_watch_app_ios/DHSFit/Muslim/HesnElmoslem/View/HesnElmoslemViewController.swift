//
//  HesnElmoslemViewController.swift
//  MuslimFit
//
//  Created by Karim on 14/07/2023.
//

import UIKit

class HesnElmoslemViewController: UIViewController {

    let muslimWorker: MuslimWorkerProtocol = MuslimWorker()
    
    lazy var containerView: HesnElmoslemContainerView = {
        let view = HesnElmoslemContainerView(view: self)
        return view
    }()
    
    let defaultsManager: UserDefaultsProtocol = UserDefaultsManager()
    
    let coreDataManager = CoreDataManager()
    
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var language: String {
        switch LanguageManager.shareInstance().getHttpLanguageType() {
        case "ar":
            return "arabic"
        case "en":
            return "english"
        case "fr":
            return "french"
//        case "de":
//            return "german"
//        case "el":
//            return "greece"
        case "es":
            return "spanish"
//        case "fa":
//            return "persian"
//        case "he":
//            return "hebrew"
        case "id":
            return "indonesian"
//        case "it":
//            return "italy"
//        case "pl":
//            return "poland"
//        case "pt":
//            return "portugal"
        case "ru":
            return "russian"
        case "tr":
            return "turkish"
        case "ur":
            return "urdo"
//        case "vi":
//            return "vietnam"
        default:
            return "arabic"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        
//        if let hesnElmoslem: HesnElmoslemModel = defaultsManager.valueStoreable(key: UserDefaultsKeys.hesnElmoslem) {
//print("hesn")
//        } else {
        if coreDataManager.fetchHesnElmoslem().isEmpty {
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.containerView.HesnElmoslemTableView.bounds.width, height: CGFloat(50))

            self.containerView.HesnElmoslemTableView.tableFooterView = spinner
            self.containerView.HesnElmoslemTableView.tableFooterView?.isHidden = false
            hesnElmoslem(lang: language)
        }
            
//        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.containerView.HesnElmoslemTableView.reloadData()
        
    }
    
    override func loadView() {
        super.loadView()
        self.view = containerView
    }
    
//    @objc func hesnElmoslemReloadData() {
//
//        DispatchQueue.main.async {
//            if self.coreDataManager.fetchHesnElmoslem().count < 7 {
//                self.containerView.HesnElmoslemTableView.tableFooterView?.isHidden = false
//            } else {
//                self.containerView.HesnElmoslemTableView.tableFooterView?.isHidden = true
//            }
//            self.containerView.HesnElmoslemTableView.reloadData()
//        }
//
//    }
    
    func hesnElmoslem(lang: String) {
        muslimWorker.hesnElmoslem(lang) { result in
            switch result {
            case let .success(responseModel):
//                self.containerView.hesnElmoslem = responseModel?.data ?? []
//                self.defaultsManager.writeStoreable(key: UserDefaultsKeys.hesnElmoslem, value: responseModel)
                
                for i in responseModel ?? [] {
                    
                    guard let headerUrl = URL(string: "\(i.header ?? "")") else {
                            return
                        }
                    
                    DispatchQueue.global().async {
                        guard let headerData = try? Data(contentsOf: headerUrl) else {
                            return
                        }
                        
                        self.coreDataManager.saveHesnElmoslem(id: "\(i.id ?? 0)", header: headerData, body: i.body ?? "")
                    }
                    
//                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(9)) {
                        self.containerView.HesnElmoslemTableView.tableFooterView?.isHidden = true
                        self.containerView.HesnElmoslemTableView.reloadData()
                    }
                }
                
//                self.containerView.HesnElmoslemTableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoader: UIImageView {

    var imageURL: URL?

    let activityIndicator = UIActivityIndicatorView()

    func loadImageWithUrl(_ url: URL) {

        // setup activityIndicator...
        activityIndicator.color = .darkGray

        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        imageURL = url

        image = nil
        activityIndicator.startAnimating()

        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {

            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }

        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                })
                return
            }

            DispatchQueue.main.async(execute: {

                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {

                    if self.imageURL == url {
                        self.image = imageToCache
                    }

                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                self.activityIndicator.stopAnimating()
            })
        }).resume()
    }
}


//protocol ImageCacheType: AnyObject {
//    // Returns the image associated with a given url
////    func image(for url: URL) -> UIImage?
//    // Inserts the image of the specified url in the cache
//    func insertImage(_ image: UIImage?, for url: URL)
////    // Removes the image of the specified url in the cache
//    func removeImage(for url: URL)
////    // Removes all images from the cache
////    func removeAllImages()
//    // Accesses the value associated with the given key for reading and writing
////    subscript(_ url: URL) -> UIImage? { get set }
//}
//
//final class ImageCache {
//
//    // 1st level cache, that contains encoded images
//    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
//        let cache = NSCache<AnyObject, AnyObject>()
//        cache.countLimit = config.countLimit
//        return cache
//    }()
//    // 2nd level cache, that contains decoded images
//    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
//        let cache = NSCache<AnyObject, AnyObject>()
//        cache.totalCostLimit = config.memoryLimit
//        return cache
//    }()
//    private let lock = NSLock()
//    private let config: Config
//
//    struct Config {
//        let countLimit: Int
//        let memoryLimit: Int
//
//        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
//    }
//
//    init(config: Config = Config.defaultConfig) {
//        self.config = config
//    }
//}
//
//extension ImageCache: ImageCacheType {
//
//    func insertImage(_ image: UIImage?, for url: URL) {
//        guard let image = image else { return removeImage(for: url) }
//        let decodedImage = image.decodedImage()
//
//        lock.lock(); defer { lock.unlock() }
//        imageCache.setObject(decodedImage, forKey: url as AnyObject)
//        decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decodedImage.diskSize)
//
//    }
//
//    func removeImage(for url: URL) {
//        lock.lock(); defer { lock.unlock() }
//        imageCache.removeObject(forKey: url as AnyObject)
//        decodedImageCache.removeObject(forKey: url as AnyObject)
//    }
//}
//
//extension ImageCache {
//    func image(for url: URL) -> UIImage? {
//        lock.lock(); defer { lock.unlock() }
//        // the best case scenario -> there is a decoded image
//        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
//            return decodedImage
//        }
//        // search for image data
//        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
//            let decodedImage = image.decodedImage()
//            decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decodedImage.diskSize)
//            return decodedImage
//        }
//        return nil
//    }
//}
//
//extension ImageCache {
//    subscript(_ key: URL) -> UIImage? {
//        get {
//            return image(for: key)
//        }
//        set {
//            return insertImage(newValue, for: key)
//        }
//    }
//}
//
//extension UIImage {
//
//    func decodedImage() -> UIImage {
//        guard let cgImage = cgImage else { return self }
//        let size = CGSize(width: cgImage.width, height: cgImage.height)
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
//        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
//        guard let decodedImage = context?.makeImage() else { return self }
//        return UIImage(cgImage: decodedImage)
//    }
//}
