
//
//  DeleteDropZone.swift
//  MovieLibraryApp
//
//  Created by Andrew on 06/08/25.
//

import SwiftUI

struct DeleteDropZone: View {
    @State private var isTargeted = false
    var onDropMovieID: (UUID) -> Void

    var body: some View {
        ZStack {
            Circle()
                .fill(isTargeted ? Color.red.opacity(0.12) : Color.clear)
                .frame(width: 120, height: 120)
                .animation(.easeInOut(duration: 0.15), value: isTargeted)

            HStack(spacing: 8) {
                Image(systemName: "trash.fill").font(.title2)
                Text("Delete").font(.headline)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule().fill(isTargeted ? Color.red.opacity(0.2) : Color(.systemBackground))
            )
            .overlay(
                Capsule().stroke(isTargeted ? Color.red : Color(.systemGray4), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
            .scaleEffect(isTargeted ? 1.06 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.85), value: isTargeted)
        }
        .dropDestination(for: String.self) { items, _ in
            guard let idString = items.first,
                  let movieID = UUID(uuidString: idString) else { return false }
            onDropMovieID(movieID)
            isTargeted = false
            return true
        } isTargeted: { hovering in
            isTargeted = hovering
        }
        .accessibilityLabel(Text("Delete movie"))
        .accessibilityHint(Text("Drop a movie here to delete it"))
    }
}
