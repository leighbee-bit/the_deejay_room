import Foundation

class APIService {

    static let shared = APIService()
    
    private let baseURL = Config.baseURL

    func searchAlbums(query: String) async throws -> [Album] {
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

                if let masterId = result["master_id"] as? Int {
                    if seenMasterIds.contains(masterId) { return nil }
                    seenMasterIds.insert(masterId)
                }

                let artist = title.components(separatedBy: " - ").first ?? "Unknown"
                let year = result["year"] as? String ?? "Unknown"
                let thumb = result["thumb"] as? String ?? ""
                let cover = result["cover_image"] as? String ?? ""

                return Album(id: String(id), title: title, artist: artist,
                             year: year, thumbUrl: thumb, coverImageUrl: cover)
            }
        }
        return []
    }

    func saveFavoriteAlbum(album: Album) async throws -> Bool {
        let urlString = "\(baseURL)/api/favorites"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var body = [String: Any]()
        body["discogsId"] = album.id
        body["title"] = album.title
        body["artist"] = album.artist
        body["year"] = Int(album.year) ?? 0
        body["imageUrl"] = album.thumbUrl
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let(_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
                return httpResponse.statusCode == 200
            }
        return false
    }
    
    func isFavorited(discogsId: String) async throws -> Bool {
        let urlString = "\(baseURL)/api/favorites/\(discogsId)/exists"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let result = try JSONSerialization.jsonObject(with: data) as? Bool {
            return result
        }
        return false
    }
    
    func removeFavorite(discogsId: String) async throws -> Bool {
        let urlString = "\(baseURL)/api/favorites/\(discogsId)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let(_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            return httpResponse.statusCode == 204
        }
        return false
    }
}
