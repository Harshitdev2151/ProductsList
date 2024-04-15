
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
    ///   - url: url of Image to downlaod
    ///   - completion: Image downloaded from remote server/ default image
    func fetchImage(_ url: String, completion: @escaping (UIImage?) -> Void) {
        currentUrl = url
        if (imageCache.object(forKey: url as NSString) != nil) {
            completion(imageCache.object(forKey: url as NSString))
        } else {
            //background thread downlaod
            DispatchQueue.global().async {
                let sessionConfig = URLSessionConfiguration.default
                let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
                let task = session.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response , error) in
                    if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode, error == nil {
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

//guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
//    completionHandler(.failure(.invalidResponse))
//    return
//}
