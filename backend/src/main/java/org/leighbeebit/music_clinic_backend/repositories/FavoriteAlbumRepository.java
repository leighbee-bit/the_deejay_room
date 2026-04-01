package org.leighbeebit.music_clinic_backend.repositories;

import org.leighbeebit.music_clinic_backend.entities.FavoriteAlbum;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface FavoriteAlbumRepository extends JpaRepository<FavoriteAlbum, Long> {
    Optional<FavoriteAlbum> findByDiscogsId(String discogsId);
    boolean existsByDiscogsId(String discogsId);
    void deleteByDiscogsId(String discogsId);
}
