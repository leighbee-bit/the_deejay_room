package org.leighbeebit.music_clinic_backend.services;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import java.util.Map;

@Service
public class DiscogsService {

    @Value("${discogs.token}")
    private String discogsToken;

    private final RestTemplate restTemplate = new RestTemplate();
    private static final String BASE_URL = "https://api.discogs.com";

    public Map<String, Object> searchAlbums(String query) {
        String url = BASE_URL + "/database/search?q=" + query + "&type=release&per_page=20";
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Discogs token=" + discogsToken);
        headers.set("User-Agent", "MusicClinicApp/1.0");
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.GET, entity, Map.class);
        return response.getBody();
    }

    public Map<String, Object> getAlbumDetails(String releaseId) {
        String url = BASE_URL + "/releases/" + releaseId;
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Discogs token=" + discogsToken);
        headers.set("User-Agent", "MusicClinicApp/1.0");
        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.GET, entity, Map.class);
        return response.getBody();
    }
}