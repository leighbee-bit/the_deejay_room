
import Foundation
class APIService {

    static let shared = APIService()
    
    func searchAlbums(query: String) async throws -> [Album] {
        
        let baseURL = "http://localhost:8080"
        
        var components = URLComponents(string: "\(baseURL)/api/discogs/search")!
        components.queryItems = [URLQueryItem(name: "query", value: query)]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        print("Requesting URL: \(url)")
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Status code: \(httpResponse.statusCode)")
        }
        
        print("Raw response: \(String(data: data, encoding: .utf8) ?? "no data")")
        
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let results = json["results"] as? [[String: Any]] {
            
            var seenMasterIds = Set<Int>()
            
            return results.compactMap { result in
                guard let id = result["id"] as? Int,
                      let title = result["title"] as? String else { return nil }
                
                // Deduplicate by master_id
                if let masterId = result["master_id"] as? Int {
                    if seenMasterIds.contains(masterId) {
                        return nil
                    }
                    seenMasterIds.insert(masterId)
                }
                
                let artist = title.components(separatedBy: " - ").first ?? "Unknown"
                let year = result["year"] as? String ?? "Unknown"
                let thumb = result["thumb"] as? String ?? ""
                let cover = result["cover_image"] as? String ?? ""
                
                return Album(
                    id: String(id),
                    title: title,
                    artist: artist,
                    year: year,
                    thumbUrl: thumb,
                    coverImageUrl: cover
                )
            }
        }
        return []
    }
}
