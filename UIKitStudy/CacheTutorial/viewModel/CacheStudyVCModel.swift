import Foundation
import Combine
import UIKit

@MainActor
final class CacheStudyVCModel: ObservableObject {
    @Published var photos: [Photo] = []
    private var cancellables = Set<AnyCancellable>()
    let imageManager: ImageCacheManager = .instance
    
    // 중복 다운로드 요청 방지용: 현재 다운로드 중인 URL들을 추적
    private var loadingTasks: [String: Task<UIImage?, Error>] = [:]
    
    init() {
        fetch()
    }
    
    func fetch() {
        guard let url = URL(string: "http://54.180.212.147:7784/api/test/post") else {
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: [Photo].self, decoder: JSONDecoder())
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error fetching photos: \(error)")
                }
            } receiveValue: { [weak self] photos in
                self?.photos = photos
            }
            .store(in: &cancellables)
    }
    
    func loadImage(url: URL) async throws -> UIImage? {
        let cacheKey = url.absoluteString
        
        // 1. 캐시에서 먼저 찾기
        if let cachedImage = imageManager.get(key: cacheKey) {
            print("이미지 [Cache Hit] : \(cacheKey)")
            return cachedImage
        }
        
        // 2. 이미 해당 이미지를 다운로드 중인 경우, 새로운 요청을 하지 않고 기존 Task를 기다림
        if let pendingTask = loadingTasks[cacheKey] {
            print("이미지 [Pending Wait] : \(cacheKey)")
            return try await pendingTask.value
        }
        
        // 3. 신규 다운로드 작업 생성
        let task = Task<UIImage?, Error> {
            print("이미지 [Network Start] : \(cacheKey)")
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            return image
        }
        
        loadingTasks[cacheKey] = task
        
        do {
            let downloadedImage = try await task.value
            loadingTasks.removeValue(forKey: cacheKey)
            
            if let image = downloadedImage {
                imageManager.set(key: cacheKey, obj: image)
            }
            
            return downloadedImage
        } catch {
            loadingTasks.removeValue(forKey: cacheKey)
            throw error
        }
    }
    
    private func handleOutput(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300
        else {
            throw URLError(.badServerResponse)
        }
        
        return output.data
    }
}



