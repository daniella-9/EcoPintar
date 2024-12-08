CREATE DATABASE IF NOT EXISTS STEM;
USE STEM;

CREATE TABLE `profile` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `foto` varchar(255) NOT NULL,
  `jenis_kelamin` enum('Laki-laki','Perempuan') NOT NULL,
  `tanggal_lahir` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(20) NOT NULL,
  `password` varchar(50) DEFAULT NULL,
  `nama` varchar(200) NOT NULL,
  `email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

ALTER TABLE `profile`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

ALTER TABLE `user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

ALTER TABLE `profile`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

ALTER TABLE `profile`
  ADD CONSTRAINT `profile_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- Tables for Carbon Footprint Calculations

-- Table Peralatan Elektronik
CREATE TABLE `appliances_usage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `nama_peralatan` varchar(100) DEFAULT NULL,
  `power_watts` int(11) DEFAULT NULL,
  `hours_used` decimal(5,2) DEFAULT NULL,
  `emission` decimal(10,2) GENERATED ALWAYS AS (
    CASE 
      WHEN `power_watts` IS NOT NULL AND `hours_used` IS NOT NULL 
      THEN `power_watts` * `hours_used` * 0.00085 
      ELSE NULL 
    END
  ) STORED, -- Emission is optional
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for Waste Management
CREATE TABLE `waste_management` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL, -- Optional user association
  `waste_type` enum('plastik', 'logam', 'kaca', 'kertas') DEFAULT NULL, -- Optional type of waste
  `weight_kg` decimal(10,2) DEFAULT NULL, -- Optional weight
  `emission` decimal(10,2) GENERATED ALWAYS AS (
    CASE 
      WHEN `weight_kg` IS NOT NULL 
      THEN `weight_kg` * 0.3 
      ELSE NULL 
    END
  ) STORED, -- Emission is optional
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table for Fuel Usage
CREATE TABLE `fuel_usage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL, -- Optional user association
  `fuel_type` enum('bensin', 'diesel', 'LPG', 'pertalite', 'pertamax', 'biodiesel', 'ethanol') DEFAULT NULL, -- Optional fuel type
  `volume_liters` decimal(10,2) DEFAULT NULL, -- Optional volume
  `emission` decimal(10,2) GENERATED ALWAYS AS (
    CASE 
      WHEN `volume_liters` IS NOT NULL 
      THEN `volume_liters` * 2.3 
      ELSE NULL 
    END
  ) STORED, -- Emission is optional
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

COMMIT;
