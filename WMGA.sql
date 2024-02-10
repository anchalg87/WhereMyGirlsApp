-- phpMyAdmin SQL Dump
-- version 4.5.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Aug 04, 2016 at 06:38 PM
-- Server version: 10.1.13-MariaDB
-- PHP Version: 5.5.37

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `WMGA`
--

-- --------------------------------------------------------

--
-- Table structure for table `Groupdetails`
--

CREATE TABLE `Groupdetails` (
  `uemail` varchar(30) NOT NULL,
  `groupname` varchar(15) NOT NULL,
  `grppassword` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Groupdetails`
--

INSERT INTO `Groupdetails` (`uemail`, `groupname`, `grppassword`) VALUES
('teja@gmail.com', 'teja_group', 'teja'),
('test@gmail.com', 'test_group', 'test'),
('susheel@gmail.com', 'susheel_group', 'susheel'),
('test1@gmail.com', 'test1_group', 'test1'),
('demo@gmail.com', 'demo1_group', 'demo1'),
('test2@gmail.com', 'testers', 'testers');

-- --------------------------------------------------------

--
-- Table structure for table `GroupMemberdetails`
--

CREATE TABLE `GroupMemberdetails` (
  `groupname` varchar(15) NOT NULL,
  `uemail` varchar(30) NOT NULL,
  `status` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `GroupMemberdetails`
--

INSERT INTO `GroupMemberdetails` (`groupname`, `uemail`, `status`) VALUES
('demo1_group', 'demo@gmail.com', 1),
('susheel_group', 'susheel@gmail.com', 1),
('teja_group', 'anchal@gmail.com', 2),
('teja_group', 'teja@gmail.com', 1),
('test1_group', 'test1@gmail.com', 1),
('testers', 'anchal@gmail.com', 1),
('testers', 'test2@gmail.com', 1),
('test_group', 'anchal@gmail.com', 0),
('test_group', 'sudheer@gmail.com', 1),
('test_group', 'teja@gmail.com', 1),
('test_group', 'test@gmail.com', 1);

-- --------------------------------------------------------

--
-- Table structure for table `Logindetails`
--

CREATE TABLE `Logindetails` (
  `uid` int(4) NOT NULL,
  `uname` varchar(20) NOT NULL,
  `upwd` varchar(12) NOT NULL,
  `uphone` int(10) NOT NULL,
  `uemail` varchar(30) NOT NULL,
  `aptno` varchar(10) NOT NULL,
  `address` varchar(40) NOT NULL,
  `zipcode` varchar(10) NOT NULL,
  `latitude` varchar(20) NOT NULL,
  `longitude` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Logindetails`
--

INSERT INTO `Logindetails` (`uid`, `uname`, `upwd`, `uphone`, `uemail`, `aptno`, `address`, `zipcode`, `latitude`, `longitude`) VALUES
(64, 'sudheer', 'sudheer', 2147483647, 'sudheer@gmail.com', ' 1230', ' UHCL', ' 77058', '37.45369182', '-122.28369081'),
(65, 'anchal', 'anchal', 1231231231, 'anchal@gmail.com', ' 1231', ' uhcl1', ' 77059', '37.71268789', '-122.45289386'),
(67, 'test', 'test', 1213131, 'test@gmail.com', ' 123', ' hu', ' 80882', '37.33233141', '-122.0312186'),
(68, 'susheel', 'ssusheel', 2147483647, 'susheel@gmail.com', ' 1313', ' ivy', ' 99892', '37.33233141', '-122.0312186'),
(69, 'test1', 'test1', 2123133441, 'test1@gmail.com', ' 12133', ' hou', ' 36562', '37.45369182', '-122.28369081'),
(70, 'demo', 'demo', 1234567123, 'demo@gmail.com', ' 1213', ' houston', ' 77067', '37.42556261', '-122.23036783'),
(71, 'test', 'test1', 1234567890, 'test2@gmail.com', ' 2100', ' uhcl', ' 77058', '37.71268789', '-122.45289386');

-- --------------------------------------------------------

--
-- Table structure for table `UserCurrentLocation`
--

CREATE TABLE `UserCurrentLocation` (
  `uemail` varchar(30) NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `dateCreated` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `GroupMemberdetails`
--
ALTER TABLE `GroupMemberdetails`
  ADD PRIMARY KEY (`groupname`,`uemail`);

--
-- Indexes for table `Logindetails`
--
ALTER TABLE `Logindetails`
  ADD PRIMARY KEY (`uid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Logindetails`
--
ALTER TABLE `Logindetails`
  MODIFY `uid` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
