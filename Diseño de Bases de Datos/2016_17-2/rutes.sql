-- phpMyAdmin SQL Dump
-- version 4.4.10
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Mar 15, 2017 at 01:11 AM
-- Server version: 5.5.42
-- PHP Version: 7.0.0

SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `rutes`
--
CREATE DATABASE IF NOT EXISTS `rutes` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
USE `rutes`;

-- --------------------------------------------------------

--
-- Table structure for table `camió`
--

DROP TABLE IF EXISTS `camió`;
CREATE TABLE IF NOT EXISTS `camió` (
  `matrícula` varchar(10) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `tonatge` int(11) DEFAULT NULL,
  `volum` int(11) DEFAULT NULL,
  `consum` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Truncate table before insert `camió`
--

TRUNCATE TABLE `camió`;
--
-- Dumping data for table `camió`
--

INSERT INTO `camió` (`matrícula`, `tonatge`, `volum`, `consum`) VALUES
('1111-BBB', 20, 90, 10),
('2222-CCC', 10, 30, 8),
('3333-DDD', 15, 40, 9),
('4444-FFF', 40, 120, 14),
('5555-AAA', 25, 95, 12);

-- --------------------------------------------------------

--
-- Table structure for table `ciutat`
--

DROP TABLE IF EXISTS `ciutat`;
CREATE TABLE IF NOT EXISTS `ciutat` (
  `id` int(11) NOT NULL,
  `nom` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `acrònim` varchar(3) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Truncate table before insert `ciutat`
--

TRUNCATE TABLE `ciutat`;
--
-- Dumping data for table `ciutat`
--

INSERT INTO `ciutat` (`id`, `nom`, `acrònim`) VALUES
(1, 'Barcelona', 'BCN'),
(2, 'Lleida', 'LLE'),
(3, 'Zaragoza', 'ZAR'),
(4, 'Granollers', 'GRA'),
(5, 'Madrid', 'MAD'),
(6, 'Vic', 'VIC');

-- --------------------------------------------------------

--
-- Table structure for table `conductor`
--

DROP TABLE IF EXISTS `conductor`;
CREATE TABLE IF NOT EXISTS `conductor` (
  `DNI` varchar(9) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `nom` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cognoms` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `telefon` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `camió_matrícula` varchar(10) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Truncate table before insert `conductor`
--

TRUNCATE TABLE `conductor`;
--
-- Dumping data for table `conductor`
--

INSERT INTO `conductor` (`DNI`, `nom`, `cognoms`, `telefon`, `camió_matrícula`) VALUES
('52111111A', 'Joan', 'Muntada', '937996722', '1111-BBB'),
('52222222B', 'Pere', 'Font', '933912815', '5555-AAA'),
('52333333C', 'Àlex', 'Cabaner', '934685886', '2222-CCC'),
('52444444D', 'Cinto', 'Torrent', '933915388', '4444-FFF'),
('52555555E', 'Josep', 'Torrent', '933915399', '4444-FFF');

-- --------------------------------------------------------

--
-- Table structure for table `itinerari`
--

DROP TABLE IF EXISTS `itinerari`;
CREATE TABLE IF NOT EXISTS `itinerari` (
  `codi_ruta` int(11) NOT NULL,
  `ciutat_partida` int(11) NOT NULL,
  `ciutat_destí` int(11) NOT NULL,
  `distància` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Truncate table before insert `itinerari`
--

TRUNCATE TABLE `itinerari`;
--
-- Dumping data for table `itinerari`
--

INSERT INTO `itinerari` (`codi_ruta`, `ciutat_partida`, `ciutat_destí`, `distància`) VALUES
(1, 1, 2, 163),
(1, 2, 3, 152),
(1, 3, 5, 314),
(1, 5, 5, 0),
(2, 3, 2, 150),
(2, 2, 1, 177),
(2, 1, 1, 0),
(3, 1, 4, 34),
(3, 4, 6, 43),
(3, 6, 6, 0);

-- --------------------------------------------------------

--
-- Table structure for table `ruta`
--

DROP TABLE IF EXISTS `ruta`;
CREATE TABLE IF NOT EXISTS `ruta` (
  `codi_ruta` int(11) NOT NULL,
  `nom` varchar(25),
  `cost_peatge` int(11) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Truncate table before insert `ruta`
--

TRUNCATE TABLE `ruta`;
--
-- Dumping data for table `ruta`
--

INSERT INTO `ruta` (`codi_ruta`, `nom`, `cost_peatge`) VALUES
(1, 'Ruta central', 30),
(2, 'Ruta del préssec', 15),
(3, 'La catalana', 0);

-- --------------------------------------------------------

--
-- Table structure for table `transport`
--

DROP TABLE IF EXISTS `transport`;
CREATE TABLE IF NOT EXISTS `transport` (
  `matrícula` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_inici` date DEFAULT NULL,
  `data_finalització` date DEFAULT NULL,
  `codi_ruta` int(11) DEFAULT NULL,
  `incidències` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pes` int(11) DEFAULT NULL,
  `volum` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Truncate table before insert `transport`
--

TRUNCATE TABLE `transport`;
--
-- Dumping data for table `transport`
--

INSERT INTO `transport` (`matrícula`, `data_inici`, `data_finalització`, `codi_ruta`, `incidències`, `pes`, `volum`) VALUES
('1111-BBB', '2017-02-02', '2017-02-04', 2, 'Retard per la vaga de taxis', 15, 80),
('1111-BBB', '2017-02-05', '2017-02-06', 3, 'Punxada', 19, 85),
('1111-BBB', '2017-02-10', NULL, 1, NULL, 13, 70),
('2222-CCC', '2017-02-03', '2017-02-06', 2, 'Cap incidència', 7, 25),
('2222-CCC', '2017-02-10', '2017-02-16', 1, 'Hem patit una punxada a Saragossa', 6, 23),
('2222-CCC', '2017-02-07', '2017-02-08', 3, 'Multa per excés de tonatge', 11, 20),
('3333-DDD', '2017-02-07', '2017-02-10', 2, 'Embús a la sortida de Lleida', 15, 38),
('3333-DDD', '2017-02-13', '2017-02-17', 1, NULL, 12, 20),
('4444-FFF', '2017-02-05', '2017-02-06', 2, 'Control d\'alcoholèmia', 16, 85);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `camió`
--
ALTER TABLE `camió`
  ADD PRIMARY KEY (`matrícula`);

--
-- Indexes for table `ciutat`
--
ALTER TABLE `ciutat`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `conductor`
--
ALTER TABLE `conductor`
  ADD PRIMARY KEY (`DNI`),
  ADD KEY `camió_matrícula` (`camió_matrícula`);

--
-- Indexes for table `itinerari`
--
ALTER TABLE `itinerari`
  ADD KEY `ciutat_partida` (`ciutat_partida`),
  ADD KEY `ciutat_destí` (`ciutat_destí`);

--
-- Indexes for table `ruta`
--
ALTER TABLE `ruta`
  ADD PRIMARY KEY (`codi_ruta`);

--
-- Indexes for table `transport`
--
ALTER TABLE `transport`
  ADD KEY `matrícula` (`matrícula`),
  ADD KEY `codi_ruta` (`codi_ruta`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ciutat`
--
ALTER TABLE `ciutat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `ruta`
--
ALTER TABLE `ruta`
  MODIFY `codi_ruta` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `camió`
--
ALTER TABLE `conductor`
  ADD CONSTRAINT `conductor_ibfk_1` FOREIGN KEY (`camió_matrícula`) REFERENCES `CAMIÓ` (`matrícula`);

--
-- Constraints for table `itinerari`
--
ALTER TABLE `itinerari`
  ADD CONSTRAINT `itinerari_ibfk_2` FOREIGN KEY (`ciutat_destí`) REFERENCES `ciutat` (`id`),
  ADD CONSTRAINT `itinerari_ibfk_1` FOREIGN KEY (`ciutat_partida`) REFERENCES `ciutat` (`id`);

--
-- Constraints for table `transport`
--
ALTER TABLE `transport`
  ADD CONSTRAINT `transport_ibfk_2` FOREIGN KEY (`codi_ruta`) REFERENCES `ruta` (`codi_ruta`),
  ADD CONSTRAINT `transport_ibfk_1` FOREIGN KEY (`matrícula`) REFERENCES `CAMIÓ` (`matrícula`);
SET FOREIGN_KEY_CHECKS=1;
