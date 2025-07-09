-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jul 09, 2025 at 06:17 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rona_malang`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`) VALUES
(1, 'Hiburan'),
(2, 'Kuliner'),
(3, 'Alam'),
(4, 'Pusat Oleh-Oleh');

-- --------------------------------------------------------

--
-- Table structure for table `places`
--

CREATE TABLE `places` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `rating` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `places`
--

INSERT INTO `places` (`id`, `name`, `location`, `image`, `category_id`, `rating`) VALUES
(1, 'Paralayang Batu', 'Batu, Jawa Timur.', ' paralayangbatu.png', 3, 4),
(2, 'Jatim Park 1', 'Batu, Jawa Timur.', 'jatimpark1.png', 1, 5),
(3, 'Jatim Park 2', 'Jl Raya Oro-Oro Ombo, Batu.', 'jatimpark2.png', 1, 5),
(4, 'Jatim Park 3', 'Batu, Jawa Timur.', 'jatimpark3.png', 1, 5),
(5, 'Batu Night Spectacular', 'Jl. Oro-Oro Ombo, Batu.', 'bns.png', 1, 4),
(6, 'Museum Angkut', 'Batu, Jawa Timur.', 'museumangkut.png', 1, 4),
(7, 'Sego Sambel Cak Uut', 'Jl. Simpang Raya Langsep, Pisang Candi.', 'segosambelcakuut.png', 2, 5),
(8, 'Warung Bakso President', 'Jl. Batahari.', 'warungbaksopresident.png', 2, 5),
(9, 'Rawon Suhat', 'Jl. Soekarno Hatta.', 'rawonsuhat.png', 2, 4),
(10, 'Angsle dan Ronde Titoni', 'Jl. Zainul Arifin, Klojen.', 'angsleronde.png', 2, 4),
(11, 'Pos Ketan Legenda', 'Jl. Kartini, Ngaglik, Batu.', 'posketanlegenda.png', 2, 5),
(12, 'Mie Bakar Celaket', 'Jl. Jasa Agung Suprapto.', 'miecelaket.png', 2, 4),
(13, 'Pantai Batu Bengkung', 'Kabupaten Hutan, Gajahrej.', 'pantaibatubengkung.png', 3, 5),
(14, 'Coban Rondo', 'Kec Pujon, Jawa Timur.', 'cobanrondo.png', 3, 4),
(15, 'Kampung Warna Warni', 'Jl. Ir. H. Juanda, Jodipan.', 'kampungwarnawarni.png', 3, 4),
(16, 'Tumpak Sewu', 'Lumajang.', 'tumpaksewuterjun.png', 3, 5),
(17, 'Taman Rekreasi Selecta', 'Jl. Raya Selecta, Tulungrejo.', 'tamanrekreasiselcta.png', 1, 4),
(18, 'Pia Cap Mangkok', 'Jl. Semeru.', 'piacapbangkok.png', 4, 5),
(19, 'Bolu Malang Singosari', 'Jl. Bandulan No. 36.', 'bolumalangsingosari.png', 4, 5),
(20, 'Malang Strudel', 'Jl. Semeru No. 47.', 'malangstrudel.png', 4, 4),
(21, 'Keripik Buah', 'Jl. Galunggung, Klojen.', 'keripikbuah.png', 4, 4),
(22, 'Sensa', 'Jl. Raya Randu Agung.', 'sensa.png', 4, 5),
(23, 'Siiplah', 'Batu, Jawa Timur', 'siiplah.png', 4, 4),
(24, 'Pantai Balekambang', 'Kecamatan Bantur, Kabupaten Malang', 'balekambang.jpg', 3, 4),
(25, 'Gunung Bromo', 'Pasuruan, Jawa Timur', 'bromo.png', 3, 4);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `username`, `password`, `created_at`) VALUES
(1, 'ranindya@gmail.com', 'ranin', '$2y$10$zKfEZpJc2Lo8MDusaQbIzOMMJgRu2mi4jBitzyt.sA0fKokbEuHxm', '2025-07-08 15:02:34');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `places`
--
ALTER TABLE `places`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `places`
--
ALTER TABLE `places`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `places`
--
ALTER TABLE `places`
  ADD CONSTRAINT `places_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
