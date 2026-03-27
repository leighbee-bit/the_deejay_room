//
//  Album.swift
//  The Deejay Room
//
//  Created by Leigh D on 3/24/26.
//
import Foundation

struct Album: Identifiable, Hashable {
    let id: String
    let title: String
    let artist: String
    let year: String
    let thumbUrl: String
    let coverImageUrl: String
}
