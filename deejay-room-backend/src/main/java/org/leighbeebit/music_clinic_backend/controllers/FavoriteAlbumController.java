package org.leighbeebit.music_clinic_backend.controllers;


import org.leighbeebit.music_clinic_backend.entities.FavoriteAlbum;
import org.leighbeebit.music_clinic_backend.services.FavoriteAlbumService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/favorites")
public class FavoriteAlbumController {

    @Autowired
    private FavoriteAlbumService favoriteAlbumService;

    @PostMapping
    public ResponseEntity<FavoriteAlbum> saveFavorite(@RequestBody FavoriteAlbum favoriteAlbum) {
        return ResponseEntity.ok(favoriteAlbumService.saveFavorite(favoriteAlbum));
    }

    @GetMapping
    public ResponseEntity<List<FavoriteAlbum>> getAllFavoriteAlbums() {
        return ResponseEntity.ok(favoriteAlbumService.getAllFavoriteAlbums());
    }

    @GetMapping("/{discogsId}")
    public ResponseEntity<FavoriteAlbum> getFavoriteByDiscogsId(@PathVariable String discogsId) {
        return favoriteAlbumService.getFavoriteByDiscogsId(discogsId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{discogsId}/exists")
    public ResponseEntity<Boolean> isFavorited(@PathVariable String discogsId) {
        return ResponseEntity.ok(favoriteAlbumService.isFavorited(discogsId));
    }

    @DeleteMapping("/{discogsId}")
    public ResponseEntity<Void> removeFavorite(@PathVariable String discogsId) {
        favoriteAlbumService.removeFavorite(discogsId);
        return ResponseEntity.noContent().build();
    }
}
