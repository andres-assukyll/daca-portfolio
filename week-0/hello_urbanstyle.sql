-- Minu esimene UrbanStyle püring
-- Nimi: Andres Assuküll
-- Kuupaev: 2026-12-8

CREATE TABLE IF NOT EXISTS team_members (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(100),
    week INT DEFAULT 0,
    joined_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO team_members (name, role, week) VALUES
('Andres Assuküll', 'Andmeanalüütik', 0);

SELECT * FROM team_members ORDER BY joined_at;

DELETE FROM team_members
WHERE id IN (14, 15);

SELECT * FROM team_members ORDER BY joined_at;
