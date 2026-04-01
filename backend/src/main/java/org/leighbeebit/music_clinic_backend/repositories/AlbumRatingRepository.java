package org.leighbeebit.music_clinic_backend.repositories;

import org.leighbeebit.music_clinic_backend.entities.AlbumRating;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface AlbumRatingRepository extends JpaRepository<AlbumRating, Long> {
    Optional<AlbumRating> findByDiscogsId(String discogsId);
    boolean existsByDiscogsId(String discogsId);
}
