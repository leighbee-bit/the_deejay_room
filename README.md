# 🎧 The Deejay Room

An iOS app for digging through records. Search the [Discogs](https://www.discogs.com) music database by album, artist or genre, browse cover art and release details, and build a list of favorite albums.

Built with a **SwiftUI** iOS app and a **Spring Boot** REST API backed by **PostgreSQL**.

## Features

- **Record search:** search Discogs by any combination of album, artist and genre. Duplicate pressings of the same album are collapsed into one result.
- **Album details:** cover art, artist and release year
- **Favorites:** save albums from the detail screen and view them all on the Favorites page
- **Swipe to remove:** swipe left (or long-press) on a favorite to remove it
- **Server-side API key:** the app never sees the Discogs token. All Discogs requests go through the backend.

## Tech Stack

| Layer | Technology |
|---|---|
| iOS app | Swift, SwiftUI, async/await `URLSession` |
| Backend | Spring Boot 4, Spring Data JPA / Hibernate, Lombok |
| Database | PostgreSQL (local or Amazon RDS) |
| External API | Discogs API |
| Language & build | Java 25 + Maven (wrapper included), Xcode / iOS 26.2 |

## How It Works

```
SwiftUI app  ──HTTP──▶  Spring Boot API  ──JDBC──▶  PostgreSQL
                             │
                             └──HTTPS──▶  Discogs API
```

1. **iOS app:** SwiftUI screens call the backend through `APIService`. The backend address is set in `Config.swift`.
2. **Backend:** forwards searches to Discogs using a server-side token, and stores favorites and ratings in Postgres. It follows a controller → service → repository structure.
3. **Database:** Hibernate creates and updates the tables automatically.

## Project Structure

```
ios-app/
├── The Deejay Room.xcodeproj
├── Config.swift.example              template for the backend address
└── The Deejay Room Files/
    ├── Screens/                      SwiftUI views (search, results, detail, favorites)
    └── Mechanics and Assets/         APIService, Album model, Config, assets

backend/
└── src/main/java/org/leighbeebit/music_clinic_backend/
    ├── controllers/                  REST endpoints
    ├── services/                     business logic + Discogs client
    ├── repositories/                 Spring Data JPA repositories
    └── entities/                     FavoriteAlbum, AlbumRating
```

## Running Locally

### Prerequisites

- **macOS with Xcode** (iOS 26.2 SDK)
- **JDK 25**
- **PostgreSQL**: a local install (e.g. [Postgres.app](https://postgresapp.com)) or an Amazon RDS instance
- **Discogs personal access token**: generate one at [discogs.com/settings/developers](https://www.discogs.com/settings/developers)

### 1. Create the database

```sql
CREATE DATABASE deejay_room;
```

You don't need to create any tables. Hibernate creates them when the backend first starts.

### 2. Configure and run the backend

Set these environment variables in your shell or your IDE's run configuration:

| Variable | Example |
|---|---|
| `DB_URL` | `jdbc:postgresql://localhost:5432/deejay_room` |
| `DB_USERNAME` | your database user |
| `DB_PASSWORD` | your database password |
| `DISCOGS_TOKEN` | your Discogs personal access token |

For Amazon RDS, use your instance endpoint and add `?sslmode=require` to `DB_URL`.

Then start the backend:

```bash
cd backend
./mvnw spring-boot:run
```

The API runs on `http://localhost:8080`.

### 3. Point the app at the backend

`Config.swift` holds the backend address. It's gitignored, so create your own copy from the template:

```bash
cp ios-app/Config.swift.example "ios-app/The Deejay Room Files/Mechanics and Assets/Config.swift"
```

- **iOS Simulator:** keep `http://localhost:8080`.
- **Physical iPhone:** use your Mac's IP address (find it with `ipconfig getifaddr en0`) and make sure the phone is on the same Wi-Fi. When iOS asks to find devices on your local network, tap **Allow**.

### 4. Run the app

Open `ios-app/The Deejay Room.xcodeproj` in Xcode, choose a simulator or your device, and press **Run**. To run on a physical iPhone, select your own team under *Signing & Capabilities*.

## API Reference

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/discogs/search?query=` | Search Discogs releases |
| GET | `/api/discogs/{releaseId}` | Get a Discogs release |
| GET | `/api/favorites` | List favorite albums |
| POST | `/api/favorites` | Save a favorite |
| GET | `/api/favorites/{discogsId}` | Get a favorite |
| GET | `/api/favorites/{discogsId}/exists` | Check whether an album is favorited |
| DELETE | `/api/favorites/{discogsId}` | Remove a favorite |
| POST | `/api/album_ratings` | Rate an album |
| GET | `/api/album_ratings` | List ratings |
| GET | `/api/album_ratings/{discogsId}` | Get an album's rating |
| GET | `/api/album_ratings/{discogsId}/exists` | Check whether an album is rated |

Album ratings are supported by the API but don't have a screen in the app yet.

## Credits

- Music data from the [Discogs API](https://www.discogs.com/developers). This app uses Discogs' API but is not affiliated with, sponsored or endorsed by Discogs.
