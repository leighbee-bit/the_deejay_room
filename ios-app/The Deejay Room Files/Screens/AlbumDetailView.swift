//
//  AlbumDetailView.swift
//  The Deejay Room
//
//  Created by Leigh D on 3/24/26.
//
import SwiftUI

struct AlbumDetailView: View {
    let album: Album
    
    @State var isFavorited: Bool = false
    @State var isLoading: Bool = false
    @State var errorMessage: String = ""
    
    var body: some View {
            ZStack {
                Color(hex: "#e3d0f2").ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        AsyncImage(url: URL(string: album.coverImageUrl)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                            case .failure:
                                ZStack {
                                    Color(hex: "#c9b0e8")
                                    Image(systemName: "opticaldisc")
                                        .foregroundStyle(Color(hex: "#7a5fa0"))
                                        .font(.system(size: 60))
                                }
                            case .empty:
                                ZStack {
                                    Color(hex: "#c9b0e8")
                                    ProgressView()
                                }
                            @unknown default:
                                Color(hex: "#c9b0e8")
                            }
                        }
                        .frame(width: 300, height: 300)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        
                        Text(album.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.black)
                            .multilineTextAlignment(.center)
                        
                        Text(album.artist)
                            .font(.headline)
                            .foregroundStyle(Color(hex: "#6b4f8a"))
                        
                        if album.year != "Unknown" {
                            Text(album.year)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color(hex: "#c9b0e8"))
                                .foregroundStyle(Color(hex: "#4a3060"))
                                .cornerRadius(20)
                        }
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundStyle(Color.red)
                                .font(.caption)
                        }
                        
                        Button {
                            Task {
                                await toggleFavorite()
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: isFavorited ? "heart.fill" : "heart")
                                Text(isFavorited ? "saved!" : "save to favorites")
                            }
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isFavorited ? Color(hex: "#9b7fc0") : Color.black)
                            .foregroundStyle(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        .disabled(isLoading)
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle(album.title)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await checkIfFavorited()
            }
        }
        
        func checkIfFavorited() async {
            do {
                isFavorited = try await APIService.shared.isFavorited(discogsId: album.id)
            } catch {
                print("Error checking favorite: \(error)")
            }
        }
        
        func toggleFavorite() async {
            isLoading = true
            do {
                if isFavorited {
                    let success = try await APIService.shared.removeFavorite(discogsId: album.id)
                    if success { isFavorited = false }
                } else {
                    let success = try await APIService.shared.saveFavoriteAlbum(album: album)
                    if success { isFavorited = true }
                }
            } catch {
                errorMessage = "Something went wrong!"
            }
            isLoading = false
        }
}
