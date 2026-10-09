//
//  StarRatingView.swift
//  The Deejay Room
//
import SwiftUI

// 1-5 tappable stars. Tapping the current rating again clears it.
struct StarRatingView: View {
    let rating: Int?
    var starSize: CGFloat = 30
    var onRate: ((Int?) -> Void)? = nil

    var body: some View {
        HStack(spacing: 8) {
            ForEach(1...5, id: \.self) { star in
                let isFilled = star <= (rating ?? 0)
                Image(systemName: isFilled ? "star.fill" : "star")
                    .font(.system(size: starSize))
                    .foregroundStyle(isFilled ? Color(hex: "#9b7fc0") : Color(hex: "#c9b0e8"))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onRate?(star == rating ? nil : star)
                    }
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Rating")
        .accessibilityValue(rating.map { "\($0) out of 5 stars" } ?? "Not rated")
        .accessibilityAdjustableAction { direction in
            let current = rating ?? 0
            switch direction {
            case .increment: if current < 5 { onRate?(current + 1) }
            case .decrement: onRate?(current > 1 ? current - 1 : nil)
            @unknown default: break
            }
        }
    }
}
