package org.leighbeebit.music_clinic_backend.entities;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Data
@Table(name="favorite_albums")
public class FavoriteAlbum {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name="discogs_id", nullable = false, unique = true)
    private String discogsId;

    @Column(name="title", nullable = false)
    private String title;

    @Column(name="artist", nullable = false)
    private String artist;

    @Column(name="year")
    private Integer year;

    @Column(name="image_url")
    private String imageUrl;

    @Column(name = "added_at", updatable = false)
    private LocalDateTime addedAt;

    @PrePersist
    protected void onAdd() {
        addedAt = LocalDateTime.now();
    }
}
