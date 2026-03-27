package org.leighbeebit.music_clinic_backend.controllers;

import org.leighbeebit.music_clinic_backend.services.DiscogsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/discogs")
public class DiscogsController {

    @Autowired
    private DiscogsService discogsService;

    @GetMapping("/search")
    public ResponseEntity<Map<String, Object>> searchAlbums(@RequestParam String query) {
        return ResponseEntity.ok(discogsService.searchAlbums(query));
    }

    @GetMapping("/albums/{releaseId}")
    public ResponseEntity<Map<String, Object>> getAlbumDetails(@PathVariable String releaseId) {
        return ResponseEntity.ok(discogsService.getAlbumDetails(releaseId));
    }
}