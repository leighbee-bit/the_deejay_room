//
//  DeejayFrontend.swift
//  The Deejay Room
//
//  Created by Leigh D on 3/24/26.
//
import SwiftUI

struct DeejayFrontend: View {
    
    @State var userAlbumSearch: String = ""
    @State var userArtistSearch: String = ""
    @State var userGenreSearch: String = ""
    @State var searchResults: [Album] = []
    @State var isLoading: Bool = false
    @State var errorMessage: String = ""
    @State var navigateToResults: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#e3d0f2").ignoresSafeArea()
                
                VStack {
                    Text("welcome to the record store")
                        .lineLimit(2)
                        .font(.largeTitle)
                        .foregroundStyle(Color.black)
                        .multilineTextAlignment(.center)
                    
                    Image(systemName: "opticaldisc.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundStyle(Color.black)
                    
                    TextField("Search for albums", text: $userAlbumSearch)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Search for artists", text: $userArtistSearch)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    TextField("Search for genres", text: $userGenreSearch)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("search!") {
                        Task {
                            await performSearch()
                        }
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.black)
                    .foregroundStyle(Color.white)
                    .cornerRadius(10)
                    
                    if isLoading {
                        ProgressView()
                            .padding()
                    }
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundStyle(Color.red)
                            .padding()
                    }
                    
                    NavigationLink(destination: SearchResultsView(results: searchResults),
                                   isActive: $navigateToResults) {
                        EmptyView()
                    }
                }
            }
            .navigationTitle("record store")
            .navigationBarTitleDisplayMode(.inline)
        }
        .ignoresSafeArea()
    }
    
    func performSearch() async {
        isLoading = true
        errorMessage = ""
        let query = [userAlbumSearch, userArtistSearch, userGenreSearch]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        
        guard !query.isEmpty else {
            errorMessage = "Please enter a search term!"
            isLoading = false
            return
        }
        
        do {
            searchResults = try await APIService.shared.searchAlbums(query: query)
            if !searchResults.isEmpty {
                navigateToResults = true
            }
        } catch {
            errorMessage = "Search failed: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
