import Foundation
import UIKit

@MainActor
final class ImageCacheManager {
    static let instance: ImageCacheManager = .init()
    let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
        
        cache.totalCostLimit = 1024 * 1024 * 200 // 200mb
    }
    
    func set(key: String, obj: UIImage) {
        let cost: Int = Int(obj.size.width * obj.size.height * 4)
        cache.setObject(obj, forKey: NSString(string: key), cost: cost)
    }
    
    func get(key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
}
