-- Loo meeskonnaliikmete tabel
CREATE TABLE team_members (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(100),
    week INT DEFAULT 0,
    joined_at TIMESTAMP DEFAULT NOW()
);

-- Lisa tabelisse meeskonnaliikmed
INSERT INTO team_members (name, role, week)
VALUES 
('Andres Assuküll', 'Andmeanalüütik', 0)
('Nele Kund', 'Andmeanalüütik', 0);;

-- Kuva tabeli andmed
SELECT * FROM team_members;

-- Kuva nimi ja nädala roll
SELECT name, role_week1 FROM team_members ORDER BY name;
