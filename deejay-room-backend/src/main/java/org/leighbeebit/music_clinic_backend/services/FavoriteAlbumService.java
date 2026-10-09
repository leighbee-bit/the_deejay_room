package org.leighbeebit.music_clinic_backend.services;


import jakarta.transaction.Transactional;
import org.leighbeebit.music_clinic_backend.entities.FavoriteAlbum;
import org.leighbeebit.music_clinic_backend.repositories.AlbumRatingRepository;
import org.leighbeebit.music_clinic_backend.repositories.FavoriteAlbumRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class FavoriteAlbumService {

    @Autowired
    private FavoriteAlbumRepository favoriteAlbumRepository;


    //Built in function to save favorite album
    public FavoriteAlbum saveFavorite(FavoriteAlbum favoriteAlbum) {
        return favoriteAlbumRepository.save(favoriteAlbum);
    }

    //Built in function to return all favorite albums
    public List<FavoriteAlbum> getAllFavoriteAlbums() {
        return favoriteAlbumRepository.findAll();
    }

    //All of the following functions are created as highlighted in the repository file.
    public Optional<FavoriteAlbum> getFavoriteByDiscogsId(String discogsId) {
        return favoriteAlbumRepository.findByDiscogsId(discogsId);
    }

    public boolean isFavorited(String discogsId) {
        return favoriteAlbumRepository.existsByDiscogsId(discogsId);
    }

    @Transactional
    public void removeFavorite(String discogsId) {
        favoriteAlbumRepository.deleteByDiscogsId(discogsId);
    }
}
