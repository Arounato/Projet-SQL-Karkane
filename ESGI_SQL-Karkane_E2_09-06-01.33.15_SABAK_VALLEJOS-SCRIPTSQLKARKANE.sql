-- Lévy SABAK - Andres VALLEJOS

CREATE DATABASE karkane_db;
USE karkane_db;

SELECT * FROM Joueur;
SELECT * FROM Personnage;
SELECT * FROM Territoire;
SELECT * FROM Ville;
SELECT * FROM Boutique;
SELECT * FROM Teleporteur;
SELECT * FROM Inventaire;
SELECT * FROM Creature;
SELECT * FROM Scoring;
SELECT * FROM Chasse;

CREATE TABLE Joueur (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,     -- Email du joueur
    DateNaissance DATE NOT NULL,            -- Date de naissance du joueur
    MotDePasse VARCHAR(255) NOT NULL,       -- Mot de passe du joueur
    DateConnexion DATETIME                  -- Dernière date de connexion
);

-- [EXEMPLE JOUEURS] Insertion des données des joueurs
INSERT INTO Joueur (email, DateNaissance, MotDePasse, DateConnexion) VALUES
('arthas@yahoo.com', '1990-03-12', 'password123', '2023-08-01 14:30:00'), -- JoueurId 1
('morgana@gmail.com', '1992-07-25', 'securepassword', '2023-08-01 15:45:00'), -- JoueurId 2
('tyrion@gmail.com', '1988-11-05', 'password456', '2023-08-01 16:20:00'), -- JoueurId 3
('elena@hotmail.com', '1995-01-20', 'magicword', '2023-08-01 17:10:00'), -- JoueurId 4
('galdor@wanadoo.com', '1985-05-15', 'hammerpower', '2023-08-01 18:00:00'), -- JoueurId 5
('lyanna@yahoo.com', '1993-10-30', 'shadowhunter', '2023-08-01 19:00:00'); -- JoueurId 6


-- Création de la table de jonction : Possède (Joueur - Personnage)
CREATE TABLE Possede (
    JoueurId INT,
    PersonnageId INT,
    PRIMARY KEY (JoueurId, PersonnageId),
    FOREIGN KEY (JoueurId) REFERENCES Joueur(Id),
    FOREIGN KEY (PersonnageId) REFERENCES Personnage(Id)
);


CREATE TABLE Personnage (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nom VARCHAR(255) NOT NULL,              -- Nom du personnage
    Genre ENUM('H', 'F') NOT NULL,          -- Genre du personnage (H pour homme, F pour femme)
    Archetype ENUM('Guerrier', 'Assassin', 'Mage', 'Exorciste', 'Sorciere') NOT NULL,  -- Archétype du personnage
    Competences JSON NOT NULL,              -- Compétences sous forme de JSON (par exemple, {"attaque": 50, "defense": 30})
    PointsDeVie INT DEFAULT 100,            -- Points de vie du personnage
    PositionX DECIMAL(10, 2),               -- Position X du personnage
    PositionY DECIMAL(10, 2),               -- Position Y du personnage
    JoueurId INT,                           -- ID du joueur associé au personnage
    FOREIGN KEY (JoueurId) REFERENCES Joueur(Id)  -- Clé étrangère vers la table Joueur
);

-- [EXEMPLE PERSONNAGES] Attribution et insertion des noms des personnage en fonction du genre, de l'archetype, des compétences, des points de vie, de la position X et Y et son numéro d'identification dans le jeu
INSERT INTO Personnage (Nom, Genre, Archetype, Competences, PointsDeVie, PositionX, PositionY, JoueurId) VALUES
('Arthas', 'H', 'Guerrier', '{"attaque": 70, "defense": 50, "magie": 10, "guerison": 20}', 100, 15.50, 25.75, 1), -- JoueurId 1
('Morgana', 'F', 'Sorciere', '{"attaque": 20, "defense": 30, "magie": 80, "guerison": 40}', 100, 25.40, 35.60, 2), -- JoueurId 2
('Tyrion', 'H', 'Assassin', '{"attaque": 80, "defense": 60, "magie": 5, "guerison": 10}', 100, 35.25, 45.55, 3), -- JoueurId 3
('Elena', 'F', 'Mage', '{"attaque": 50, "defense": 40, "magie": 90, "guerison": 30}', 100, 45.60, 55.70, 4), -- JoueurId 4
('Galdor', 'H', 'Exorciste', '{"attaque": 60, "defense": 40, "magie": 70, "guerison": 60}', 100, 55.50, 65.80, 5), -- JoueurId 5
('Lyanna', 'F', 'Assassin', '{"attaque": 85, "defense": 65, "magie": 15, "guerison": 25}', 100, 65.75, 75.90, 6); -- JoueurId 6


CREATE TABLE Territoire (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nom VARCHAR(255) NOT NULL, -- Nom du territoire
    Description TEXT,
    PositionX DECIMAL(10, 2),
    PositionY DECIMAL(10, 2)
);

-- [EXEMPLE TERRITOIRES] Attribution des noms des territoires en fonction de la position X et Y
INSERT INTO Territoire (Nom, Description, PositionX, PositionY) VALUES
('U’shil', 'Description du territoire U’shil', 12.34, 45.67),
('Zuete', 'Description du territoire Zuete', 23.45, 67.89),
('Bawheycor', 'Description du territoire Bawheycor', 34.56, 78.90),
('Suwat', 'Description du territoire Suwat', 45.67, 89.01),
('Voshium', 'Description du territoire Voshium', 56.78, 90.12),
('Ograx', 'Description du territoire Ograx', 67.89, 12.34);


CREATE TABLE Inventaire (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nom VARCHAR(255) NOT NULL,               -- Nom de l'objet dans l'inventaire
    Type ENUM('Arme', 'Bouclier', 'Potion', 'Nourriture', 'Carte', 'Clef') NOT NULL,  -- Type de l'objet
    Description TEXT,                        -- Description de l'objet
    Puissance INT,                           -- Puissance de l'arme ou de l'objet
    Usure INT DEFAULT 0,                     -- Pourcentage d'usure de l'objet (0% à 100%)
    Effet TEXT,                              -- Effet particulier de l'objet
    PositionX DECIMAL(10, 2),                -- Position X de l'objet si applicable
    PositionY DECIMAL(10, 2),                -- Position Y de l'objet si applicable
    PersonnageId INT,                        -- ID du personnage possédant cet objet
    FOREIGN KEY (PersonnageId) REFERENCES Personnage(Id)  -- Clé étrangère vers la table Personnage
);

-- Insertion des objets dans l'inventaire des personnages
INSERT INTO Inventaire (Nom, Type, Description, Puissance, Usure, Effet, PositionX, PositionY, PersonnageId) VALUES
-- Inventaire pour Arthas (JoueurId 1)
('Durandalus', 'Arme', 'Épée légendaire à deux mains', 90, 10, 'Augmente les points de vie de 20%', 15.55, 25.80, 1),
('Bouclier du Dragon', 'Bouclier', 'Bouclier magique résistant au feu', 50, 5, 'Réduit les dégâts de feu de 50%', 15.60, 25.85, 1),

-- Inventaire pour Morgana (JoueurId 2)
('Bâton de Sombreflamme', 'Arme', 'Bâton magique enflammé', 70, 0, 'Augmente la puissance des sorts de feu de 30%', 25.45, 35.65, 2),
('Potion de Mana', 'Potion', 'Restaure 50 points de mana', NULL, 0, 'Restaure instantanément du mana', 25.50, 35.70, 2),

-- Inventaire pour Tyrion (JoueurId 3)
('Dague des Ombres', 'Arme', 'Dague rapide pour attaques furtives', 60, 20, 'Augmente les chances de coup critique de 25%', 35.30, 45.60, 3),
('Potion Invisibilité', 'Potion', 'Rend invisible pendant 30 secondes', NULL, 0, 'Permet de se cacher des ennemis', 35.35, 45.65, 3),

-- Inventaire pour Elena (JoueurId 4)
('Sceptre Énergie', 'Arme', 'Sceptre canalisant énergie magique', 80, 0, 'Augmente la puissance magique de 40%', 45.65, 55.75, 4),
('Tome de Soin', 'Potion', 'Livre ancien de guérison', NULL, 0, 'Restaure 100 points de vie', 45.70, 55.80, 4),

-- Inventaire pour Galdor (JoueurId 5)
('Marteau Sacré', 'Arme', 'Marteau sacré utilisé pour exorciser les démons', 75, 5, 'Dégâts supplémentaires contre les créatures démoniaques', 55.55, 65.85, 5),
('Amulette de Protection', 'Bouclier', 'Amulette magique qui protège contre les sorts', 40, 0, 'Réduit les dégâts magiques de 20%', 55.60, 65.90, 5),

-- Inventaire pour Lyanna (JoueurId 6)
('Arc de Aube', 'Arme', 'Arc puissant capable de tirer des flèches enflammées', 85, 15, 'Les flèches enflammées infligent des dégâts sur la durée', 65.80, 75.95, 6),
('Cape Évasion', 'Bouclier', 'Cape permettant éviter les attaques', 30, 10, 'Augmente les chances esquive de 20%', 65.85, 76.00, 6);


CREATE TABLE Scoring (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    TypeEvenement VARCHAR(50) NOT NULL,    -- Type d'événement qui a généré le score
    Points INT NOT NULL,                   -- Nombre de points gagnés
    DateEvenement DATETIME NOT NULL,       -- Date et heure de l'événement
    PersonnageId INT,                      -- ID du personnage qui a réalisé l'événement
    FOREIGN KEY (PersonnageId) REFERENCES Personnage(Id)  -- Clé étrangère vers la table Personnage
);


-- Création de la table de jonction : Réalisé_par (Personnage - Scoring)
CREATE TABLE Realise_par (
    PersonnageId INT,
    ScoringId INT,
    PRIMARY KEY (PersonnageId, ScoringId),
    FOREIGN KEY (PersonnageId) REFERENCES Personnage(Id),
    FOREIGN KEY (ScoringId) REFERENCES Scoring(Id)
);


-- [EXEMPLE SCORING] Insertion des noms des Evenements en fonction des points gagnés, de la date de l'évenement et l'ID du personnage
INSERT INTO Scoring (TypeEvenement, Points, DateEvenement, PersonnageId) VALUES
-- Scoring pour Arthas (PersonnageId 1)
('Victoire sur un boss', 500, '2023-08-01 14:45:00', 1),
('Quête accomplie', 200, '2023-08-01 15:30:00', 1),

-- Scoring pour Morgana (PersonnageId 2)
('Sort réussi', 150, '2023-08-01 15:55:00', 2),
('Victoire sur un ennemi', 100, '2023-08-01 16:10:00', 2),

-- Scoring pour Tyrion (PersonnageId 3)
('Assassinat réussi', 300, '2023-08-01 16:25:00', 3),
('Événement spécial', 250, '2023-08-01 16:40:00', 3),

-- Scoring pour Elena (PersonnageId 4)
('Sort puissant', 350, '2023-08-01 17:20:00', 4),
('Quête magique accomplie', 400, '2023-08-01 17:45:00', 4),

-- Scoring pour Galdor (PersonnageId 5)
('Exorcisme réussi', 450, '2023-08-01 18:10:00', 5),
('Victoire sur un démon', 300, '2023-08-01 18:30:00', 5),

-- Scoring pour Lyanna (PersonnageId 6)
('Flèche enflammée critique', 250, 'f2023-08-01 19:15:00', 6),
('Quête furtive accomplie', 300, '2023-08-01 19:40:00', 6);


CREATE TABLE Creature (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nom VARCHAR(255) NOT NULL,               -- Nom de la créature
    Type ENUM('Blob', 'Orc', 'Ogre', 'Boss') NOT NULL, -- Type de créature
    TypeAttaque VARCHAR(50),                 -- Type d'attaque de la créature
    ModeDeplacement VARCHAR(50),             -- Mode de déplacement (ex: vol, marche)
    PointsDeVie INT,                         -- Points de vie de la créature
    PositionX DECIMAL(10, 2),                -- Position X de la créature
    PositionY DECIMAL(10, 2),                -- Position Y de la créature
    TerritoireId INT,                        -- ID du territoire auquel la créature est associée
    FOREIGN KEY (TerritoireId) REFERENCES Territoire(Id)  -- Clé étrangère vers le territoire
);


-- [EXEMPLE CRÉATURES] Insertion des noms des créatures en fonction de la position X et Y et l'ID du territoire
INSERT INTO Creature (Nom, Type, TypeAttaque, ModeDeplacement, PointsDeVie, PositionX, PositionY, TerritoireId) VALUES
-- Créatures associées à U’shil
('Blob', 'blob', 'Acide', 'Rampant', 100, 10.50, 20.30, 1), -- U’shil
('Orc', 'Orc', 'Croc', 'Marche', 200, 12.30, 22.10, 1), -- U’shil

-- Créatures associées à Zuete
('Ogre', 'ogre', 'Massue', 'Marche', 300, 23.45, 32.10, 2), -- Zuete

-- Créatures associées à Bawheycor
('Orc', 'orc', 'Croc', 'Marche', 150, 30.25, 40.50, 3), -- Bawheycor
('Blob', 'blob', 'Acide', 'Rampant', 80, 32.75, 42.00, 3), -- Bawheycor

-- Créatures associées à Suwat
('Blob', 'blob', 'Acide', 'Rampant', 90, 40.30, 50.60, 4), -- Suwat
('Orc', 'orc', 'Croc', 'Marche', 170, 42.10, 52.40, 4), -- Suwat

-- Créatures associées à Voshium
('Ogre', 'ogre', 'Massue', 'Marche', 320, 50.45, 60.70, 5), -- Voshium

-- Créatures associées à Ograx
('Boss', 'boss', 'Feu', 'Vol', 500, 60.60, 70.80, 6), -- Ograx
('Blob', 'blob', 'Acide', 'Rampant', 110, 62.50, 72.30, 6); -- Ograx

-- Si le personnage souhaite combattre plusieurs créatures
CREATE TABLE Chasse (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    PersonnageId INT NOT NULL,                      -- ID du personnage qui chasse
    CreatureId INT NOT NULL,                        -- ID de la créature chassée
    DateChasse DATETIME NOT NULL,                   -- Date et heure de l'événement de chasse
    NombreCreatures INT NOT NULL DEFAULT 1,         -- Nombre de créatures chassées lors de l'événement
    TerritoireId INT,                               -- ID du territoire où la chasse a eu lieu
    FOREIGN KEY (PersonnageId) REFERENCES Personnage(Id),  -- Clé étrangère vers la table Personnage
    FOREIGN KEY (CreatureId) REFERENCES Creature(Id),      -- Clé étrangère vers la table Creature
    FOREIGN KEY (TerritoireId) REFERENCES Territoire(Id)   -- Clé étrangère vers la table Territoire
);

-- [EXEMPLE CHASSE] Insertion de l'ID des personnages en fonction de la date des créatures tuées et l'ID du territoire où elles sont mortes
INSERT INTO Chasse (PersonnageId, CreatureId, DateChasse, NombreCreatures, TerritoireId) VALUES
-- Chasses réalisées par Arthas (PersonnageId 1) dans U’shil (TerritoireId 1)
(1, 1, '2023-08-01 14:45:00', 3, 1),  -- Arthas chasse 3 Blobs
(1, 2, '2023-08-01 15:00:00', 1, 1),  -- Arthas chasse 1 Orc

-- Chasses réalisées par Morgana (PersonnageId 2) dans Zuete (TerritoireId 2)
(2, 3, '2023-08-01 16:00:00', 1, 2),  -- Morgana chasse 1 Ogre

-- Chasses réalisées par Tyrion (PersonnageId 3) dans Bawheycor (TerritoireId 3)
(3, 4, '2023-08-01 17:00:00', 2, 3),  -- Tyrion chasse 2 Orcs
(3, 5, '2023-08-01 17:30:00', 1, 3),  -- Tyrion chasse 1 Blob

-- Chasses réalisées par Elena (PersonnageId 4) dans Suwat (TerritoireId 4)
(4, 6, '2023-08-01 18:00:00', 1, 4),  -- Elena chasse 1 Blob

-- Chasses réalisées par Galdor (PersonnageId 5) dans Voshium (TerritoireId 5)
(5, 7, '2023-08-01 19:00:00', 1, 5),  -- Galdor chasse 1 Ogre

-- Chasses réalisées par Lyanna (PersonnageId 6) dans Ograx (TerritoireId 6)
(6, 9, '2023-08-01 20:00:00', 1, 6),  -- Lyanna chasse 1 Boss
(6, 10, '2023-08-01 20:15:00', 3, 6); -- Lyanna chasse 3 Blobs


CREATE TABLE Ville (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nom VARCHAR(255) NOT NULL,  -- Nom de la ville
    Type VARCHAR(50),           -- Type de la ville (capitale, village, etc.)
    PositionX DECIMAL(10, 2),   -- Position X de la ville
    PositionY DECIMAL(10, 2),   -- Position Y de la ville
    TerritoireId INT,           -- Référence au territoire
    FOREIGN KEY (TerritoireId) REFERENCES Territoire(Id),
    BoutiqueId INT,           -- Référence au territoire
    FOREIGN KEY (BoutiqueId) REFERENCES Boutique(Id)
);

-- [EXEMPLE VILLES] Insertion des noms des villes en fonction de la position X et Y et l'ID du territoire
INSERT INTO Ville (Nom, Type, PositionX, PositionY, TerritoireId) VALUES
-- Territoire: U’shil
('Jer’Emy', 'Ville', 10.25, 20.35, 1),
('Vir’Ginie', 'Capitale', 12.50, 21.75, 1),
('R’Minio', 'Village', 14.30, 22.90, 1),

-- Territoire: Zuete
('Plailon', 'Capitale', 75.10, 18.55, 2),
('Camur', 'village', 76.25, 19.85, 2),
('Bellet', 'Ville', 77.30, 20.90, 2),

-- Territoire: Bawheycor
('Vayon', 'Ville', 33.21, 53.78, 3),
('Marrac', 'Ville', 35.00, 55.00, 3),
('Gossion', 'Village', 36.45, 56.12, 3),
('Colzon', 'Capitale', 34.87, 51.34, 3),
('Marippe', 'Village', 36.45, 56.12, 3),

-- Territoire: Suwat
('Richnou', 'Village', 15.67, 25.89, 4),
('Roaluire', 'Ville', 16.12, 27.34, 4),
('Marisart', 'Capitale', 17.45, 28.12, 4),

-- Territoire: Voshium
('Goba', 'Capitale', 56.12, 65.34, 5),
('Vinzieu', 'Ville', 57.23, 66.45, 5),

-- Territoire: Ograx
('Sarlimar', 'Ville', 67.45, 14.23, 6),
('Puya', 'Capitale', 68.50, 15.75, 6),
('Parac', 'Village', 66.78, 13.87, 6);


CREATE TABLE Boutique (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nom VARCHAR(255) NOT NULL,      -- Nom de la boutique
    Type ENUM('Potion', 'Arme', 'Bouclier', 'Nourriture', 'Divers') NOT NULL,  -- Type de boutique
    PositionX DECIMAL(10, 2),       -- Position X de la boutique
    PositionY DECIMAL(10, 2),       -- Position Y de la boutique
    VilleId INT,                    -- ID de la ville à laquelle la boutique est associée
    FOREIGN KEY (VilleId) REFERENCES Ville(Id)  -- Clé étrangère vers la ville
);

-- [EXEMPLE BOUTIQUE] Insertion des noms des éléments d'inventaire en fonction de la position X et Y et l'ID de la ville
INSERT INTO Boutique (Nom, Type, PositionX, PositionY, VilleId) VALUES
-- Boutiques associées à la ville dans U’shil
('La Boutique Magique', 'Potion', 12.50, 25.30, 1), -- VilleId 1 correspond à une ville d’U’shil
('Armurerie du Nord', 'Arme', 14.30, 26.50, 1), -- VilleId 1 correspond à une ville d’U’shil

-- Boutiques associées à la ville dans Zuete
('Bouclier Doré', 'Bouclier', 24.40, 35.20, 2), -- VilleId 2 correspond à une ville de Zuete

-- Boutiques associées à la ville dans Bawheycor
('Epicierie Locale', 'Nourriture', 32.25, 45.55, 3), -- VilleId 3 correspond à une ville de Bawheycor
('Forge du Guerrier', 'Arme', 33.75, 46.00, 3), -- VilleId 3 correspond à une ville de Bawheycor

-- Boutiques associées à la ville dans Suwat
('Potion Eau', 'Potion', 42.40, 55.60, 4), -- VilleId 4 correspond à une ville de Suwat

-- Boutiques associées à la ville dans Voshium
('Bouclier de la Nuit', 'Bouclier', 52.50, 65.40, 5), -- VilleId 5 correspond à une ville de Voshium

-- Boutiques associées à la ville dans Ograx
('La Broc des Povre', 'Divers', 62.60, 75.80, 6); -- VilleId 6 correspond à une ville de Ograx


CREATE TABLE Teleporteur (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Nom VARCHAR(255) NOT NULL,      -- Nom du téléporteur
    PositionX DECIMAL(10, 2),       -- Position X du téléporteur
    PositionY DECIMAL(10, 2),       -- Position Y du téléporteur
    TerritoireId INT,               -- ID du territoire auquel le téléporteur est associé
    FOREIGN KEY (TerritoireId) REFERENCES Territoire(Id)  -- Clé étrangère vers le territoire
);

-- [EXEMPLE TELEPORTEURS] Insertion des noms des teleporteurs en fonction de la position X et Y et l'ID du territoire
INSERT INTO Teleporteur (Nom, PositionX, PositionY, TerritoireId) VALUES
-- Téléporteurs associés à U’shil
('Portail des Brumes', 15.50, 25.75, 1), -- TerritoireId 1 correspond à U’shil

-- Téléporteurs associés à Zuete
('Portail du Nord', 25.40, 35.60, 2), -- TerritoireId 2 correspond à Zuete

-- Téléporteurs associés à Bawheycor
('Portail des Montagnes', 35.25, 45.55, 3), -- TerritoireId 3 correspond à Bawheycor

-- Téléporteurs associés à Suwat
('Portail de la Mer', 45.60, 55.70, 4), -- TerritoireId 4 correspond à Suwat

-- Téléporteurs associés à Voshium
('Portail Ombre', 55.50, 65.80, 5), -- TerritoireId 5 correspond à Voshium

-- Téléporteurs associés à Ograx
('Portail du Feu', 65.75, 75.90, 6); -- TerritoireId 6 correspond à Ograx
