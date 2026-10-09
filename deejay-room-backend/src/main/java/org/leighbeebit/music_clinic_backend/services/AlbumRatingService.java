package org.leighbeebit.music_clinic_backend.services;


import jakarta.transaction.Transactional;
import org.leighbeebit.music_clinic_backend.entities.AlbumRating;
import org.leighbeebit.music_clinic_backend.repositories.AlbumRatingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AlbumRatingService {

    @Autowired
    private AlbumRatingRepository albumRatingRepository;

    //Creates the rating, or updates it if this album was already rated
    public AlbumRating rateAlbum(AlbumRating rating) {
        return albumRatingRepository.findByDiscogsId(rating.getDiscogsId())
                .map(existing -> {
                    existing.setRating(rating.getRating());
                    return albumRatingRepository.save(existing);
                })
                .orElseGet(() -> albumRatingRepository.save(rating));
    }

    public List<AlbumRating> getAllAlbumRatings() {
        return albumRatingRepository.findAll();
    }

    public Optional<AlbumRating> getRatingByDiscogsId(String discogsId) {
        return albumRatingRepository.findByDiscogsId(discogsId);
    }

    public boolean isRated(String discogsId) {
        return albumRatingRepository.existsByDiscogsId(discogsId);
    }

    public AlbumRating updateRating(String discogsId, int newRating) {
        AlbumRating existing = albumRatingRepository.findByDiscogsId(discogsId)
                .orElseThrow(() -> new RuntimeException("Rating not found"));
        existing.setRating(newRating);
        return albumRatingRepository.save(existing);
    }

    @Transactional
    public void removeRating(String discogsId) {
        albumRatingRepository.deleteByDiscogsId(discogsId);
    }
}
