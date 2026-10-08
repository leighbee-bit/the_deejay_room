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
                List {
                    ForEach(favorites) { album in
                        // Hidden link so List doesn't add a second chevron next to AlbumRowView's own
                        ZStack {
                            NavigationLink(destination: AlbumDetailView(album: album)) {
                                EmptyView()
                            }
                            .opacity(0)
                            AlbumRowView(album: album)
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        .listRowBackground(Color(hex: "#e3d0f2"))
                        .listRowSeparatorTint(Color(hex: "#c9b0e8"))
                        .alignmentGuide(.listRowSeparatorLeading) { _ in 84 }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                Task { await removeFavorite(album) }
                            } label: {
                                Label("remove", systemImage: "heart.slash")
                            }
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                Task { await removeFavorite(album) }
                            } label: {
                                Label("remove from favorites", systemImage: "heart.slash")
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
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

    func removeFavorite(_ album: Album) async {
        // Remove right away so the swipe feels instant; put it back if the server call fails
        guard let index = favorites.firstIndex(of: album) else { return }
        withAnimation { _ = favorites.remove(at: index) }
        errorMessage = ""
        do {
            let success = try await APIService.shared.removeFavorite(discogsId: album.id)
            if !success { throw URLError(.badServerResponse) }
        } catch {
            print("Failed to remove favorite: \(error)")
            withAnimation { favorites.insert(album, at: min(index, favorites.count)) }
            errorMessage = "Failed to remove favorite"
        }
    }
}
