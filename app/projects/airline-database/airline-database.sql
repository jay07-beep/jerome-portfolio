-- PORTFOLIO COPY
-- Academic airline database project (MariaDB / MySQL).
-- Demonstration names, emails, addresses, document numbers and passwords
-- were anonymised before publication. Database logic is otherwise preserved.

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mer. 18 déc. 2024 à 15:41
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `projet_vba_sql`
--
CREATE DATABASE IF NOT EXISTS `projet_vba_sql` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `projet_vba_sql`;

DELIMITER $$
--
-- Procédures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `1)a)` (IN `Annee` INT(5))   SELECT SUM(billet.prixBillet) AS "Bilan vente annuel", YEAR(vol.DateDepart) AS "Annee"
FROM billet
INNER JOIN vol ON billet.ID_vol= vol.ID_vol
WHERE YEAR(vol.DateDepart)=Annee OR YEAR(vol.DateDepart)=(Annee-1)
GROUP BY YEAR(vol.DateDepart)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `1)g)` (IN `idEmploye` VARCHAR(5), IN `idVol` VARCHAR(5), IN `Modifier_ou_Supprimer` VARCHAR(10))   BEGIN
CASE
WHEN Modifier_ou_Supprimer='MODIFIER' THEN
UPDATE affecter
SET affecter.ID_employe=idEmploye
WHERE affecter.ID_vol=idVol;
WHEN Modifier_ou_Supprimer='SUPPRIMER' THEN
DELETE FROM affecter
WHERE affecter.ID_employe=idEmploye AND affecter.ID_vol=idVol;
END CASE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `1e` ()   BEGIN
	DECLARE Date_du_jour DATE;
	SET Date_du_jour = CURRENT_DATE();
	SELECT vol.ID_vol,  vol.HeureArrivee, vol.HeureArriveeReelle
	FROM vol
	WHERE(vol.HeureArrivee!=vol.HeureArriveeReelle);
	SELECT entretien.ID_avion, entretien.DateEntretienPlanifie, entretien.DateRelleEntretien
    FROM entretien
	WHERE (entretien.DateRelleEntretien=0000-00-00) 
    AND (entretien.DateEntretienPlanifie<Date_du_jour);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `1h` (IN `type_vol` VARCHAR(50))   SELECT vol.ID_vol, passager.Nom
FROM vol
LEFT JOIN billet ON vol.ID_vol = billet.ID_vol
LEFT JOIN passager ON billet.ID_Passager = passager.ID_passager
WHERE vol.ID_TypeVol=type_vol$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `1l` ()   SELECT aeroport.NomA, COUNT(*)
FROM vol
LEFT JOIN aeroport ON vol.ID_aeroport_Atterir = aeroport.ID_aeroport
GROUP BY aeroport.ID_aeroport$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `2)a)` (IN `nvAdresseMail` VARCHAR(50), IN `nvAdressePostale` VARCHAR(50), IN `nvNom` VARCHAR(50), IN `nvPrenom` VARCHAR(50), IN `nvDateNaissance` DATE, IN `nvMdp` VARCHAR(50), IN `Creer_carte_fidelite` VARCHAR(50))   BEGIN
DECLARE dernier_numeroC INT; 
DECLARE nouvel_IDC VARCHAR(50);
DECLARE nouvel_IDCF VARCHAR(50);
DECLARE NBMiles INT;
SELECT MAX(CAST(SUBSTRING(ID_compte, 2) AS UNSIGNED)) 
INTO dernier_numeroC
FROM compte;
SET nouvel_IDC =CONCAT('C', dernier_numeroC +1);
INSERT INTO compte
VALUES (nouvel_IDC, nvAdresseMail, nvAdressePostale, nvNom, nvPrenom, nvDateNaissance, nvMdp);
IF Creer_carte_fidelite='OUI' THEN
SET nouvel_IDCF =CONCAT('CF', dernier_numeroC +1);
SET NBMiles = 0;
INSERT INTO cartefidelite
VALUES (nouvel_IDCF, NBMiles, nouvel_IDC);
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `2)c)` (IN `aeroportDepart` VARCHAR(50), IN `aeroportArrivee` VARCHAR(50))   SELECT vol.ID_vol AS 'ID du vol', 
vol.Prix, vol.heureDepart AS 'Heure de départ', 
vol.HeureArrivee AS 'Heure d arrivée', 
vol.DateDepart AS 'Date de départ', 
vol.DateArrivee AS 'Date d arrivée', 
CONCAT(vol.Distance, 'km') AS 'Distance parcourue', 
aeroport_depart.NomA AS 'Aéroport de départ', 
aeroport_arrivee.NomA AS 'Aéroport d arrivée', 
typevol.TypeVol AS 'Type de Vol', 
typeavion.TypeAvion AS 'Type d avion', 
CONCAT(vol.TempsEscal, 'h') AS 'Temps d escale', 
aeroport_arret.NomA AS 'Aéroport de correspondance',
GROUP_CONCAT( typerepas.TypeRepas SEPARATOR ', ') AS 'Repas proposé(s)', 
CONCAT(TIMESTAMPDIFF(HOUR,CONCAT(vol.DateDepart, ' ', vol.heureDepart),CONCAT(vol.DateArrivee, ' ', vol.HeureArrivee))+vol.TempsEscal,'h') AS 'Durée du vol'
FROM vol 
INNER JOIN aeroport AS aeroport_depart ON vol.ID_aeroport =aeroport_depart.ID_aeroport
INNER JOIN aeroport AS aeroport_arrivee ON vol.ID_aeroport_Atterir =aeroport_arrivee.ID_aeroport
INNER JOIN typevol ON vol.ID_TypeVol=typevol.ID_TypeVol
INNER JOIN avion ON vol.ID_avion = avion.ID_Avion
INNER JOIN typeavion ON avion.ID_TypeAvion = typeavion.ID_TypeAvion
INNER JOIN proposer ON vol.ID_vol = proposer.ID_vol
INNER JOIN aeroport AS aeroport_arret ON vol.ID_aeroport_Arreter =aeroport_arret.ID_aeroport
INNER JOIN typerepas ON proposer.ID_TypeRepas = typerepas.ID_TypeRepas
WHERE vol.ID_aeroport = aeroportDepart
AND vol.ID_aeroport_Atterir = aeroportArrivee
AND vol.DateArriveeReelle IS NULL
GROUP BY vol.ID_vol$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `2)e)` (IN `AdresseMail` VARCHAR(50), IN `MotDePasse` VARCHAR(50), IN `Supprimer_billet` VARCHAR(50), IN `idBillet` VARCHAR(50))   BEGIN
DECLARE commandeId VARCHAR(50);
DECLARE passagerId VARCHAR(50);
   IF Supprimer_billet='OUI' THEN
SET passagerId = (SELECT ID_passager FROM billet WHERE billet.ID_billet = idBillet);
SET commandeId = (SELECT ID_commande FROM appartenir WHERE appartenir.ID_passager = passagerId); 
 DELETE FROM appartenir
       WHERE appartenir.ID_passager = passagerId;        
 DELETE FROM commande
        WHERE commande.ID_commande = commandeId;
 DELETE FROM billet
        WHERE billet.ID_billet = idBillet;  
    END IF;
SELECT compte.ID_compte AS 'ID du compte', compte.NomC AS 'Nom', compte.PrenomC AS 'Prénom', billet.ID_billet AS 'ID billet(s)', passager.Nom AS 'Nom passager', passager.Prénom AS 'Prénom passager', billet.ID_vol AS 'ID vol(s)', CONCAT('Vol de ', aeroport_depart.NomA, ' à ', aeroport_arrivee.NomA) AS 'Trajet effectué'
FROM compte
INNER JOIN commande ON compte.ID_compte = commande.ID_Compte
INNER JOIN appartenir ON commande.ID_commande = appartenir.ID_commande
INNER JOIN billet ON appartenir.ID_passager = billet.ID_Passager
INNER JOIN passager ON billet.ID_Passager = passager.ID_passager
INNER JOIN vol ON billet.ID_vol = vol.ID_vol
INNER JOIN aeroport AS aeroport_depart ON vol.ID_aeroport =aeroport_depart.ID_aeroport
INNER JOIN aeroport AS aeroport_arrivee ON vol.ID_aeroport_Atterir =aeroport_arrivee.ID_aeroport
WHERE compte.adresseMail= AdresseMail
AND compte.Mdp= MotDePasse
AND vol.DateArriveeReelle IS NULL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `f` ()   BEGIN
	DECLARE nbRe INT;
    SET nbRe = 0;
    SELECT COUNT(*) INTO nbRe FROM retarder;
    SELECT nbRe;
SELECT TypeRetard.TypeRetard, (COUNT(TypeRetard.ID_typeRetard)/nbRe)*100
FROM retarder
LEFT JOIN typeretard ON typeretard.ID_typeRetard = retarder.ID_retard
GROUP BY typeretard.ID_typeRetard;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `i` (IN `ID_vol` VARCHAR(50))   SELECT passager.Nom
FROM billet 
LEFT JOIN passager ON billet.ID_Passager = passager.ID_passager
WHERE billet.ID_vol = ID_vol$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IIb` (IN `ville1` ENUM('A01','A02','A03','A04','A05','A06','A07','A08','A09','A10'), IN `listeville` SET('A01= Paris A02=Mexico A03=Heathrow A04=Madrid A05=Berlin  A06=Changi  A07= Orly  A08=Sydney   A09=Tokyo  A10=Pekin'), IN `ville2` ENUM('A01','A02','A03','A04','A05','A06','A07','A08','A09','A10'))   SELECT vol.ID_vol, aeroport.NomA as 'escale',
((vol.HeureArrivee-vol.heureDepart)/10000+24*(vol.DateArrivee -vol.DateDepart)) as 'temps de voyage',
((vol.HeureArrivee-vol.heureDepart)/10000+24*(vol.DateArrivee-vol.DateDepart))-vol.TempsEscal as 'temps de vol',
vol.Prix as 'prix de référence'
FROM vol
LEFT JOIN aeroport ON vol.ID_aeroport_Arreter=aeroport.ID_aeroport
WHERE (vol.ID_aeroport=ville1 AND vol.ID_aeroport_Atterir=ville2)
OR (vol.ID_aeroport=ville2 AND vol.ID_aeroport_Atterir=ville1)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IId` (IN `ID_compte` VARCHAR(50), IN `ID_passager` VARCHAR(50), IN `Nombre_bagage` INT, IN `ID_categoriePlace` ENUM('CPL01','CPL02','CPL03'), IN `ConsigneCategoriePlace` SET('CPL01=Economie  CPL02=Premiere  CPL03=Business'), IN `assurance` BOOLEAN, IN `ID_vol` VARCHAR(50), IN `ID_typepaiement` ENUM('TP01','TP02'), IN `ConsigneTypePaiement` SET('TP01=CB  TP02=Paypal'))   BEGIN 
	DECLARE numCo INT;
    DECLARE IDco VARCHAR(50);
    DECLARE dateCo DATE;
    DECLARE remisePa FLOAT;
    DECLARE remisePl FLOAT;
    DECLARE numBi INT;
    DECLARE IDbi VARCHAR(50);
    DECLARE IDfa VARCHAR(50);
    DECLARE prixVo FLOAT;
    DECLARE prixBi FLOAT;
    DECLARE remiseAs FLOAT;
    DECLARE numFa INT;
    DECLARE miles INT;
    DECLARE remiseMi INT;
    DECLARE distance INT;
    DECLARE remiseAv FLOAT;
    DECLARE capacite INT;
    DECLARE nbBi INT;
    SET nbBi = 0; 
    SET capacite = 0;
    SET remiseAv = 1;
    SET distance = 0;
    SET remiseMi = 0;
    SET miles = 0;
    SET numFa = 0;
    SET remiseAs = 1;
    SET prixBi = 0;
    SET prixVo = 0;
    SET remisePa = 1;
    SET remisePl = 1;
    SET numCo = 0 ;
    SET numBi = 0 ;
    
    SELECT COUNT(*) INTO numCo FROM commande;
    SELECT COUNT(*) INTO numBi FROM billet;
    SELECT COUNT(*) INTO numFa FROM facture;
    SET numCo = numCo+1;
    SET numBi = numBi+1;
    SET numFa = numFa+1;
    SET IDco = CONCAT('CO',numCo);
    SET IDbi = CONCAT('BIL',numBi);
    SET IDfa = CONCAT('F',numFa);
    SET dateCo= CURRENT_DATE;
    
    INSERT INTO commande VALUES(IDco, dateCo, ID_compte);
    INSERT INTO appartenir VALUES(IDco, ID_passager);
    SELECT categoriepassager.Remise INTO remisePa
	FROM passager
	LEFT JOIN categoriepassager ON passager.ID_CategoriePassager=categoriepassager.ID_categoriePassager
	WHERE passager.ID_passager=ID_passager;
    SELECT categorieplace.Remise INTO remisePl
    FROM categorieplace
    WHERE categorieplace.ID_CategoriePlace = ID_categoriePlace;
    SELECT vol.Prix INTO prixVo
    FROM vol
    WHERE vol.ID_vol = ID_vol;
    SELECT cartefidelite.nbMiles INTO miles
    FROM cartefidelite
    WHERE cartefidelite.ID_Compte = ID_compte;
    
    SELECT typeavion.Capacite INTO capacite
    FROM vol
    LEFT JOIN avion ON vol.ID_avion = avion.ID_Avion
    LEFT JOIN typeavion ON avion.ID_TypeAvion = typeavion.ID_TypeAvion
    WHERE vol.ID_vol = ID_vol;
    SELECT COUNT(*) INTO nbBi From billet
    WHERE billet.ID_vol = ID_vol;
    IF nbBi > (capacite - (25*capacite/100)) THEN
    SET remiseAv = 1.1;
    END IF;
    IF nbBi > (capacite - (10*capacite/100)) THEN
    SET remiseAv = 1.25;
    END IF;
    
    SET remiseAs = assurance*0.05+1;
    SET prixBi = prixVo*remisePa*remisePl*remiseAs*remiseAv+Nombre_bagage*20;
    SELECT vol.Distance INTO distance
    FROM vol
    WHERE vol.ID_vol = ID_vol;
    IF miles > 6000 THEN 
    SET prixBi = 0;
    UPDATE cartefidelite
    SET cartefidelite.nbMiles = 0
    WHERE cartefidelite.ID_Compte = ID_compte;
    ELSE
    UPDATE cartefidelite
    SET cartefidelite.nbMiles = cartefidelite.nbMiles + (distance*remisePl)/10
    WHERE cartefidelite.ID_Compte = ID_compte;
    END IF;
    SELECT prixBi;
    INSERT INTO billet VALUES(IDbi, Nombre_bagage, prixBi, assurance, 5, 5, 5, ID_passager, ID_categoriePlace, ID_vol);
    INSERT INTO facture VALUES(IDfa, prixBi, IDco, ID_typepaiement);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `IIF` (IN `ID_passager` VARCHAR(50))   BEGIN
SELECT billet.ID_vol
FROM billet
WHERE billet.ID_Passager=ID_passager;
SELECT DISTINCT(facture.ID_facture)
FROM appartenir
RIGHT JOIN commande ON appartenir.ID_commande = commande.ID_commande
RIGHT JOIN facture ON commande.ID_commande = facture.ID_commande
WHERE appartenir.ID_passager = ID_passager;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `k` (IN `Avion` VARCHAR(50), IN `Date` DATE)   SELECT vol.*
FROM vol
WHERE vol.ID_avion=Avion AND vol.DateDepart<(Date+7)  AND vol.DateDepart>(Date-1)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `o` (IN `actionVoulu` ENUM('suppression','ajout','modification','affecter'), IN `ID_employe` VARCHAR(50), IN `Nom` VARCHAR(50), IN `Prenom` VARCHAR(50), IN `Type_employe` ENUM('TE1','TE2','TE3'), IN `ID_vol` VARCHAR(50), IN `explication` SET('Pour modifier un personnel merci de remplir toutes ses information'), IN `explication2` SET('Pour supprimer un personnel merci de renseigner son ID'))   BEGIN
	IF actionVoulu = 'suppression' THEN
    DELETE affecter
	FROM affecter
	WHERE affecter.ID_employe = ID_employe;
	DELETE FROM employe
	WHERE employe.ID_employe = ID_employe;
	END IF;
    
     IF actionVoulu = 'ajout' THEN
    INSERT INTO Employe ( ID_employe,NomE,PrenomE, ID_TypeEmploye) VALUES (ID_employe,Nom,Prenom,Type_employe);
    END IF;
    
    IF actionVoulu = 'affecter' THEN
    INSERT INTO affecter ( ID_employe,ID_vol) VALUES (ID_employe,ID_vol);
    END IF;
    
    IF actionVoulu = 'modification' THEN
    DELETE employe
	FROM employe
	WHERE employe.ID_employe = ID_employe;
    INSERT INTO Employe ( ID_employe,NomE,PrenomE, ID_TypeEmploye) VALUES (ID_employe,Nom,Prenom,Type_employe);
	END IF;
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `1)b)`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `1)b)` (
`Bilan par type de vol` double
,`ID_TypeVol` varchar(50)
,`Type de vol` varchar(50)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `1)p)`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `1)p)` (
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `1c`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `1c` (
`ID_vol` varchar(50)
,`MoyenneQualitéDeRepas` decimal(14,4)
,`MoyenneQualitéDeVol` decimal(14,4)
,`MoyenneQualitéDeRetard` decimal(14,4)
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `1j`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `1j` (
`NomE` varchar(50)
);

-- --------------------------------------------------------

--
-- Structure de la table `aeroport`
--

CREATE TABLE `aeroport` (
  `ID_aeroport` varchar(50) NOT NULL,
  `NomA` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `aeroport`
--

INSERT INTO `aeroport` (`ID_aeroport`, `NomA`) VALUES
('', 'null'),
('A01', 'Paris'),
('A02', 'Mexico'),
('A03', 'Heathrow'),
('A04', 'Madrid'),
('A05', 'Berlin'),
('A06', 'Changi'),
('A07', 'Orly'),
('A08', 'Sydney'),
('A09', 'Tokyo'),
('A10', 'P?kin');

-- --------------------------------------------------------

--
-- Structure de la table `affecter`
--

CREATE TABLE `affecter` (
  `ID_employe` varchar(50) NOT NULL,
  `ID_vol` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `affecter`
--

INSERT INTO `affecter` (`ID_employe`, `ID_vol`) VALUES
('E1', 'V1'),
('E2', 'V2'),
('E3', 'V3'),
('E4', 'V4'),
('E5', 'V12'),
('E6', 'V5'),
('E7', 'V1'),
('E8', 'V2'),
('E9', 'V3'),
('E11', 'V12'),
('E12', 'V5'),
('E13', 'V1'),
('E14', 'V2'),
('E15', 'V3'),
('E16', 'V4'),
('E17', 'V12'),
('E18', 'V12'),
('E19', 'V1'),
('E20', 'V2'),
('E21', 'V3'),
('E22', 'V4'),
('E23', 'V12'),
('E24', 'V5'),
('E1', 'V1'),
('E2', 'V2'),
('E3', 'V3'),
('E4', 'V4'),
('E5', 'V12'),
('E6', 'V5'),
('E7', 'V1'),
('E8', 'V2'),
('E9', 'V3'),
('E11', 'V12'),
('E12', 'V5'),
('E13', 'V1'),
('E14', 'V2'),
('E15', 'V3'),
('E16', 'V4'),
('E17', 'V12'),
('E18', 'V12'),
('E19', 'V1'),
('E20', 'V2'),
('E21', 'V3'),
('E22', 'V4'),
('E23', 'V12'),
('E24', 'V5');

-- --------------------------------------------------------

--
-- Structure de la table `appartenir`
--

CREATE TABLE `appartenir` (
  `ID_commande` varchar(50) NOT NULL,
  `ID_passager` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `appartenir`
--

INSERT INTO `appartenir` (`ID_commande`, `ID_passager`) VALUES
('CO1', 'P01'),
('CO2', 'P01'),
('CO2', 'P02'),
('CO2', 'P03'),
('CO2', 'P04'),
('CO3', 'P02'),
('CO4', 'P01'),
('CO4', 'P02'),
('CO4', 'P03'),
('CO4', 'P04'),
('CO5', 'P05'),
('CO5', 'P06'),
('CO5', 'P07'),
('CO6', 'P08'),
('CO6', 'P09'),
('CO6', 'P10'),
('CO6', 'P11'),
('CO6', 'P12'),
('CO7', 'P05'),
('CO7', 'P06'),
('CO7', 'P07'),
('CO7', 'P08'),
('CO8', 'P09'),
('CO8', 'P10'),
('CO8', 'P11'),
('CO8', 'P12'),
('CO9', 'P13'),
('CO9', 'P14'),
('CO9', 'P15'),
('CO10', 'P03'),
('CO10', 'P04'),
('CO10', 'P05'),
('CO11', 'P06'),
('CO11', 'P07'),
('CO12', 'P08'),
('CO13', 'P09'),
('CO13', 'P10'),
('CO13', 'P11'),
('CO14', 'P12'),
('CO14', 'P13'),
('CO14', 'P14'),
('CO15', 'P15'),
('CO15', 'P16'),
('CO15', 'P17'),
('CO16', 'P01'),
('CO16', 'P02'),
('CO17', 'P18'),
('CO18', 'P03'),
('CO18', 'P04'),
('CO19', 'P05'),
('CO20', 'P06'),
('CO21', 'P01'),
('CO21', 'P02'),
('CO21', 'P03'),
('CO21', 'P04'),
('CO21', 'P05'),
('CO21', 'P06'),
('CO21', 'P07'),
('CO21', 'P08'),
('CO21', 'P09'),
('CO21', 'P10'),
('CO21', 'P11'),
('CO21', 'P12'),
('CO21', 'P13'),
('CO21', 'P14'),
('CO21', 'P15'),
('CO21', 'P16'),
('CO21', 'P17'),
('CO21', 'P18'),
('CO21', 'P19'),
('CO21', 'P20'),
('CO22', 'P21'),
('CO22', 'P22'),
('CO22', 'P23'),
('CO22', 'P24'),
('CO22', 'P25'),
('CO22', 'P26'),
('CO22', 'P27'),
('CO22', 'P28'),
('CO22', 'P29'),
('CO22', 'P30'),
('CO22', 'P31'),
('CO22', 'P32'),
('CO22', 'P33'),
('CO22', 'P34'),
('CO22', 'P35'),
('CO22', 'P36'),
('CO22', 'P37'),
('CO22', 'P38'),
('CO22', 'P39'),
('CO22', 'P40'),
('CO23', 'P41'),
('CO23', 'P42'),
('CO23', 'P43'),
('CO23', 'P44'),
('CO23', 'P45'),
('CO23', 'P46'),
('CO23', 'P47'),
('CO23', 'P48'),
('CO23', 'P49'),
('CO23', 'P50'),
('CO23', 'P51'),
('CO1', 'P01'),
('CO2', 'P01'),
('CO2', 'P02'),
('CO2', 'P03'),
('CO2', 'P04'),
('CO3', 'P02'),
('CO4', 'P01'),
('CO4', 'P02'),
('CO4', 'P03'),
('CO4', 'P04'),
('CO5', 'P05'),
('CO5', 'P06'),
('CO5', 'P07'),
('CO6', 'P08'),
('CO6', 'P09'),
('CO6', 'P10'),
('CO6', 'P11'),
('CO6', 'P12'),
('CO7', 'P05'),
('CO7', 'P06'),
('CO7', 'P07'),
('CO7', 'P08'),
('CO8', 'P09'),
('CO8', 'P10'),
('CO8', 'P11'),
('CO8', 'P12'),
('CO9', 'P13'),
('CO9', 'P14'),
('CO9', 'P15'),
('CO10', 'P03'),
('CO10', 'P04'),
('CO10', 'P05'),
('CO11', 'P06'),
('CO11', 'P07'),
('CO12', 'P08'),
('CO13', 'P09'),
('CO13', 'P10'),
('CO13', 'P11'),
('CO14', 'P12'),
('CO14', 'P13'),
('CO14', 'P14'),
('CO15', 'P15'),
('CO15', 'P16'),
('CO15', 'P17'),
('CO16', 'P01'),
('CO16', 'P02'),
('CO17', 'P18'),
('CO18', 'P03'),
('CO18', 'P04'),
('CO19', 'P05'),
('CO20', 'P06'),
('CO21', 'P01'),
('CO21', 'P02'),
('CO21', 'P03'),
('CO21', 'P04'),
('CO21', 'P05'),
('CO21', 'P06'),
('CO21', 'P07'),
('CO21', 'P08'),
('CO21', 'P09'),
('CO21', 'P10'),
('CO21', 'P11'),
('CO21', 'P12'),
('CO21', 'P13'),
('CO21', 'P14'),
('CO21', 'P15'),
('CO21', 'P16'),
('CO21', 'P17'),
('CO21', 'P18'),
('CO21', 'P19'),
('CO21', 'P20'),
('CO22', 'P21'),
('CO22', 'P22'),
('CO22', 'P23'),
('CO22', 'P24'),
('CO22', 'P25'),
('CO22', 'P26'),
('CO22', 'P27'),
('CO22', 'P28'),
('CO22', 'P29'),
('CO22', 'P30'),
('CO22', 'P31'),
('CO22', 'P32'),
('CO22', 'P33'),
('CO22', 'P34'),
('CO22', 'P35'),
('CO22', 'P36'),
('CO22', 'P37'),
('CO22', 'P38'),
('CO22', 'P39'),
('CO22', 'P40'),
('CO23', 'P41'),
('CO23', 'P42'),
('CO23', 'P43'),
('CO23', 'P44'),
('CO23', 'P45'),
('CO23', 'P46'),
('CO23', 'P47'),
('CO23', 'P48'),
('CO23', 'P49'),
('CO23', 'P50'),
('CO23', 'P51'),
('CO25', 'P01');

-- --------------------------------------------------------

--
-- Structure de la table `avion`
--

CREATE TABLE `avion` (
  `ID_Avion` varchar(50) NOT NULL,
  `ID_TypeAvion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `avion`
--

INSERT INTO `avion` (`ID_Avion`, `ID_TypeAvion`) VALUES
('AV11', 'TA1'),
('AV12', 'TA1'),
('AV13', 'TA1'),
('AV15', 'TA1'),
('AV18', 'TA1'),
('AV23', 'TA1'),
('AV3', 'TA1'),
('AV6', 'TA1'),
('AV1', 'TA2'),
('AV14', 'TA2'),
('AV19', 'TA2'),
('AV20', 'TA2'),
('AV25', 'TA2'),
('AV4', 'TA2'),
('AV7', 'TA2'),
('AV9', 'TA2'),
('AV10', 'TA3'),
('AV16', 'TA3'),
('AV17', 'TA3'),
('AV2', 'TA3'),
('AV21', 'TA3'),
('AV22', 'TA3'),
('AV24', 'TA3'),
('AV5', 'TA3'),
('AV8', 'TA3');

-- --------------------------------------------------------

--
-- Structure de la table `billet`
--

CREATE TABLE `billet` (
  `ID_billet` varchar(50) NOT NULL,
  `Bagage` int(11) NOT NULL,
  `prixBillet` float NOT NULL,
  `assurance` tinyint(1) NOT NULL,
  `Qrepas` int(11) NOT NULL,
  `Qvol` int(11) NOT NULL,
  `Qretard` int(11) NOT NULL,
  `ID_Passager` varchar(50) NOT NULL,
  `ID_CategoriePlace` varchar(50) NOT NULL,
  `ID_vol` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `billet`
--

INSERT INTO `billet` (`ID_billet`, `Bagage`, `prixBillet`, `assurance`, `Qrepas`, `Qvol`, `Qretard`, `ID_Passager`, `ID_CategoriePlace`, `ID_vol`) VALUES
('BIL01', 1, 183, 0, 7, 8, 9, 'P01', 'CPL02', 'V4'),
('BIL02', 2, 115, 0, 9, 6, 7, 'P01', 'CPL01', 'V1'),
('BIL03', 0, 157, 0, 3, 9, 6, 'P02', 'CPL03', 'V1'),
('BIL04', 1, 290, 0, 6, 4, 10, 'P03', 'CPL03', 'V1'),
('BIL05', 2, 227, 0, 8, 7, 8, 'P04', 'CPL02', 'V1'),
('BIL06', 0, 120, 0, 7, 10, 3, 'P02', 'CPL01', 'V4'),
('BIL07', 1, 0, 0, 9, 8, 7, 'P01', 'CPL03', 'V2'),
('BIL08', 2, 164, 0, 1, 2, 4, 'P02', 'CPL02', 'V2'),
('BIL09', 0, 100, 0, 10, 6, 9, 'P03', 'CPL01', 'V2'),
('BIL10', 1, 59, 0, 7, 7, 6, 'P04', 'CPL02', 'V2'),
('BIL100', 2, 85, 0, 10, 3, 9, 'P49', 'CPL03', 'V12'),
('BIL101', 0, 120, 0, 2, 10, 10, 'P50', 'CPL01', 'V12'),
('BIL102', 2, 144, 0, 8, 5, 6, 'P51', 'CPL02', 'V12'),
('BIL103', 3, 239.156, 1, 5, 5, 5, 'P01', 'CPL02', 'V1'),
('BIL11', 2, 256, 0, 5, 5, 10, 'P05', 'CPL03', 'V1'),
('BIL12', 0, 163, 0, 9, 8, 5, 'P06', 'CPL02', 'V1'),
('BIL13', 2, 190, 0, 7, 9, 9, 'P07', 'CPL01', 'V1'),
('BIL14', 1, 65, 0, 2, 7, 8, 'P08', 'CPL01', 'V1'),
('BIL15', 0, 189, 0, 7, 2, 7, 'P09', 'CPL03', 'V1'),
('BIL16', 1, 215, 0, 8, 9, 6, 'P10', 'CPL02', 'V1'),
('BIL17', 2, 94, 0, 6, 6, 10, 'P11', 'CPL01', 'V1'),
('BIL18', 0, 180, 0, 9, 3, 3, 'P12', 'CPL03', 'V1'),
('BIL19', 1, 129, 0, 7, 8, 5, 'P05', 'CPL02', 'V2'),
('BIL20', 2, 190, 0, 8, 9, 8, 'P06', 'CPL03', 'V2'),
('BIL21', 0, 36, 0, 0, 7, 7, 'P07', 'CPL01', 'V2'),
('BIL22', 1, 144, 0, 6, 5, 4, 'P08', 'CPL02', 'V2'),
('BIL23', 2, 145, 0, 8, 10, 9, 'P09', 'CPL03', 'V2'),
('BIL24', 0, 60, 0, 9, 6, 10, 'P10', 'CPL01', 'V2'),
('BIL25', 1, 150, 0, 10, 8, 8, 'P11', 'CPL02', 'V2'),
('BIL26', 0, 144, 0, 6, 4, 7, 'P12', 'CPL03', 'V2'),
('BIL27', 2, 79, 0, 3, 10, 5, 'P13', 'CPL02', 'V2'),
('BIL28', 1, 140, 0, 8, 2, 6, 'P14', 'CPL01', 'V2'),
('BIL29', 0, 105, 0, 9, 7, 10, 'P15', 'CPL03', 'V2'),
('BIL30', 2, 235, 0, 10, 9, 4, 'P03', 'CPL02', 'V4'),
('BIL31', 1, 146, 0, 4, 6, 8, 'P04', 'CPL01', 'V4'),
('BIL32', 0, 112, 0, 7, 8, 9, 'P05', 'CPL03', 'V4'),
('BIL33', 2, 274, 0, 9, 4, 7, 'P06', 'CPL02', 'V4'),
('BIL34', 1, 140, 0, 10, 9, 3, 'P07', 'CPL01', 'V4'),
('BIL35', 0, 187, 0, 2, 5, 10, 'P08', 'CPL02', 'V4'),
('BIL36', 2, 175, 0, 8, 10, 5, 'P09', 'CPL03', 'V4'),
('BIL37', 1, 65, 0, 9, 3, 8, 'P10', 'CPL01', 'V4'),
('BIL38', 0, 163, 0, 1, 8, 6, 'P11', 'CPL02', 'V4'),
('BIL39', 1, 245, 0, 8, 7, 9, 'P12', 'CPL03', 'V4'),
('BIL40', 2, 196, 0, 6, 9, 10, 'P13', 'CPL02', 'V4'),
('BIL41', 0, 144, 0, 9, 10, 4, 'P14', 'CPL01', 'V4'),
('BIL42', 2, 265, 0, 8, 6, 7, 'P15', 'CPL03', 'V4'),
('BIL43', 1, 78, 0, 7, 4, 8, 'P16', 'CPL02', 'V4'),
('BIL44', 0, 144, 0, 4, 8, 9, 'P17', 'CPL01', 'V4'),
('BIL45', 2, 137, 0, 10, 7, 6, 'P01', 'CPL02', 'V3'),
('BIL46', 1, 290, 0, 7, 3, 5, 'P02', 'CPL03', 'V3'),
('BIL47', 0, 90, 0, 8, 9, 10, 'P18', 'CPL01', 'V4'),
('BIL48', 2, 197, 0, 9, 5, 7, 'P03', 'CPL03', 'V3'),
('BIL49', 1, 117, 0, 7, 6, 9, 'P04', 'CPL02', 'V3'),
('BIL50', 0, 144, 0, 3, 10, 4, 'P05', 'CPL01', 'V3'),
('BIL51', 2, 98, 0, 8, 4, 8, 'P06', 'CPL02', 'V3'),
('BIL52', 1, 146, 0, 7, 7, 7, 'P01', 'CPL03', 'V12'),
('BIL53', 0, 60, 0, 5, 9, 6, 'P02', 'CPL01', 'V12'),
('BIL54', 2, 170, 0, 10, 8, 10, 'P03', 'CPL02', 'V12'),
('BIL55', 1, 140, 0, 9, 6, 5, 'P04', 'CPL03', 'V12'),
('BIL56', 0, 96, 0, 4, 5, 9, 'P05', 'CPL01', 'V12'),
('BIL57', 2, 130, 0, 7, 8, 8, 'P06', 'CPL03', 'V12'),
('BIL58', 1, 129, 0, 9, 10, 4, 'P07', 'CPL02', 'V12'),
('BIL59', 0, 120, 0, 8, 9, 10, 'P08', 'CPL01', 'V12'),
('BIL60', 1, 65, 0, 3, 2, 7, 'P09', 'CPL03', 'V12'),
('BIL61', 2, 164, 0, 10, 4, 6, 'P10', 'CPL02', 'V12'),
('BIL62', 0, 50, 0, 9, 7, 8, 'P11', 'CPL01', 'V12'),
('BIL63', 1, 164, 0, 2, 9, 9, 'P12', 'CPL03', 'V12'),
('BIL64', 2, 170, 0, 4, 8, 5, 'P13', 'CPL02', 'V12'),
('BIL65', 0, 30, 0, 7, 10, 4, 'P14', 'CPL01', 'V12'),
('BIL66', 1, 164, 0, 9, 3, 10, 'P15', 'CPL03', 'V12'),
('BIL67', 2, 131, 0, 8, 6, 7, 'P16', 'CPL02', 'V12'),
('BIL68', 0, 60, 0, 2, 9, 9, 'P17', 'CPL01', 'V12'),
('BIL69', 1, 140, 0, 7, 7, 8, 'P18', 'CPL03', 'V12'),
('BIL70', 2, 170, 0, 10, 8, 6, 'P19', 'CPL02', 'V12'),
('BIL71', 0, 36, 0, 8, 6, 10, 'P20', 'CPL01', 'V12'),
('BIL72', 1, 125, 0, 6, 5, 7, 'P21', 'CPL03', 'V12'),
('BIL73', 2, 164, 0, 5, 10, 4, 'P22', 'CPL02', 'V12'),
('BIL74', 0, 80, 0, 9, 4, 9, 'P23', 'CPL01', 'V12'),
('BIL75', 2, 118, 0, 2, 9, 8, 'P24', 'CPL02', 'V12'),
('BIL76', 1, 170, 0, 10, 8, 5, 'P25', 'CPL03', 'V12'),
('BIL77', 0, 36, 0, 8, 6, 6, 'P26', 'CPL01', 'V12'),
('BIL78', 2, 144, 0, 7, 3, 10, 'P27', 'CPL02', 'V12'),
('BIL79', 1, 164, 0, 4, 7, 7, 'P28', 'CPL03', 'V12'),
('BIL80', 0, 70, 0, 9, 9, 9, 'P29', 'CPL01', 'V12'),
('BIL81', 2, 118, 0, 6, 10, 4, 'P30', 'CPL02', 'V12'),
('BIL82', 1, 65, 0, 3, 8, 6, 'P31', 'CPL03', 'V12'),
('BIL83', 0, 120, 0, 8, 6, 8, 'P32', 'CPL01', 'V12'),
('BIL84', 2, 144, 0, 9, 7, 10, 'P33', 'CPL02', 'V12'),
('BIL85', 1, 140, 0, 2, 4, 7, 'P34', 'CPL03', 'V12'),
('BIL86', 0, 60, 0, 7, 9, 9, 'P35', 'CPL01', 'V12'),
('BIL87', 2, 131, 0, 5, 2, 5, 'P36', 'CPL02', 'V12'),
('BIL88', 1, 74, 0, 6, 6, 4, 'P37', 'CPL03', 'V12'),
('BIL89', 0, 100, 0, 10, 8, 6, 'P38', 'CPL01', 'V12'),
('BIL90', 2, 164, 0, 4, 9, 10, 'P39', 'CPL02', 'V12'),
('BIL91', 1, 95, 0, 8, 3, 8, 'P40', 'CPL03', 'V12'),
('BIL92', 0, 96, 0, 7, 5, 9, 'P41', 'CPL01', 'V12'),
('BIL93', 2, 131, 0, 3, 7, 7, 'P42', 'CPL02', 'V12'),
('BIL94', 1, 65, 0, 2, 6, 6, 'P43', 'CPL03', 'V12'),
('BIL95', 0, 120, 0, 9, 10, 5, 'P44', 'CPL01', 'V12'),
('BIL96', 2, 164, 0, 8, 8, 10, 'P45', 'CPL02', 'V12'),
('BIL97', 1, 140, 0, 7, 4, 4, 'P46', 'CPL03', 'V12'),
('BIL98', 0, 84, 0, 4, 9, 8, 'P47', 'CPL01', 'V12'),
('BIL99', 1, 85, 0, 5, 6, 7, 'P48', 'CPL02', 'V12');

-- --------------------------------------------------------

--
-- Structure de la table `cartefidelite`
--

CREATE TABLE `cartefidelite` (
  `ID_carte` varchar(50) NOT NULL,
  `nbMiles` float NOT NULL,
  `ID_Compte` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `cartefidelite`
--

INSERT INTO `cartefidelite` (`ID_carte`, `nbMiles`, `ID_Compte`) VALUES
('CF10', 230, 'C10'),
('CF3', 780, 'C3'),
('CF4', 1150, 'C4'),
('CF5', 2765, 'C5'),
('CF7', 860, 'C7'),
('CF8', 1935, 'C8'),
('CF9', 4525, 'C9');

-- --------------------------------------------------------

--
-- Structure de la table `categoriepassager`
--

CREATE TABLE `categoriepassager` (
  `ID_CategoriePassager` varchar(50) NOT NULL,
  `CategoriePassager` varchar(50) NOT NULL,
  `Remise` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `categoriepassager`
--

INSERT INTO `categoriepassager` (`ID_CategoriePassager`, `CategoriePassager`, `Remise`) VALUES
('CP1', 'S?nior', 0.8),
('CP2', 'Adulte', 1),
('CP3', 'Etudiant', 0.7),
('CP4', 'Jeune adulte', 0.8),
('CP5', 'Jeune', 0.5),
('CP6', 'Enfant', 0.3);

-- --------------------------------------------------------

--
-- Structure de la table `categorieplace`
--

CREATE TABLE `categorieplace` (
  `ID_CategoriePlace` varchar(50) NOT NULL,
  `CategoriePlace` varchar(50) NOT NULL,
  `Remise` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `categorieplace`
--

INSERT INTO `categorieplace` (`ID_CategoriePlace`, `CategoriePlace`, `Remise`) VALUES
('CPL01', 'Economie', 1),
('CPL02', 'Premiere', 1.3),
('CPL03', 'Business', 1.5);

-- --------------------------------------------------------

--
-- Structure de la table `commande`
--

CREATE TABLE `commande` (
  `ID_commande` varchar(50) NOT NULL,
  `dateCommande` date NOT NULL,
  `ID_Compte` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `commande`
--

INSERT INTO `commande` (`ID_commande`, `dateCommande`, `ID_Compte`) VALUES
('CO1', '2019-01-01', 'C1'),
('CO10', '2019-10-10', 'C1'),
('CO11', '2019-11-11', 'C6'),
('CO12', '2019-12-25', 'C7'),
('CO13', '2019-01-20', 'C5'),
('CO14', '2019-02-28', 'C3'),
('CO15', '2019-03-08', 'C5'),
('CO16', '2019-04-22', 'C1'),
('CO17', '2019-05-15', 'C5'),
('CO18', '2019-06-05', 'C4'),
('CO19', '2019-07-04', 'C8'),
('CO2', '2019-02-14', 'C1'),
('CO20', '2019-09-30', 'C9'),
('CO21', '2023-08-01', 'C10'),
('CO22', '2023-07-01', 'C2'),
('CO23', '2023-08-10', 'C3'),
('CO24', '2023-05-10', 'C4'),
('CO25', '2024-12-18', 'C1'),
('CO3', '2019-03-21', 'C2'),
('CO4', '2019-04-15', 'C3'),
('CO5', '2019-05-01', 'C2'),
('CO6', '2019-06-30', 'C4'),
('CO7', '2019-07-14', 'C5'),
('CO8', '2019-08-15', 'C1'),
('CO9', '2019-09-01', 'C5');

-- --------------------------------------------------------

--
-- Structure de la table `compte`
--

CREATE TABLE `compte` (
  `ID_compte` varchar(50) NOT NULL,
  `adresseMail` varchar(50) NOT NULL,
  `AdressePostal` varchar(50) NOT NULL,
  `NomC` varchar(50) NOT NULL,
  `PrenomC` varchar(50) NOT NULL,
  `DateNaissance` date NOT NULL,
  `Mdp` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `compte`
--

INSERT INTO `compte` (`ID_compte`, `adresseMail`, `AdressePostal`, `NomC`, `PrenomC`, `DateNaissance`, `Mdp`) VALUES
('C1', 'client1@example.com', '1 Demo Street, Paris', 'Client1', 'Demo', '1990-01-01', 'not-a-real-password'),
('C10', 'client10@example.com', '10 Demo Street, Paris', 'Client10', 'Demo', '1990-01-01', 'not-a-real-password'),
('C11', 'client11@example.com', '11 Demo Street, Paris', 'Client11', 'Demo', '1990-01-01', 'not-a-real-password'),
('C12', 'client12@example.com', '12 Demo Street, Paris', 'Client12', 'Demo', '1990-01-01', 'not-a-real-password'),
('C2', 'client2@example.com', '2 Demo Street, Paris', 'Client2', 'Demo', '1990-01-01', 'not-a-real-password'),
('C3', 'client3@example.com', '3 Demo Street, Paris', 'Client3', 'Demo', '1990-01-01', 'not-a-real-password'),
('C4', 'client4@example.com', '4 Demo Street, Paris', 'Client4', 'Demo', '1990-01-01', 'not-a-real-password'),
('C5', 'client5@example.com', '5 Demo Street, Paris', 'Client5', 'Demo', '1990-01-01', 'not-a-real-password'),
('C6', 'client6@example.com', '6 Demo Street, Paris', 'Client6', 'Demo', '1990-01-01', 'not-a-real-password'),
('C7', 'client7@example.com', '7 Demo Street, Paris', 'Client7', 'Demo', '1990-01-01', 'not-a-real-password'),
('C8', 'client8@example.com', '8 Demo Street, Paris', 'Client8', 'Demo', '1990-01-01', 'not-a-real-password'),
('C9', 'client9@example.com', '9 Demo Street, Paris', 'Client9', 'Demo', '1990-01-01', 'not-a-real-password');

-- --------------------------------------------------------

--
-- Structure de la table `employe`
--

CREATE TABLE `employe` (
  `ID_employe` varchar(50) NOT NULL,
  `nomE` varchar(50) NOT NULL,
  `PrenomE` varchar(50) NOT NULL,
  `ID_TypeEmploye` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `employe`
--

INSERT INTO `employe` (`ID_employe`, `nomE`, `PrenomE`, `ID_TypeEmploye`) VALUES
('E1', 'Employee1', 'Demo', 'TE1'),
('E10', 'Employee10', 'Demo', 'TE2'),
('E11', 'Employee11', 'Demo', 'TE2'),
('E12', 'Employee12', 'Demo', 'TE2'),
('E13', 'Employee13', 'Demo', 'TE3'),
('E14', 'Employee14', 'Demo', 'TE3'),
('E15', 'Employee15', 'Demo', 'TE3'),
('E16', 'Employee16', 'Demo', 'TE3'),
('E17', 'Employee17', 'Demo', 'TE3'),
('E18', 'Employee18', 'Demo', 'TE3'),
('E19', 'Employee19', 'Demo', 'TE4'),
('E2', 'Employee2', 'Demo', 'TE1'),
('E20', 'Employee20', 'Demo', 'TE4'),
('E21', 'Employee21', 'Demo', 'TE4'),
('E22', 'Employee22', 'Demo', 'TE4'),
('E23', 'Employee23', 'Demo', 'TE4'),
('E24', 'Employee24', 'Demo', 'TE4'),
('E3', 'Employee3', 'Demo', 'TE1'),
('E4', 'Employee4', 'Demo', 'TE1'),
('E5', 'Employee5', 'Demo', 'TE1'),
('E6', 'Employee6', 'Demo', 'TE1'),
('E7', 'Employee7', 'Demo', 'TE2'),
('E8', 'Employee8', 'Demo', 'TE2'),
('E9', 'Employee9', 'Demo', 'TE2');

-- --------------------------------------------------------

--
-- Structure de la table `entretien`
--

CREATE TABLE `entretien` (
  `ID_Entretien` varchar(50) NOT NULL,
  `ID_avion` varchar(50) NOT NULL,
  `DateEntretienPlanifie` date NOT NULL,
  `DateRelleEntretien` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `entretien`
--

INSERT INTO `entretien` (`ID_Entretien`, `ID_avion`, `DateEntretienPlanifie`, `DateRelleEntretien`) VALUES
('ENT1', 'AV1', '2023-12-04', '2023-12-09'),
('ENT10', 'AV3', '2024-08-01', '2024-09-05'),
('ENT11', 'AV11', '2023-09-03', '2023-09-03'),
('ENT12', 'AV12', '2023-10-03', '2023-10-03'),
('ENT13', 'AV13', '2023-11-02', '0000-00-00'),
('ENT14', 'AV14', '2024-12-02', '2024-12-02'),
('ENT15', 'AV15', '2023-01-08', '2024-01-08'),
('ENT16', 'AV16', '2023-02-07', '2023-03-10'),
('ENT17', 'AV17', '2024-03-11', '0000-00-00'),
('ENT18', 'AV1', '2024-02-05', '0000-00-00'),
('ENT19', 'AV3', '2023-05-02', '2023-05-02'),
('ENT2', 'AV2', '2023-01-03', '2023-01-03'),
('ENT20', 'AV20', '2024-06-07', '2024-06-07'),
('ENT21', 'AV21', '2023-07-07', '2023-07-07'),
('ENT22', 'AV22', '2024-08-06', '2024-08-06'),
('ENT23', 'AV23', '2023-09-05', '0000-00-00'),
('ENT24', 'AV24', '2023-10-05', '2023-10-05'),
('ENT25', 'AV25', '2023-11-04', '0000-00-00'),
('ENT26', 'AV16', '2024-12-04', '2024-12-04'),
('ENT27', 'AV17', '2023-01-03', '2023-01-03'),
('ENT28', 'AV18', '2023-02-12', '2024-02-05'),
('ENT29', 'AV19', '2024-03-03', '2024-03-03'),
('ENT3', 'AV21', '2023-02-02', '2023-02-02'),
('ENT30', 'AV14', '2023-04-02', '2023-03-04'),
('ENT31', 'AV11', '2024-05-02', '2024-05-07'),
('ENT32', 'AV24', '2023-06-02', '0000-00-00'),
('ENT33', 'AV1', '2023-07-02', '2023-07-02'),
('ENT34', 'AV8', '2023-08-02', '2023-08-02'),
('ENT35', 'AV24', '2024-09-01', '2024-09-01'),
('ENT36', 'AV11', '2023-10-01', '0000-00-00'),
('ENT37', 'AV7', '2024-11-08', '2024-11-09'),
('ENT38', 'AV8', '2023-12-08', '2023-12-08'),
('ENT39', 'AV9', '2023-01-01', '0000-00-00'),
('ENT4', 'AV20', '2024-03-04', '0000-00-00'),
('ENT5', 'AV23', '2024-04-03', '2024-04-03'),
('ENT6', 'AV6', '2023-05-03', '2023-03-09'),
('ENT7', 'AV7', '2023-06-02', '2024-06-07'),
('ENT8', 'AV8', '2024-07-02', '2024-07-02'),
('ENT9', 'AV9', '2023-08-01', '2023-12-01');

-- --------------------------------------------------------

--
-- Structure de la table `facture`
--

CREATE TABLE `facture` (
  `ID_facture` varchar(50) NOT NULL,
  `Montant` int(11) NOT NULL,
  `ID_commande` varchar(50) NOT NULL,
  `ID_TypePaiement` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `facture`
--

INSERT INTO `facture` (`ID_facture`, `Montant`, `ID_commande`, `ID_TypePaiement`) VALUES
('F1', 183, 'CO1', 'TP01'),
('F10', 493, 'CO10', 'TP02'),
('F11', 414, 'CO11', 'TP01'),
('F12', 187, 'CO12', 'TP02'),
('F13', 403, 'CO13', 'TP01'),
('F14', 585, 'CO14', 'TP02'),
('F15', 487, 'CO15', 'TP01'),
('F16', 527, 'CO16', 'TP02'),
('F17', 90, 'CO17', 'TP02'),
('F18', 315, 'CO18', 'TP01'),
('F19', 144, 'CO19', 'TP01'),
('F2', 1789, 'CO2', 'TP02'),
('F20', 98, 'CO20', 'TP02'),
('F21', 2336, 'CO21', 'TP02'),
('F22', 2283, 'CO22', 'TP01'),
('F23', 1234, 'CO23', 'TP02'),
('F24', 239, 'CO25', 'TP02'),
('F3', 120, 'CO3', 'TP01'),
('F4', 323, 'CO4', 'TP01'),
('F5', 609, 'CO5', 'TP02'),
('F6', 743, 'CO6', 'TP01'),
('F7', 500, 'CO7', 'TP02'),
('F8', 499, 'CO8', 'TP01'),
('F9', 324, 'CO9', 'TP01');

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `id2`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `id2` (
`ID_avion` varchar(50)
,`DateEntretienPlanifie` date
,`DateRelleEntretien` date
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `m`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `m` (
`NomA` varchar(50)
,`PrixMoyen` double
);

-- --------------------------------------------------------

--
-- Doublure de structure pour la vue `n`
-- (Voir ci-dessous la vue réelle)
--
CREATE TABLE `n` (
`ID_Compte` varchar(50)
,`Nom_Client` varchar(50)
,`Prenom_Client` varchar(50)
,`Email_Client` varchar(50)
,`Adresse_Client` varchar(50)
,`Date_Naissance_Client` date
,`ID_Vol` varchar(50)
,`Prix_Vol` float
,`Date_Depart` date
,`Heure_Depart` time
,`Date_Arrivee` date
,`Heure_Arrivee` time
,`ID_Facture` varchar(50)
,`Montant_Facture` int(11)
,`N_commande` varchar(50)
);

-- --------------------------------------------------------

--
-- Structure de la table `passager`
--

CREATE TABLE `passager` (
  `ID_passager` varchar(50) NOT NULL,
  `Nom` varchar(50) NOT NULL,
  `Prénom` varchar(50) NOT NULL,
  `dateNAissance` date NOT NULL,
  `NumDoc` varchar(50) NOT NULL,
  `ID_typeDoc` varchar(50) NOT NULL,
  `ID_categoriePassager` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `passager`
--

INSERT INTO `passager` (`ID_passager`, `Nom`, `Prénom`, `dateNAissance`, `NumDoc`, `ID_typeDoc`, `ID_categoriePassager`) VALUES
('P01', 'Passenger01', 'Demo', '1990-01-01', 'DOC0001', 'TD2', 'CP3'),
('P02', 'Passenger02', 'Demo', '1990-01-01', 'DOC0002', 'TD2', 'CP5'),
('P03', 'Passenger03', 'Demo', '1990-01-01', 'DOC0003', 'TD1', 'CP2'),
('P04', 'Passenger04', 'Demo', '1990-01-01', 'DOC0004', 'TD2', 'CP4'),
('P05', 'Passenger05', 'Demo', '1990-01-01', 'DOC0005', 'TD1', 'CP1'),
('P06', 'Passenger06', 'Demo', '1990-01-01', 'DOC0006', 'TD2', 'CP6'),
('P07', 'Passenger07', 'Demo', '1990-01-01', 'DOC0007', 'TD1', 'CP3'),
('P08', 'Passenger08', 'Demo', '1990-01-01', 'DOC0008', 'TD1', 'CP2'),
('P09', 'Passenger09', 'Demo', '1990-01-01', 'DOC0009', 'TD2', 'CP6'),
('P10', 'Passenger10', 'Demo', '1990-01-01', 'DOC0010', 'TD2', 'CP1'),
('P11', 'Passenger11', 'Demo', '1990-01-01', 'DOC0011', 'TD1', 'CP5'),
('P12', 'Passenger12', 'Demo', '1990-01-01', 'DOC0012', 'TD2', 'CP4'),
('P13', 'Passenger13', 'Demo', '1990-01-01', 'DOC0013', 'TD1', 'CP2'),
('P14', 'Passenger14', 'Demo', '1990-01-01', 'DOC0014', 'TD1', 'CP6'),
('P15', 'Passenger15', 'Demo', '1990-01-01', 'DOC0015', 'TD1', 'CP1'),
('P16', 'Passenger16', 'Demo', '1990-01-01', 'DOC0016', 'TD1', 'CP3'),
('P17', 'Passenger17', 'Demo', '1990-01-01', 'DOC0017', 'TD1', 'CP5'),
('P18', 'Passenger18', 'Demo', '1990-01-01', 'DOC0018', 'TD1', 'CP4'),
('P19', 'Passenger19', 'Demo', '1990-01-01', 'DOC0019', 'TD2', 'CP2'),
('P20', 'Passenger20', 'Demo', '1990-01-01', 'DOC0020', 'TD2', 'CP6'),
('P21', 'Passenger21', 'Demo', '1990-01-01', 'DOC0021', 'TD1', 'CP3'),
('P22', 'Passenger22', 'Demo', '1990-01-01', 'DOC0022', 'TD2', 'CP1'),
('P23', 'Passenger23', 'Demo', '1990-01-01', 'DOC0023', 'TD2', 'CP4'),
('P24', 'Passenger24', 'Demo', '1990-01-01', 'DOC0024', 'TD2', 'CP5'),
('P25', 'Passenger25', 'Demo', '1990-01-01', 'DOC0025', 'TD1', 'CP2'),
('P26', 'Passenger26', 'Demo', '1990-01-01', 'DOC0026', 'TD1', 'CP6'),
('P27', 'Passenger27', 'Demo', '1990-01-01', 'DOC0027', 'TD2', 'CP1'),
('P28', 'Passenger28', 'Demo', '1990-01-01', 'DOC0028', 'TD2', 'CP4'),
('P29', 'Passenger29', 'Demo', '1990-01-01', 'DOC0029', 'TD1', 'CP3'),
('P30', 'Passenger30', 'Demo', '1990-01-01', 'DOC0030', 'TD1', 'CP5'),
('P31', 'Passenger31', 'Demo', '1990-01-01', 'DOC0031', 'TD2', 'CP6'),
('P32', 'Passenger32', 'Demo', '1990-01-01', 'DOC0032', 'TD2', 'CP2'),
('P33', 'Passenger33', 'Demo', '1990-01-01', 'DOC0033', 'TD1', 'CP1'),
('P34', 'Passenger34', 'Demo', '1990-01-01', 'DOC0034', 'TD2', 'CP4'),
('P35', 'Passenger35', 'Demo', '1990-01-01', 'DOC0035', 'TD1', 'CP5'),
('P36', 'Passenger36', 'Demo', '1990-01-01', 'DOC0036', 'TD2', 'CP3'),
('P37', 'Passenger37', 'Demo', '1990-01-01', 'DOC0037', 'TD1', 'CP6'),
('P38', 'Passenger38', 'Demo', '1990-01-01', 'DOC0038', 'TD1', 'CP2'),
('P39', 'Passenger39', 'Demo', '1990-01-01', 'DOC0039', 'TD1', 'CP1'),
('P40', 'Passenger40', 'Demo', '1990-01-01', 'DOC0040', 'TD1', 'CP5'),
('P41', 'Passenger41', 'Demo', '1990-01-01', 'DOC0041', 'TD1', 'CP4'),
('P42', 'Passenger42', 'Demo', '1990-01-01', 'DOC0042', 'TD2', 'CP3'),
('P43', 'Passenger43', 'Demo', '1990-01-01', 'DOC0043', 'TD2', 'CP6'),
('P44', 'Passenger44', 'Demo', '1990-01-01', 'DOC0044', 'TD2', 'CP2'),
('P45', 'Passenger45', 'Demo', '1990-01-01', 'DOC0045', 'TD1', 'CP1'),
('P46', 'Passenger46', 'Demo', '1990-01-01', 'DOC0046', 'TD2', 'CP4'),
('P47', 'Passenger47', 'Demo', '1990-01-01', 'DOC0047', 'TD2', 'CP3'),
('P48', 'Passenger48', 'Demo', '1990-01-01', 'DOC0048', 'TD2', 'CP5'),
('P49', 'Passenger49', 'Demo', '1990-01-01', 'DOC0049', 'TD2', 'CP6'),
('P50', 'Passenger50', 'Demo', '1990-01-01', 'DOC0050', 'TD1', 'CP2'),
('P51', 'Passenger51', 'Demo', '1990-01-01', 'DOC0051', 'TD1', 'CP1'),
('P52', 'Passenger52', 'Demo', '1990-01-01', 'DOC0052', 'TD2', 'CP4'),
('P53', 'Passenger53', 'Demo', '1990-01-01', 'DOC0053', 'TD1', 'CP5'),
('P54', 'Passenger54', 'Demo', '1990-01-01', 'DOC0054', 'TD1', 'CP3'),
('P55', 'Passenger55', 'Demo', '1990-01-01', 'DOC0055', 'TD1', 'CP2');

-- --------------------------------------------------------

--
-- Structure de la table `proposer`
--

CREATE TABLE `proposer` (
  `ID_TypeRepas` varchar(50) NOT NULL,
  `ID_vol` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `proposer`
--

INSERT INTO `proposer` (`ID_TypeRepas`, `ID_vol`) VALUES
('R01', 'V1'),
('R02', 'V1'),
('R03', 'V1'),
('R02', 'V2'),
('R01', 'V3'),
('R02', 'V3'),
('R03', 'V3'),
('R01', 'V4'),
('R02', 'V4'),
('R03', 'V4'),
('R02', 'V5'),
('R02', 'V6'),
('R03', 'V6'),
('R02', 'V7'),
('R01', 'V8'),
('R02', 'V8'),
('R03', 'V8'),
('R02', 'V9'),
('R02', 'V10'),
('R01', 'V11'),
('R02', 'V11'),
('R03', 'V11'),
('R01', 'V12'),
('R02', 'V12'),
('R03', 'V12'),
('R01', 'V13'),
('R02', 'V13'),
('R02', 'V14'),
('R01', 'V14'),
('R03', 'V14'),
('R01', 'V15'),
('R02', 'V15'),
('R01', 'V1'),
('R02', 'V1'),
('R03', 'V1'),
('R02', 'V2'),
('R01', 'V3'),
('R02', 'V3'),
('R03', 'V3'),
('R01', 'V4'),
('R02', 'V4'),
('R03', 'V4'),
('R02', 'V5'),
('R02', 'V6'),
('R03', 'V6'),
('R02', 'V7'),
('R01', 'V8'),
('R02', 'V8'),
('R03', 'V8'),
('R02', 'V9'),
('R02', 'V10'),
('R01', 'V11'),
('R02', 'V11'),
('R03', 'V11'),
('R01', 'V12'),
('R02', 'V12'),
('R03', 'V12'),
('R01', 'V13'),
('R02', 'V13'),
('R02', 'V14'),
('R01', 'V14'),
('R03', 'V14'),
('R01', 'V15'),
('R02', 'V15');

-- --------------------------------------------------------

--
-- Structure de la table `retarder`
--

CREATE TABLE `retarder` (
  `ID_vol` varchar(50) NOT NULL,
  `ID_retard` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `retarder`
--

INSERT INTO `retarder` (`ID_vol`, `ID_retard`) VALUES
('V3', 'RTD04'),
('V4', 'RTD02'),
('V6', 'RTD03'),
('V8', 'RTD04'),
('V9', 'RTD01'),
('V9', 'RTD02'),
('V10', 'RTD01'),
('V11', 'RTD03'),
('V12', 'RTD01'),
('V13', 'RTD04'),
('V13', 'RTD02'),
('V14', 'RTD03'),
('V14', 'RTD04');

-- --------------------------------------------------------

--
-- Structure de la table `typeavion`
--

CREATE TABLE `typeavion` (
  `ID_TypeAvion` varchar(50) NOT NULL,
  `TypeAvion` varchar(50) NOT NULL,
  `Capacite` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `typeavion`
--

INSERT INTO `typeavion` (`ID_TypeAvion`, `TypeAvion`, `Capacite`) VALUES
('TA1', 'A220', 12),
('TA2', 'A320', 20),
('TA3', 'A350', 51);

-- --------------------------------------------------------

--
-- Structure de la table `typedoc`
--

CREATE TABLE `typedoc` (
  `ID_TypeDoc` varchar(50) NOT NULL,
  `TypeDoc` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `typedoc`
--

INSERT INTO `typedoc` (`ID_TypeDoc`, `TypeDoc`) VALUES
('TD1', 'Passeport'),
('TD2', 'Carte ID');

-- --------------------------------------------------------

--
-- Structure de la table `typeemploye`
--

CREATE TABLE `typeemploye` (
  `ID_TypeEmploye` varchar(50) NOT NULL,
  `TypeEmploye` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `typeemploye`
--

INSERT INTO `typeemploye` (`ID_TypeEmploye`, `TypeEmploye`) VALUES
('TE1', 'pilote'),
('TE2', 'co-pilote'),
('TE3', 'steward'),
('TE4', 'chef de cabine');

-- --------------------------------------------------------

--
-- Structure de la table `typepaiement`
--

CREATE TABLE `typepaiement` (
  `TypePaiement` varchar(50) NOT NULL,
  `ID_TypePaiement` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `typepaiement`
--

INSERT INTO `typepaiement` (`TypePaiement`, `ID_TypePaiement`) VALUES
('CB', 'TP01'),
('paypal', 'TP02');

-- --------------------------------------------------------

--
-- Structure de la table `typerepas`
--

CREATE TABLE `typerepas` (
  `ID_TypeRepas` varchar(50) NOT NULL,
  `TypeRepas` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `typerepas`
--

INSERT INTO `typerepas` (`ID_TypeRepas`, `TypeRepas`) VALUES
('R01', 0),
('R02', 0),
('R03', 0);

-- --------------------------------------------------------

--
-- Structure de la table `typeretard`
--

CREATE TABLE `typeretard` (
  `ID_typeRetard` varchar(50) NOT NULL,
  `TypeRetard` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `typeretard`
--

INSERT INTO `typeretard` (`ID_typeRetard`, `TypeRetard`) VALUES
('RTD01', 'M?t?o d?favorable'),
('RTD02', 'Probl?mes techniques'),
('RTD03', 'Probl?mes de personnel'),
('RTD04', 'Probl?mes de s?curit?\r\n');

-- --------------------------------------------------------

--
-- Structure de la table `typevol`
--

CREATE TABLE `typevol` (
  `ID_TypeVol` varchar(50) NOT NULL,
  `TypeVol` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `typevol`
--

INSERT INTO `typevol` (`ID_TypeVol`, `TypeVol`) VALUES
('TV01', 'Moyens-courriers'),
('TV02', 'Courts-courriers'),
('TV03', 'Longs-courriers');

-- --------------------------------------------------------

--
-- Structure de la table `vol`
--

CREATE TABLE `vol` (
  `ID_vol` varchar(50) NOT NULL,
  `Prix` float NOT NULL,
  `L_carburant` int(11) NOT NULL,
  `heureDepart` time NOT NULL,
  `heureDepartReelle` time DEFAULT NULL,
  `HeureArrivee` time NOT NULL,
  `HeureArriveeReelle` time NOT NULL,
  `DateDepart` date NOT NULL,
  `DateAriveeReelle` date DEFAULT NULL,
  `Distance` int(11) NOT NULL,
  `ID_avion` varchar(50) NOT NULL,
  `ID_aeroport` varchar(50) NOT NULL,
  `ID_aeroport_Atterir` varchar(50) NOT NULL,
  `ID_aeroport_Arreter` varchar(50) NOT NULL,
  `ID_TypeVol` varchar(50) NOT NULL,
  `TempsEscal` int(11) NOT NULL,
  `DateArrivee` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `vol`
--

INSERT INTO `vol` (`ID_vol`, `Prix`, `L_carburant`, `heureDepart`, `heureDepartReelle`, `HeureArrivee`, `HeureArriveeReelle`, `DateDepart`, `DateAriveeReelle`, `Distance`, `ID_avion`, `ID_aeroport`, `ID_aeroport_Atterir`, `ID_aeroport_Arreter`, `ID_TypeVol`, `TempsEscal`, `DateArrivee`) VALUES
('V1', 150, 180, '10:00:00', '10:00:00', '16:00:00', '16:00:00', '2020-01-15', '2020-01-15', 6000, 'AV3', 'A04', 'A02', '', 'TV03', 0, '2020-01-15'),
('V10', 25, 45, '10:00:00', '00:00:00', '12:00:00', '12:00:00', '2025-04-08', NULL, 1500, 'AV1', 'A03', 'A04', '', 'TV02', 0, '2025-04-08'),
('V11', 150, 180, '06:00:00', '06:00:00', '12:00:00', '12:00:00', '2024-08-08', NULL, 6000, 'AV4', 'A02', 'A03', '', 'TV03', 0, '2024-08-08'),
('V12', 100, 420, '10:00:00', '15:00:00', '08:00:00', '13:00:00', '2023-10-31', '2023-11-01', 14000, 'AV2', 'A05', 'A01', 'A02', 'TV03', 2, '2023-11-01'),
('V13', 100, 45, '22:00:00', '01:00:00', '00:00:00', '03:00:00', '2024-01-02', '2024-01-02', 1500, 'AV1', 'A04', 'A05', '', 'TV02', 0, '2024-01-02'),
('V14', 150, 210, '23:00:00', '02:00:00', '06:00:00', '09:00:00', '2024-05-15', NULL, 7000, 'AV3', 'A05', 'A01', '', 'TV03', 0, '2024-05-16'),
('V15', 100, 45, '12:00:00', '12:00:00', '14:00:00', '14:00:00', '2024-05-16', NULL, 1500, 'AV3', 'A04', 'A05', '', 'TV02', 0, '2024-05-16'),
('V2', 100, 15, '20:00:00', '20:00:00', '21:00:00', '21:00:00', '2020-05-22', '2020-05-22', 500, 'AV1', 'A03', 'A01', '', 'TV01', 0, '2020-05-22'),
('V3', 150, 180, '21:00:00', '22:00:00', '05:00:00', '06:00:00', '2020-09-10', '2020-09-11', 6000, 'AV3', 'A02', 'A04', 'A03', 'TV03', 3, '2020-09-11'),
('V4', 150, 180, '02:00:00', '03:00:00', '10:00:00', '11:00:00', '2021-02-07', '2021-02-07', 6000, 'AV1', 'A04', 'A02', 'A03', 'TV03', 1, '2021-02-07'),
('V5', 100, 30, '08:00:00', '00:00:00', '11:00:00', '11:00:00', '2025-06-26', NULL, 1000, 'AV4', 'A01', 'A05', 'A04', 'TV01', 5, '2025-06-26'),
('V6', 25, 60, '09:00:00', '10:00:00', '11:00:00', '12:00:00', '2021-11-30', '2021-11-30', 2000, 'AV3', 'A05', 'A04', '', 'TV02', 0, '2021-11-30'),
('V7', 100, 30, '11:00:00', '00:00:00', '12:00:00', '12:00:00', '2025-02-23', NULL, 1000, 'AV1', 'A05', 'A01', '', 'TV01', 0, '2025-02-23'),
('V8', 150, 180, '10:00:00', '11:00:00', '18:00:00', '19:00:00', '2022-07-14', '2022-07-14', 6000, 'AV6', 'A04', 'A02', 'A01', 'TV03', 3, '2022-07-14'),
('V9', 100, 30, '05:00:00', '00:00:00', '15:00:00', '15:00:00', '2025-12-02', NULL, 1000, 'AV3', 'A05', 'A01', '', 'TV01', 0, '2025-12-02');

-- --------------------------------------------------------

--
-- Structure de la vue `1)b)`
--
DROP TABLE IF EXISTS `1)b)`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `1)b)`  AS SELECT sum(`billet`.`prixBillet`) AS `Bilan par type de vol`, `vol`.`ID_TypeVol` AS `ID_TypeVol`, `typevol`.`TypeVol` AS `Type de vol` FROM ((`billet` join `vol` on(`billet`.`ID_vol` = `vol`.`ID_vol`)) join `typevol` on(`vol`.`ID_TypeVol` = `typevol`.`ID_TypeVol`)) GROUP BY `typevol`.`TypeVol` ;

-- --------------------------------------------------------

--
-- Structure de la vue `1)p)`
--
DROP TABLE IF EXISTS `1)p)`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `1)p)`  AS SELECT `cartefidelite`.`ID_Compte` AS `Comptes ayant plus de 6000 miles`, `compte`.`NomC` AS `Nom`, `compte`.`PrenomC` AS `Prénom`, group_concat(`vol`.`ID_vol` separator ', ') AS `Vols en France métropolitaine` FROM ((`cartefidelite` join `compte` on(`cartefidelite`.`ID_Compte` = `compte`.`ID_compte`)) join `vol` on(1 = 1)) WHERE `cartefidelite`.`nbMiles` > 6000 AND `vol`.`ID_TypeVol` = 'TV02' AND `vol`.`DateArriveeReelle` is null GROUP BY `compte`.`ID_compte` ;

-- --------------------------------------------------------

--
-- Structure de la vue `1c`
--
DROP TABLE IF EXISTS `1c`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `1c`  AS SELECT `vol`.`ID_vol` AS `ID_vol`, avg(`billet`.`Qrepas`) AS `MoyenneQualitéDeRepas`, avg(`billet`.`Qvol`) AS `MoyenneQualitéDeVol`, avg(`billet`.`Qretard`) AS `MoyenneQualitéDeRetard` FROM (`billet` join `vol` on(`vol`.`ID_vol` = `billet`.`ID_vol`)) GROUP BY `vol`.`ID_vol` ;

-- --------------------------------------------------------

--
-- Structure de la vue `1j`
--
DROP TABLE IF EXISTS `1j`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `1j`  AS SELECT `employe`.`nomE` AS `NomE` FROM ((`affecter` join `employe` on(`affecter`.`ID_employe` = `employe`.`ID_employe`)) join `vol` on(`affecter`.`ID_vol` = `vol`.`ID_vol`)) WHERE `vol`.`ID_vol` = 'V1' ;

-- --------------------------------------------------------

--
-- Structure de la vue `id2`
--
DROP TABLE IF EXISTS `id2`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `id2`  AS SELECT `entretien`.`ID_avion` AS `ID_avion`, `entretien`.`DateEntretienPlanifie` AS `DateEntretienPlanifie`, `entretien`.`DateRelleEntretien` AS `DateRelleEntretien` FROM `entretien` ORDER BY `entretien`.`ID_avion` ASC ;

-- --------------------------------------------------------

--
-- Structure de la vue `m`
--
DROP TABLE IF EXISTS `m`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `m`  AS SELECT `aeroport`.`NomA` AS `NomA`, avg(`vol`.`Prix`) AS `PrixMoyen` FROM (`vol` join `aeroport` on(`vol`.`ID_aeroport_Atterir` = `aeroport`.`ID_aeroport`)) GROUP BY `aeroport`.`NomA` ;

-- --------------------------------------------------------

--
-- Structure de la vue `n`
--
DROP TABLE IF EXISTS `n`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `n`  AS SELECT `compte`.`ID_compte` AS `ID_Compte`, `compte`.`NomC` AS `Nom_Client`, `compte`.`PrenomC` AS `Prenom_Client`, `compte`.`adresseMail` AS `Email_Client`, `compte`.`AdressePostal` AS `Adresse_Client`, `compte`.`DateNaissance` AS `Date_Naissance_Client`, `vol`.`ID_vol` AS `ID_Vol`, `vol`.`Prix` AS `Prix_Vol`, `vol`.`DateDepart` AS `Date_Depart`, `vol`.`heureDepart` AS `Heure_Depart`, `vol`.`DateAriveeReelle` AS `Date_Arrivee`, `vol`.`HeureArrivee` AS `Heure_Arrivee`, `facture`.`ID_facture` AS `ID_Facture`, `facture`.`Montant` AS `Montant_Facture`, `commande`.`ID_commande` AS `N_commande` FROM ((((((`compte` join `commande` on(`compte`.`ID_compte` = `commande`.`ID_Compte`)) join `appartenir` on(`commande`.`ID_commande` = `appartenir`.`ID_commande`)) join `passager` on(`appartenir`.`ID_passager` = `passager`.`ID_passager`)) join `billet` on(`passager`.`ID_passager` = `billet`.`ID_Passager`)) join `vol` on(`billet`.`ID_vol` = `vol`.`ID_vol`)) join `facture` on(`commande`.`ID_commande` = `facture`.`ID_commande`)) WHERE `compte`.`NomC` like 'Client%' GROUP BY `compte`.`ID_compte`, `vol`.`ID_vol`, `commande`.`ID_commande`, `facture`.`ID_facture` ;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `aeroport`
--
ALTER TABLE `aeroport`
  ADD PRIMARY KEY (`ID_aeroport`);

--
-- Index pour la table `affecter`
--
ALTER TABLE `affecter`
  ADD KEY `employe` (`ID_employe`),
  ADD KEY `ID_vol` (`ID_vol`);

--
-- Index pour la table `appartenir`
--
ALTER TABLE `appartenir`
  ADD KEY `commande` (`ID_commande`),
  ADD KEY `passager` (`ID_passager`);

--
-- Index pour la table `avion`
--
ALTER TABLE `avion`
  ADD PRIMARY KEY (`ID_Avion`),
  ADD KEY `ID_TypeAvion` (`ID_TypeAvion`);

--
-- Index pour la table `billet`
--
ALTER TABLE `billet`
  ADD PRIMARY KEY (`ID_billet`),
  ADD KEY `place` (`ID_CategoriePlace`),
  ADD KEY `ID_vol` (`ID_vol`),
  ADD KEY `ID_Passager` (`ID_Passager`);

--
-- Index pour la table `cartefidelite`
--
ALTER TABLE `cartefidelite`
  ADD PRIMARY KEY (`ID_carte`),
  ADD KEY `ID_Compte` (`ID_Compte`);

--
-- Index pour la table `categoriepassager`
--
ALTER TABLE `categoriepassager`
  ADD PRIMARY KEY (`ID_CategoriePassager`);

--
-- Index pour la table `categorieplace`
--
ALTER TABLE `categorieplace`
  ADD PRIMARY KEY (`ID_CategoriePlace`);

--
-- Index pour la table `commande`
--
ALTER TABLE `commande`
  ADD PRIMARY KEY (`ID_commande`),
  ADD KEY `ID_Compte` (`ID_Compte`);

--
-- Index pour la table `compte`
--
ALTER TABLE `compte`
  ADD PRIMARY KEY (`ID_compte`);

--
-- Index pour la table `employe`
--
ALTER TABLE `employe`
  ADD PRIMARY KEY (`ID_employe`),
  ADD KEY `ID_TypeEmploye` (`ID_TypeEmploye`);

--
-- Index pour la table `entretien`
--
ALTER TABLE `entretien`
  ADD PRIMARY KEY (`ID_Entretien`),
  ADD KEY `ID_avion` (`ID_avion`);

--
-- Index pour la table `facture`
--
ALTER TABLE `facture`
  ADD PRIMARY KEY (`ID_facture`),
  ADD KEY `a` (`ID_TypePaiement`),
  ADD KEY `b` (`ID_commande`);

--
-- Index pour la table `passager`
--
ALTER TABLE `passager`
  ADD PRIMARY KEY (`ID_passager`),
  ADD KEY `ID_categoriePassager` (`ID_categoriePassager`),
  ADD KEY `ID_typeDoc` (`ID_typeDoc`);

--
-- Index pour la table `proposer`
--
ALTER TABLE `proposer`
  ADD KEY `typeRepas` (`ID_TypeRepas`),
  ADD KEY `vol` (`ID_vol`);

--
-- Index pour la table `retarder`
--
ALTER TABLE `retarder`
  ADD KEY `retard` (`ID_retard`),
  ADD KEY `ID_vol` (`ID_vol`);

--
-- Index pour la table `typeavion`
--
ALTER TABLE `typeavion`
  ADD PRIMARY KEY (`ID_TypeAvion`);

--
-- Index pour la table `typedoc`
--
ALTER TABLE `typedoc`
  ADD PRIMARY KEY (`ID_TypeDoc`);

--
-- Index pour la table `typeemploye`
--
ALTER TABLE `typeemploye`
  ADD PRIMARY KEY (`ID_TypeEmploye`);

--
-- Index pour la table `typepaiement`
--
ALTER TABLE `typepaiement`
  ADD PRIMARY KEY (`ID_TypePaiement`);

--
-- Index pour la table `typerepas`
--
ALTER TABLE `typerepas`
  ADD PRIMARY KEY (`ID_TypeRepas`);

--
-- Index pour la table `typeretard`
--
ALTER TABLE `typeretard`
  ADD PRIMARY KEY (`ID_typeRetard`);

--
-- Index pour la table `typevol`
--
ALTER TABLE `typevol`
  ADD PRIMARY KEY (`ID_TypeVol`);

--
-- Index pour la table `vol`
--
ALTER TABLE `vol`
  ADD PRIMARY KEY (`ID_vol`),
  ADD KEY `depart` (`ID_aeroport`),
  ADD KEY `escal` (`ID_aeroport_Arreter`),
  ADD KEY `arrive` (`ID_aeroport_Atterir`),
  ADD KEY `avion` (`ID_avion`),
  ADD KEY `c` (`ID_TypeVol`);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `affecter`
--
ALTER TABLE `affecter`
  ADD CONSTRAINT `affecter_ibfk_1` FOREIGN KEY (`ID_vol`) REFERENCES `vol` (`ID_vol`),
  ADD CONSTRAINT `employe` FOREIGN KEY (`ID_employe`) REFERENCES `employe` (`ID_employe`);

--
-- Contraintes pour la table `appartenir`
--
ALTER TABLE `appartenir`
  ADD CONSTRAINT `commande` FOREIGN KEY (`ID_commande`) REFERENCES `commande` (`ID_commande`),
  ADD CONSTRAINT `passager` FOREIGN KEY (`ID_passager`) REFERENCES `passager` (`ID_passager`);

--
-- Contraintes pour la table `avion`
--
ALTER TABLE `avion`
  ADD CONSTRAINT `avion_ibfk_1` FOREIGN KEY (`ID_TypeAvion`) REFERENCES `typeavion` (`ID_TypeAvion`);

--
-- Contraintes pour la table `billet`
--
ALTER TABLE `billet`
  ADD CONSTRAINT `billet_ibfk_1` FOREIGN KEY (`ID_vol`) REFERENCES `vol` (`ID_vol`),
  ADD CONSTRAINT `billet_ibfk_2` FOREIGN KEY (`ID_Passager`) REFERENCES `passager` (`ID_passager`),
  ADD CONSTRAINT `place` FOREIGN KEY (`ID_CategoriePlace`) REFERENCES `categorieplace` (`ID_CategoriePlace`);

--
-- Contraintes pour la table `cartefidelite`
--
ALTER TABLE `cartefidelite`
  ADD CONSTRAINT `cartefidelite_ibfk_1` FOREIGN KEY (`ID_Compte`) REFERENCES `compte` (`ID_compte`);

--
-- Contraintes pour la table `commande`
--
ALTER TABLE `commande`
  ADD CONSTRAINT `commande_ibfk_1` FOREIGN KEY (`ID_Compte`) REFERENCES `compte` (`ID_compte`);

--
-- Contraintes pour la table `employe`
--
ALTER TABLE `employe`
  ADD CONSTRAINT `employe_ibfk_1` FOREIGN KEY (`ID_TypeEmploye`) REFERENCES `typeemploye` (`ID_TypeEmploye`);

--
-- Contraintes pour la table `entretien`
--
ALTER TABLE `entretien`
  ADD CONSTRAINT `entretien_ibfk_1` FOREIGN KEY (`ID_avion`) REFERENCES `avion` (`ID_Avion`);

--
-- Contraintes pour la table `facture`
--
ALTER TABLE `facture`
  ADD CONSTRAINT `a` FOREIGN KEY (`ID_TypePaiement`) REFERENCES `typepaiement` (`ID_TypePaiement`),
  ADD CONSTRAINT `b` FOREIGN KEY (`ID_commande`) REFERENCES `commande` (`ID_commande`);

--
-- Contraintes pour la table `passager`
--
ALTER TABLE `passager`
  ADD CONSTRAINT `passager_ibfk_1` FOREIGN KEY (`ID_categoriePassager`) REFERENCES `categoriepassager` (`ID_CategoriePassager`),
  ADD CONSTRAINT `passager_ibfk_2` FOREIGN KEY (`ID_typeDoc`) REFERENCES `typedoc` (`ID_TypeDoc`);

--
-- Contraintes pour la table `proposer`
--
ALTER TABLE `proposer`
  ADD CONSTRAINT `typeRepas` FOREIGN KEY (`ID_TypeRepas`) REFERENCES `typerepas` (`ID_TypeRepas`),
  ADD CONSTRAINT `vol` FOREIGN KEY (`ID_vol`) REFERENCES `vol` (`ID_vol`);

--
-- Contraintes pour la table `retarder`
--
ALTER TABLE `retarder`
  ADD CONSTRAINT `retard` FOREIGN KEY (`ID_retard`) REFERENCES `typeretard` (`ID_typeRetard`),
  ADD CONSTRAINT `retarder_ibfk_1` FOREIGN KEY (`ID_vol`) REFERENCES `vol` (`ID_vol`);

--
-- Contraintes pour la table `vol`
--
ALTER TABLE `vol`
  ADD CONSTRAINT `arrive` FOREIGN KEY (`ID_aeroport_Atterir`) REFERENCES `aeroport` (`ID_aeroport`),
  ADD CONSTRAINT `avion` FOREIGN KEY (`ID_avion`) REFERENCES `avion` (`ID_Avion`),
  ADD CONSTRAINT `c` FOREIGN KEY (`ID_TypeVol`) REFERENCES `typevol` (`ID_TypeVol`),
  ADD CONSTRAINT `depart` FOREIGN KEY (`ID_aeroport`) REFERENCES `aeroport` (`ID_aeroport`),
  ADD CONSTRAINT `escal` FOREIGN KEY (`ID_aeroport_Arreter`) REFERENCES `aeroport` (`ID_aeroport`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
