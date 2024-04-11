
import UIKit


protocol ImageLoaderProtocol {
    /// Protocol declaration to fetch image
    /// - Parameters:
    ///   - url: url  for image
    ///   - completion: completion handler for image
    func fetchImage(_ url: String, completion: @escaping (UIImage?) -> Void)
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
            //background thhread
            DispatchQueue.global().async {
                let sessionConfig = URLSessionConfiguration.default
                let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
                let task = session.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, _ , error) in
                    //Backround thread downlaoding
                    if error == nil {
                        if let data = data, let downloadedImage = UIImage(data: data) {
                            self.imageCache.setObject(downloadedImage, forKey: url as NSString)
                            completion(downloadedImage)
                        }
                        else {
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
}
