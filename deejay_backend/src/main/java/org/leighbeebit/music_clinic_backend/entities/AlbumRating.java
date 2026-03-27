package org.leighbeebit.music_clinic_backend.entities;


import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Entity
@Table(name="album_ratings")
public class AlbumRating {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name="discogs_id", nullable = false, unique = true)
    private String discogsId;

    @Column(name="title", nullable = false)
    private String title;

    @Column(name="artist", nullable = false)
    private String artist;

    @Column(name="rating")
    private Integer rating;

    @Column(name = "rated_at", updatable = false)
    private LocalDateTime ratedAt;

    @PrePersist
    protected void onAdd() {
        ratedAt = LocalDateTime.now();
    }
}
