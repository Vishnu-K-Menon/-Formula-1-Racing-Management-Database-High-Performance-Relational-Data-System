-- 1. Seasons
CREATE TABLE Seasons (
  season_id   SERIAL PRIMARY KEY,
  season_year INT    NOT NULL UNIQUE,
  description TEXT
);

-- 2. Drivers
CREATE TABLE Drivers (
  driver_id   SERIAL PRIMARY KEY,
  first_name  VARCHAR(100) NOT NULL,
  last_name   VARCHAR(100) NOT NULL,
  nationality VARCHAR(100),
  birth_date  DATE
);

-- 3. Teams
CREATE TABLE Teams (
  team_id       SERIAL PRIMARY KEY,
  team_name     VARCHAR(100) NOT NULL UNIQUE,
  base_location VARCHAR(100)
);

-- 4. Circuits
CREATE TABLE Circuits (
  circuit_id   SERIAL PRIMARY KEY,
  circuit_name VARCHAR(100) NOT NULL UNIQUE,
  location     VARCHAR(100),
  country      VARCHAR(100)
);

-- 5. Races
CREATE TABLE Races (
  race_id      SERIAL PRIMARY KEY,
  season_id    INT    NOT NULL,
  race_name    VARCHAR(100) NOT NULL,
  circuit_id   INT    NOT NULL,
  race_date    DATE   NOT NULL,
  round_number INT,
  FOREIGN KEY (season_id)  REFERENCES Seasons(season_id)  ON DELETE RESTRICT,
  FOREIGN KEY (circuit_id) REFERENCES Circuits(circuit_id) ON DELETE RESTRICT
);

-- 6. RaceResults
CREATE TABLE RaceResults (
  race_id            INT NOT NULL,
  driver_id          INT NOT NULL,
  team_id            INT NOT NULL,
  finishing_position INT NOT NULL CHECK (finishing_position > 0),
  points_awarded     DECIMAL(5,2) NOT NULL CHECK (points_awarded >= 0),
  fastest_lap_time   TIME,
  PRIMARY KEY (race_id, driver_id),
  FOREIGN KEY (race_id)   REFERENCES Races(race_id)     ON DELETE CASCADE,
  FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id) ON DELETE CASCADE,
  FOREIGN KEY (team_id)   REFERENCES Teams(team_id)     ON DELETE CASCADE
);

-- 7. QualifyingResults
CREATE TABLE QualifyingResults (
  race_id             INT NOT NULL,
  driver_id           INT NOT NULL,
  qualifying_position INT NOT NULL CHECK (qualifying_position > 0),
  qualifying_time     TIME    NOT NULL,
  PRIMARY KEY (race_id, driver_id),
  FOREIGN KEY (race_id)   REFERENCES Races(race_id)     ON DELETE CASCADE,
  FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id) ON DELETE CASCADE
);

-- 8. PitStops
CREATE TABLE PitStops (
  pit_stop_id   SERIAL PRIMARY KEY,
  race_id       INT    NOT NULL,
  driver_id     INT    NOT NULL,
  pit_stop_number INT  NOT NULL CHECK (pit_stop_number > 0),
  pit_stop_time TIME   NOT NULL,
  laps_completed INT   NOT NULL CHECK (laps_completed >= 0),
  FOREIGN KEY (race_id)   REFERENCES Races(race_id)     ON DELETE CASCADE,
  FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id) ON DELETE CASCADE
);

-- 9. Penalties
CREATE TABLE Penalties (
  penalty_id     SERIAL PRIMARY KEY,
  race_id        INT    NOT NULL,
  driver_id      INT    NOT NULL,
  penalty_type   VARCHAR(50) NOT NULL,
  penalty_points INT         NOT NULL CHECK (penalty_points >= 0),
  description    TEXT,
  FOREIGN KEY (race_id)   REFERENCES Races(race_id)     ON DELETE CASCADE,
  FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id) ON DELETE CASCADE
);

-- 10. TeamStandings
CREATE TABLE TeamStandings (
  standing_id  SERIAL PRIMARY KEY,
  season_id    INT    NOT NULL,
  team_id      INT    NOT NULL,
  total_points DECIMAL(7,2) NOT NULL DEFAULT 0,
  rank         INT,
  FOREIGN KEY (season_id) REFERENCES Seasons(season_id) ON DELETE CASCADE,
  FOREIGN KEY (team_id)   REFERENCES Teams(team_id)     ON DELETE CASCADE,
  UNIQUE (season_id, team_id)
);
