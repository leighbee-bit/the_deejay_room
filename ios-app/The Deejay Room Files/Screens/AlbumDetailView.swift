//
//  AlbumDetailView.swift
//  The Deejay Room
//
//  Created by Leigh D on 3/24/26.
//
import SwiftUI

struct AlbumDetailView: View {
    let album: Album
    
    var body: some View {
        ZStack {
            Color(hex: "#e3d0f2").ignoresSafeArea()
            
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: album.coverImageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 300, height: 300)
                .cornerRadius(12)
                
                Text(album.title)
                    .font(.title)
                    .foregroundStyle(Color.black)
                    .multilineTextAlignment(.center)
                
                Text(album.artist)
                    .font(.headline)
                    .foregroundStyle(Color.gray)
                
                Text(album.year)
                    .font(.subheadline)
                    .foregroundStyle(Color.gray)
                Spacer()
                Button("save to favorites!") {
                    Task {
                        
                    }
                }
                .font(.headline)
                .padding()
                .background(Color.black)
                .foregroundStyle(Color.white)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle(album.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
