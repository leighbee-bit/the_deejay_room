//
//  AlbumRowView.swift
//  The Deejay Room
//
//  Created by Leigh D on 3/24/26.
//
import SwiftUI

struct AlbumRowView: View {
    let album: Album
    
    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: album.thumbUrl)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    ZStack {
                        Color(hex: "#c9b0e8")
                        Image(systemName: "opticaldisc")
                            .foregroundStyle(Color(hex: "#7a5fa0"))
                            .font(.title2)
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
            .frame(width: 70, height: 70)
            .cornerRadius(10)
            .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(album.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.black)
                    .lineLimit(1)
                
                Text(album.artist)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color(hex: "#6b4f8a"))
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    if album.year != "Unknown" {
                        Text(album.year)
                            .font(.system(size: 11, weight: .medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(hex: "#c9b0e8"))
                            .foregroundStyle(Color(hex: "#4a3060"))
                            .cornerRadius(20)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color(hex: "#9b7fc0"))
                .font(.system(size: 13, weight: .semibold))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}
