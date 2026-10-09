//
//  SearchResultsView.swift
//  The Deejay Room
//
//  Created by Leigh D on 3/24/26.
//
import SwiftUI

struct SearchResultsView: View {
    let results: [Album]
    
    var body: some View {
        ZStack {
            Color(hex: "#e3d0f2").ignoresSafeArea()
            
            if results.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "opticaldisc")
                        .font(.system(size: 50))
                        .foregroundStyle(Color(hex: "#9b7fc0"))
                    Text("no results found")
                        .font(.headline)
                        .foregroundStyle(Color(hex: "#6b4f8a"))
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(results) { album in
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
        }
        .navigationTitle("results")
        .navigationBarTitleDisplayMode(.large)
    }
}
