
import UIKit

protocol ImageLoaderProtocol {
    func fetchImage(_ url: String, completion: @escaping (UIImage?) -> Void)
}
enum ServerError: Error {
    case unsupportedURL
    case incorrectImageFormat
    case incorrectResponse
}

class AsyncImageView: ImageLoaderProtocol {
    private var currentUrl: String? // Get a hold of the latest request url
    private var imageCache = NSCache<NSString, UIImage>()
    /// Fetch and save imae in Cache
    /// - Parameters:
    ///   - url: url of Imae
    ///   - completion: Image donloaded from remote server/ default image
    func fetchImage(_ url: String, completion: @escaping (UIImage?) -> Void) {
        currentUrl = url
        if (imageCache.object(forKey: url as NSString) != nil) {
            completion(imageCache.object(forKey: url as NSString))
        } else {
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            let task = session.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, _ , error) in
                if error == nil {
                    // DispatchQueue.main.async {
                    if let data = data, let downloadedImage = UIImage(data: data) {
                            self.imageCache.setObject(downloadedImage, forKey: url as NSString)
                            completion(downloadedImage)

                    } else {
                        completion(UIImage(named: Constants.defaultLoaderImage))
                    }
                } else {
                    completion(UIImage(named: Constants.defaultLoaderImage))
                }
            })
            task.resume()
        }
    }
}
