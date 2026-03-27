package org.leighbeebit.music_clinic_backend.controllers;


import org.leighbeebit.music_clinic_backend.entities.AlbumRating;
import org.leighbeebit.music_clinic_backend.services.AlbumRatingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/album_ratings")
public class AlbumRatingController {

    @Autowired
    private AlbumRatingService albumRatingService;

    @PostMapping
    public ResponseEntity<AlbumRating> rateAlbum(@RequestBody AlbumRating rating) {
        return ResponseEntity.ok(albumRatingService.rateAlbum(rating));
    }

    @GetMapping
    public ResponseEntity<List<AlbumRating>> getAllAlbumRatings() {
        return ResponseEntity.ok(albumRatingService.getAllAlbumRatings());
    }

    @GetMapping("/{discogsId}")
    public ResponseEntity<AlbumRating> getRatingByDiscogsId(@PathVariable String discogsId) {
        return albumRatingService.getRatingByDiscogsId(discogsId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{discogsId}/exists")
    public ResponseEntity<Boolean> isRated(@PathVariable String discogsId) {
        return ResponseEntity.ok(albumRatingService.isRated(discogsId));
    }

    @PutMapping("/{discogsId}")
    public ResponseEntity<AlbumRating> updateRating(@PathVariable String discogsId, @RequestParam int rating) {
        return ResponseEntity.ok(albumRatingService.updateRating(discogsId, rating));
    }
}
