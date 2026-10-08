//
//  FavoritesView.swift
//  The Deejay Room
//
//  Created by Leigh D on 4/1/26.
//
import SwiftUI

struct FavoritesView: View {
    
    @State var favorites: [Album] = []
    @State var isLoading: Bool = false
    @State var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            Color(hex: "#e3d0f2").ignoresSafeArea()
            
            if isLoading {
                ProgressView()
            } else if favorites.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "heart")
                        .font(.system(size: 50))
                        .foregroundStyle(Color(hex: "#9b7fc0"))
                    Text("no favorites yet")
                        .font(.headline)
                        .foregroundStyle(Color(hex: "#6b4f8a"))
                    Text("save albums from the search screen!")
                        .font(.subheadline)
                        .foregroundStyle(Color(hex: "#9b7fc0"))
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(favorites) { album in
                            NavigationLink(destination: AlbumDetailView(album: album)) {
                                AlbumRowView(album: album)
                                    .padding(.horizontal, 16)
                                    .background(Color(hex: "#e3d0f2"))
                            }
                            Divider()
                                .background(Color(hex: "#c9b0e8"))
                                .padding(.leading, 100)
                        }
                    }
                }
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundStyle(Color.red)
                    .padding()
            }
        }
        .navigationTitle("favorites")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await loadFavorites()
        }
    }
    func loadFavorites() async {
            isLoading = true
            errorMessage = ""
            do {
                favorites = try await APIService.shared.getAllFavorites()
            } catch is CancellationError {
                // View disappeared mid-load; not a real failure
            } catch let error as URLError where error.code == .cancelled {
                // Same as above, surfaced by URLSession
            } catch {
                print("Failed to load favorites: \(error)")
                errorMessage = "Failed to load favorites"
            }
            isLoading = false
        }
}
