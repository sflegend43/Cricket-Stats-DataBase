CREATE DATABASE CricketStatsDB;
GO
USE CricketStatsDB;
GO

CREATE TABLE Players(
    playerID VARCHAR(15) PRIMARY KEY,
    playerName VARCHAR(60) NOT NULL,
    playerDOB DATE NOT NULL,
    playerNationality VARCHAR(60) NOT NULL,
    battingStyle VARCHAR(60),
    bowlingStyle VARCHAR(60),
    playerRole VARCHAR(20) CHECK(playerRole IN ('Batsman', 'Bowler', 'AllRounder', 'WicketKeeper'))
);

CREATE TABLE Team(
    teamName VARCHAR(60) PRIMARY KEY,
    country VARCHAR(60) NOT NULL,
    headCoach VARCHAR(60),
    teamCaptain VARCHAR(60),
    ranking INT NOT NULL
);
CREATE TABLE Venue(
    venueID INT PRIMARY KEY,
    venueName VARCHAR(60) NOT NULL,
    venueCity VARCHAR(60) NOT NULL,
    venueCountry VARCHAR(60) NOT NULL,
    venueCapacity BIGINT NOT NULL
);
CREATE TABLE Umpire(
    umpireID INT PRIMARY KEY,
    umpireName VARCHAR(60) NOT NULL,
    umpireNationality VARCHAR(60) NOT NULL,
    umpireExperienceMatches INT NOT NULL
);
CREATE TABLE Matches(
    matchID INT PRIMARY KEY,
    tournamentName VARCHAR(60) NOT NULL,
    matchFormat VARCHAR(5) NOT NULL CHECK(matchFormat IN ('T20', 'ODI', 'TEST', 'T10')),
    matchType VARCHAR(20) NOT NULL CHECK(matchType IN ('League', 'Semi-Final', 'Final', 'Group-Stage')),
    isDayNight BIT DEFAULT 0,
    team1Name VARCHAR(60) NOT NULL,
    team2Name VARCHAR(60) NOT NULL,
    venueID INT NOT NULL,
    matchDate DATE,
    winnerName VARCHAR(60),
    tossWinnerName VARCHAR(60),
    winMargin VARCHAR(60),
    onFieldUmpire1ID INT NOT NULL,
    onFieldUmpire2ID INT NOT NULL,
    thirdUmpireID INT,
    team1TotalRuns INT DEFAULT 0,
    team1TotalWickets INT DEFAULT 0,
    team2TotalRuns INT DEFAULT 0,
    team2TotalWickets INT DEFAULT 0,
    FOREIGN KEY (venueID) REFERENCES Venue(venueID),
    FOREIGN KEY (team1Name) REFERENCES Team(teamName),
    FOREIGN KEY (team2Name) REFERENCES Team(teamName),
    FOREIGN KEY (winnerName) REFERENCES Team(teamName),
    FOREIGN KEY (tossWinnerName) REFERENCES Team(teamName),
    FOREIGN KEY (onFieldUmpire1ID) REFERENCES Umpire(umpireID),
    FOREIGN KEY (onFieldUmpire2ID) REFERENCES Umpire(umpireID),
    FOREIGN KEY (thirdUmpireID) REFERENCES Umpire(umpireID)
);
CREATE TABLE BallByBall(
    ballID INT PRIMARY KEY IDENTITY(1,1),
    matchID INT NOT NULL,
    inningsNumber INT NOT NULL CHECK(inningsNumber BETWEEN 1 AND 4),
    overNumber INT NOT NULL,
    ballNumber INT NOT NULL CHECK(ballNumber >= 1),
    batsmanID VARCHAR(15) NOT NULL,
    bowlerID VARCHAR(15) NOT NULL,
    runsScored INT NOT NULL,
    extras INT DEFAULT 0,
    extraType VARCHAR(30),
    wicketFallen BIT DEFAULT 0,
    dismissedPlayerID VARCHAR(15),
    wicketType VARCHAR(60),
    FOREIGN KEY (matchID) REFERENCES Matches(matchID),
    FOREIGN KEY (batsmanID) REFERENCES Players(playerID),
    FOREIGN KEY (dismissedPlayerID) REFERENCES Players(playerID),
    FOREIGN KEY (bowlerID) REFERENCES Players(playerID)
);
CREATE TABLE Squad(
    teamName VARCHAR(60) NOT NULL,
    playerID VARCHAR(15) NOT NULL,
    PRIMARY KEY(teamName, playerID),
    FOREIGN KEY (teamName) REFERENCES Team(teamName),
    FOREIGN KEY (playerID) REFERENCES Players(playerID)
);
CREATE TABLE PlayingXI (
    matchID INT NOT NULL,
    playerID VARCHAR(15) NOT NULL,
    matchRole VARCHAR(20) CHECK(matchRole IN ('Player', 'Captain', 'WicketKeeper', 'Captain & WK')),
    PRIMARY KEY (matchID, playerID),
    FOREIGN KEY (matchID) REFERENCES Matches(matchID),
    FOREIGN KEY (playerID) REFERENCES Players(playerID)
);


GO

INSERT INTO Team (teamName, country, headCoach, teamCaptain, ranking) VALUES
('Pakistan Cricket Team', 'Pakistan', 'Mike Hessan', 'Babar Azam', 3),
('Indian Cricket Team', 'India', 'Gautam Gambhir', 'Rohit Sharma', 1),
('Australian Cricket Team', 'Australia', 'Andrew McDonald', 'Mitchell Marsh', 2),
('South Africa Cricket Team', 'South Africa', 'Rob Walter', 'Temba Bavuma', 4),
('New Zealand Cricket Team', 'New Zealand', 'Gary Stead', 'Kane Williamson', 5),
('England Cricket Team', 'England', 'Brendon McCullum', 'Ben Stokes', 6);

INSERT INTO Players (playerID, playerName, playerDOB, playerNationality, battingStyle, bowlingStyle, playerRole) VALUES
('PAK56', 'Babar Azam', '1994-10-15', 'Pakistan', 'Right-Hand', 'Right-arm Offbreak', 'Batsman'),
('PAK16', 'Mohammad Rizwan', '1992-06-01', 'Pakistan', 'Right-Hand', 'None', 'WicketKeeper'),
('PAK39', 'Fakhar Zaman', '1990-04-10', 'Pakistan', 'Left-Hand', 'Left-arm Orthodox', 'Batsman'),
('PAK29', 'Saim Ayub', '2002-05-24', 'Pakistan', 'Left-Hand', 'Right-arm Offbreak', 'Batsman'),
('PAK51', 'Iftikhar Ahmed', '1990-09-03', 'Pakistan', 'Right-Hand', 'Right-arm Offbreak', 'AllRounder'),
('PAK07', 'Shadab Khan', '1998-10-04', 'Pakistan', 'Right-Hand', 'Right-arm Legbreak', 'AllRounder'),
('PAK09', 'Imad Wasim', '1988-12-18', 'Pakistan', 'Left-Hand', 'Left-arm Orthodox', 'AllRounder'),
('PAK10', 'Shaheen Afridi', '2000-04-06', 'Pakistan', 'Left-Hand', 'Left-arm Fast', 'Bowler'),
('PAK71', 'Naseem Shah', '2003-02-15', 'Pakistan', 'Right-Hand', 'Right-arm Fast', 'Bowler'),
('PAK97', 'Haris Rauf', '1993-11-07', 'Pakistan', 'Right-Hand', 'Right-arm Fast', 'Bowler'),
('PAK05', 'Mohammad Amir', '1992-04-13', 'Pakistan', 'Right-Hand', 'Left-arm Fast', 'Bowler'),
('IND45', 'Rohit Sharma', '1987-04-30', 'India', 'Right-Hand', 'Right-arm Offbreak', 'Batsman'),
('IND18', 'Virat Kohli', '1988-11-05', 'India', 'Right-Hand', 'Right-arm Medium', 'Batsman'),
('IND64', 'Yashasvi Jaiswal', '2001-12-28', 'India', 'Left-Hand', 'Right-arm Legbreak', 'Batsman'),
('IND63', 'Suryakumar Yadav', '1990-09-14', 'India', 'Right-Hand', 'Right-arm Medium', 'Batsman'),
('IND17', 'Rishabh Pant', '1997-10-04', 'India', 'Left-Hand', 'None', 'WicketKeeper'),
('IND33', 'Hardik Pandya', '1993-10-11', 'India', 'Right-Hand', 'Right-arm Fast-Medium', 'AllRounder'),
('IND08', 'Ravindra Jadeja', '1988-12-06', 'India', 'Left-Hand', 'Left-arm Orthodox', 'AllRounder'),
('IND20', 'Axar Patel', '1994-01-20', 'India', 'Left-Hand', 'Left-arm Orthodox', 'AllRounder'),
('IND93', 'Jasprit Bumrah', '1993-12-06', 'India', 'Right-Hand', 'Right-arm Fast', 'Bowler'),
('IND73', 'Mohammed Siraj', '1994-03-13', 'India', 'Right-Hand', 'Right-arm Fast', 'Bowler'),
('IND02', 'Arshdeep Singh', '1999-02-05', 'India', 'Left-Hand', 'Left-arm Fast-Medium', 'Bowler'),
('AUS05', 'Aaron Finch', '1986-11-17', 'Australia', 'Right-Hand', 'Left-arm Orthodox', 'Batsman'),
('AUS31', 'David Warner', '1986-10-27', 'Australia', 'Left-Hand', 'Right-arm Legbreak', 'Batsman'),
('AUS49', 'Steve Smith', '1989-06-02', 'Australia', 'Right-Hand', 'Right-arm Legbreak', 'Batsman'),
('AUS08', 'Mitchell Marsh', '1991-10-20', 'Australia', 'Right-Hand', 'Right-arm Medium-Fast', 'AllRounder'),
('AUS32', 'Glenn Maxwell', '1988-10-14', 'Australia', 'Right-Hand', 'Right-arm Offbreak', 'AllRounder'),
('AUS13', 'Matthew Wade', '1987-12-26', 'Australia', 'Left-Hand', 'None', 'WicketKeeper'),
('AUS17', 'Marcus Stoinis', '1989-08-16', 'Australia', 'Right-Hand', 'Right-arm Medium-Fast', 'AllRounder'),
('AUS30', 'Pat Cummins', '1993-05-08', 'Australia', 'Right-Hand', 'Right-arm Fast', 'Bowler'),
('AUS56', 'Mitchell Starc', '1990-01-30', 'Australia', 'Left-Hand', 'Left-arm Fast', 'Bowler'),
('AUS38', 'Josh Hazlewood', '1991-01-08', 'Australia', 'Right-Hand', 'Right-arm Fast-Medium', 'Bowler'),
('AUS88', 'Adam Zampa', '1992-03-31', 'Australia', 'Right-Hand', 'Right-arm Legbreak', 'Bowler');

INSERT INTO Squad (teamName, playerID) VALUES
('Pakistan Cricket Team', 'PAK56'),('Pakistan Cricket Team', 'PAK16'),('Pakistan Cricket Team', 'PAK39'),('Pakistan Cricket Team', 'PAK29'),('Pakistan Cricket Team', 'PAK51'),('Pakistan Cricket Team', 'PAK07'),('Pakistan Cricket Team', 'PAK09'),('Pakistan Cricket Team', 'PAK10'),('Pakistan Cricket Team', 'PAK71'),('Pakistan Cricket Team', 'PAK97'),('Pakistan Cricket Team', 'PAK05'),
('Indian Cricket Team', 'IND45'),('Indian Cricket Team', 'IND18'),('Indian Cricket Team', 'IND64'),('Indian Cricket Team', 'IND63'),('Indian Cricket Team', 'IND17'),('Indian Cricket Team', 'IND33'),('Indian Cricket Team', 'IND08'),('Indian Cricket Team', 'IND20'),('Indian Cricket Team', 'IND93'),('Indian Cricket Team', 'IND73'),('Indian Cricket Team', 'IND02'),
('Australian Cricket Team', 'AUS05'),('Australian Cricket Team', 'AUS31'),('Australian Cricket Team', 'AUS49'),('Australian Cricket Team', 'AUS08'),('Australian Cricket Team', 'AUS32'),('Australian Cricket Team', 'AUS13'),('Australian Cricket Team', 'AUS17'),('Australian Cricket Team', 'AUS30'),('Australian Cricket Team', 'AUS56'),('Australian Cricket Team', 'AUS38'),('Australian Cricket Team', 'AUS88');

INSERT INTO Venue (venueID, venueName, venueCity, venueCountry, venueCapacity) VALUES
(101, 'Gaddafi Stadium', 'Lahore', 'Pakistan', 27000),
(102, 'National Stadium', 'Karachi', 'Pakistan', 34000);

INSERT INTO Umpire (umpireID, umpireName, umpireNationality, umpireExperienceMatches) VALUES
(501, 'Aleem Dar', 'Pakistan', 435),
(502, 'Richard Illingworth', 'England', 250),
(503, 'Nitin Menon', 'India', 160);

INSERT INTO Matches (matchID, tournamentName, matchFormat, matchType, isDayNight, team1Name, team2Name, venueID, matchDate, winnerName, tossWinnerName, winMargin, onFieldUmpire1ID, onFieldUmpire2ID, thirdUmpireID, team1TotalRuns, team1TotalWickets, team2TotalRuns, team2TotalWickets) 
VALUES (2001, 'ICC Champions Trophy', 'T10', 'League', 1, 'Pakistan Cricket Team', 'Indian Cricket Team', 101, '2026-03-01', 'Pakistan Cricket Team', 'Pakistan Cricket Team', 'Won by 5 wickets', 501, 502, 503, 0, 0, 0, 0);

INSERT INTO PlayingXI (matchID, playerID, matchRole) VALUES
(2001, 'PAK56', 'Captain'),(2001, 'PAK16', 'WicketKeeper'),(2001, 'PAK39', 'Player'),(2001, 'PAK29', 'Player'),(2001, 'PAK51', 'Player'),(2001, 'PAK07', 'Player'),(2001, 'PAK09', 'Player'),(2001, 'PAK10', 'Player'),(2001, 'PAK71', 'Player'),(2001, 'PAK97', 'Player'),(2001, 'PAK05', 'Player'),
(2001, 'IND45', 'Captain'),(2001, 'IND17', 'WicketKeeper'),(2001, 'IND18', 'Player'),(2001, 'IND64', 'Player'),(2001, 'IND63', 'Player'),(2001, 'IND33', 'Player'),(2001, 'IND08', 'Player'),(2001, 'IND20', 'Player'),(2001, 'IND93', 'Player'),(2001, 'IND73', 'Player'),(2001, 'IND02', 'Player');

CREATE VIEW teamRankings AS
SELECT teamName, country, teamCaptain, ranking
FROM Team;
GO


CREATE TRIGGER updateScoreCard
ON BallByBall AFTER INSERT AS
BEGIN
    
    UPDATE m SET 
        team1TotalRuns = team1TotalRuns + i.Runs, 
        team1TotalWickets = team1TotalWickets + i.Wickets
    FROM Matches m
    JOIN (SELECT matchID, SUM(runsScored + ISNULL(extras, 0)) AS Runs, SUM(CAST(wicketFallen AS INT)) AS Wickets 
          FROM inserted WHERE inningsNumber = 1 GROUP BY matchID) i ON m.matchID = i.matchID;

    UPDATE m SET 
        team2TotalRuns = team2TotalRuns + i.Runs, 
        team2TotalWickets = team2TotalWickets + i.Wickets
    FROM Matches m
    JOIN (SELECT matchID, SUM(runsScored + ISNULL(extras, 0)) AS Runs, SUM(CAST(wicketFallen AS INT)) AS Wickets 
          FROM inserted WHERE inningsNumber = 2 GROUP BY matchID) i ON m.matchID = i.matchID;
END;
GO




INSERT INTO BallByBall (matchID, inningsNumber, overNumber, ballNumber, batsmanID, bowlerID, runsScored, extras, extraType, wicketFallen, dismissedPlayerID, wicketType) VALUES
(2001, 1, 0, 1, 'IND45', 'PAK05', 0, 0, 'None', 0, NULL, NULL),
(2001, 1, 0, 2, 'IND45', 'PAK05', 4, 0, 'None', 0, NULL, NULL),
(2001, 1, 0, 3, 'IND45', 'PAK05', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 0, 4, 'IND18', 'PAK05', 0, 0, 'None', 0, NULL, NULL),
(2001, 1, 0, 5, 'IND18', 'PAK05', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 0, 6, 'IND45', 'PAK05', 0, 0, 'None', 0, NULL, NULL),
(2001, 1, 1, 1, 'IND18', 'PAK10', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 1, 2, 'IND45', 'PAK10', 6, 0, 'None', 0, NULL, NULL),
(2001, 1, 1, 3, 'IND45', 'PAK10', 0, 0, 'None', 0, NULL, NULL),
(2001, 1, 1, 4, 'IND45', 'PAK10', 4, 0, 'None', 0, NULL, NULL),
(2001, 1, 1, 5, 'IND45', 'PAK10', 0, 1, 'Wide', 0, NULL, NULL),
(2001, 1, 1, 5, 'IND45', 'PAK10', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 1, 6, 'IND18', 'PAK10', 0, 0, 'None', 1, 'IND18', 'Caught'),
(2001, 1, 2, 1, 'IND45', 'PAK05', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 2, 2, 'IND64', 'PAK05', 0, 0, 'None', 0, NULL, NULL),
(2001, 1, 2, 3, 'IND64', 'PAK05', 4, 0, 'None', 0, NULL, NULL),
(2001, 1, 2, 4, 'IND64', 'PAK05', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 2, 5, 'IND45', 'PAK05', 6, 0, 'None', 0, NULL, NULL),
(2001, 1, 2, 6, 'IND45', 'PAK05', 0, 0, 'None', 1, 'IND45', 'Bowled'),
(2001, 1, 3, 1, 'IND64', 'PAK10', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 3, 2, 'IND63', 'PAK10', 4, 0, 'None', 0, NULL, NULL),
(2001, 1, 3, 3, 'IND63', 'PAK10', 2, 0, 'None', 0, NULL, NULL),
(2001, 1, 3, 4, 'IND63', 'PAK10', 0, 0, 'None', 0, NULL, NULL),
(2001, 1, 3, 5, 'IND63', 'PAK10', 6, 0, 'None', 0, NULL, NULL),
(2001, 1, 3, 6, 'IND63', 'PAK10', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 4, 1, 'IND63', 'PAK71', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 4, 2, 'IND64', 'PAK71', 0, 0, 'None', 0, NULL, NULL),
(2001, 1, 4, 3, 'IND64', 'PAK71', 4, 0, 'None', 0, NULL, NULL),
(2001, 1, 4, 4, 'IND64', 'PAK71', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 4, 5, 'IND63', 'PAK71', 2, 0, 'None', 0, NULL, NULL),
(2001, 1, 4, 6, 'IND63', 'PAK71', 0, 0, 'None', 1, 'IND63', 'Lbw'),
(2001, 1, 5, 1, 'IND64', 'PAK97', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 5, 2, 'IND17', 'PAK97', 2, 0, 'None', 0, NULL, NULL),
(2001, 1, 5, 3, 'IND17', 'PAK97', 4, 0, 'None', 0, NULL, NULL),
(2001, 1, 5, 4, 'IND17', 'PAK97', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 5, 5, 'IND64', 'PAK97', 0, 0, 'None', 0, NULL, NULL),
(2001, 1, 5, 6, 'IND64', 'PAK97', 6, 0, 'None', 0, NULL, NULL),
(2001, 1, 6, 1, 'IND17', 'PAK07', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 6, 2, 'IND64', 'PAK07', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 6, 3, 'IND17', 'PAK07', 0, 0, 'None', 0, NULL, NULL),
(2001, 1, 6, 4, 'IND17', 'PAK07', 4, 0, 'None', 0, NULL, NULL),
(2001, 1, 6, 5, 'IND17', 'PAK07', 2, 0, 'None', 0, NULL, NULL),
(2001, 1, 6, 6, 'IND17', 'PAK07', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 7, 1, 'IND17', 'PAK71', 6, 0, 'None', 0, NULL, NULL),
(2001, 1, 7, 2, 'IND17', 'PAK71', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 7, 3, 'IND64', 'PAK71', 4, 0, 'None', 0, NULL, NULL),
(2001, 1, 7, 4, 'IND64', 'PAK71', 0, 0, 'None', 1, 'IND64', 'Caught'),
(2001, 1, 7, 5, 'IND33', 'PAK71', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 7, 6, 'IND17', 'PAK71', 2, 0, 'None', 0, NULL, NULL),
(2001, 1, 8, 1, 'IND33', 'PAK07', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 8, 2, 'IND17', 'PAK07', 4, 0, 'None', 0, NULL, NULL),
(2001, 1, 8, 3, 'IND17', 'PAK07', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 8, 4, 'IND33', 'PAK07', 0, 0, 'None', 0, NULL, NULL),
(2001, 1, 8, 5, 'IND33', 'PAK07', 6, 0, 'None', 0, NULL, NULL),
(2001, 1, 8, 6, 'IND33', 'PAK07', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 9, 1, 'IND33', 'PAK97', 2, 0, 'None', 0, NULL, NULL),
(2001, 1, 9, 2, 'IND33', 'PAK97', 4, 0, 'None', 0, NULL, NULL),
(2001, 1, 9, 3, 'IND33', 'PAK97', 0, 0, 'None', 1, 'IND33', 'Bowled'),
(2001, 1, 9, 4, 'IND08', 'PAK97', 1, 0, 'None', 0, NULL, NULL),
(2001, 1, 9, 5, 'IND17', 'PAK97', 6, 0, 'None', 0, NULL, NULL),
(2001, 1, 9, 6, 'IND17', 'PAK97', 2, 0, 'None', 0, NULL, NULL);

INSERT INTO BallByBall (matchID, inningsNumber, overNumber, ballNumber, batsmanID, bowlerID, runsScored, extras, extraType, wicketFallen, dismissedPlayerID, wicketType) VALUES
(2001, 2, 0, 1, 'PAK56', 'IND93', 4, 0, 'None', 0, NULL, NULL),
(2001, 2, 0, 2, 'PAK56', 'IND93', 0, 0, 'None', 0, NULL, NULL),
(2001, 2, 0, 3, 'PAK56', 'IND93', 6, 0, 'None', 0, NULL, NULL),
(2001, 2, 0, 4, 'PAK56', 'IND93', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 0, 5, 'PAK16', 'IND93', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 0, 6, 'PAK56', 'IND93', 4, 0, 'None', 0, NULL, NULL),
(2001, 2, 1, 1, 'PAK16', 'IND73', 0, 0, 'None', 0, NULL, NULL),
(2001, 2, 1, 2, 'PAK16', 'IND73', 4, 0, 'None', 0, NULL, NULL),
(2001, 2, 1, 3, 'PAK16', 'IND73', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 1, 4, 'PAK56', 'IND73', 6, 0, 'None', 0, NULL, NULL),
(2001, 2, 1, 5, 'PAK56', 'IND73', 0, 0, 'None', 1, 'PAK56', 'Caught'),
(2001, 2, 1, 6, 'PAK39', 'IND73', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 2, 1, 'PAK39', 'IND02', 4, 0, 'None', 0, NULL, NULL),
(2001, 2, 2, 2, 'PAK39', 'IND02', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 2, 3, 'PAK16', 'IND02', 6, 0, 'None', 0, NULL, NULL),
(2001, 2, 2, 4, 'PAK16', 'IND02', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 2, 5, 'PAK39', 'IND02', 0, 0, 'None', 0, NULL, NULL),
(2001, 2, 2, 6, 'PAK39', 'IND02', 4, 0, 'None', 0, NULL, NULL),
(2001, 2, 3, 1, 'PAK16', 'IND93', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 3, 2, 'PAK39', 'IND93', 0, 0, 'None', 1, 'PAK39', 'Bowled'),
(2001, 2, 3, 3, 'PAK29', 'IND93', 4, 0, 'None', 0, NULL, NULL),
(2001, 2, 3, 4, 'PAK29', 'IND93', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 3, 5, 'PAK16', 'IND93', 2, 0, 'None', 0, NULL, NULL),
(2001, 2, 3, 6, 'PAK16', 'IND93', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 4, 1, 'PAK16', 'IND33', 6, 0, 'None', 0, NULL, NULL),
(2001, 2, 4, 2, 'PAK16', 'IND33', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 4, 3, 'PAK29', 'IND33', 0, 0, 'None', 0, NULL, NULL),
(2001, 2, 4, 4, 'PAK29', 'IND33', 4, 0, 'None', 0, NULL, NULL),
(2001, 2, 4, 5, 'PAK29', 'IND33', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 4, 6, 'PAK16', 'IND33', 0, 1, 'Wide', 0, NULL, NULL),
(2001, 2, 4, 6, 'PAK16', 'IND33', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 5, 1, 'PAK16', 'IND20', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 5, 2, 'PAK29', 'IND20', 6, 0, 'None', 0, NULL, NULL),
(2001, 2, 5, 3, 'PAK29', 'IND20', 0, 0, 'None', 1, 'PAK29', 'Stumped'),
(2001, 2, 5, 4, 'PAK51', 'IND20', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 5, 5, 'PAK16', 'IND20', 4, 0, 'None', 0, NULL, NULL),
(2001, 2, 5, 6, 'PAK16', 'IND20', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 6, 1, 'PAK16', 'IND08', 2, 0, 'None', 0, NULL, NULL),
(2001, 2, 6, 2, 'PAK16', 'IND08', 4, 0, 'None', 0, NULL, NULL),
(2001, 2, 6, 3, 'PAK16', 'IND08', 0, 0, 'None', 1, 'PAK16', 'Caught'),
(2001, 2, 6, 4, 'PAK07', 'IND08', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 6, 5, 'PAK51', 'IND08', 4, 0, 'None', 0, NULL, NULL),
(2001, 2, 6, 6, 'PAK51', 'IND08', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 7, 1, 'PAK51', 'IND73', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 7, 2, 'PAK07', 'IND73', 0, 0, 'None', 0, NULL, NULL),
(2001, 2, 7, 3, 'PAK07', 'IND73', 4, 0, 'None', 0, NULL, NULL),
(2001, 2, 7, 4, 'PAK07', 'IND73', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 7, 5, 'PAK51', 'IND73', 6, 0, 'None', 0, NULL, NULL),
(2001, 2, 7, 6, 'PAK51', 'IND73', 0, 0, 'None', 1, 'PAK51', 'Caught'),
(2001, 2, 8, 1, 'PAK07', 'IND02', 2, 0, 'None', 0, NULL, NULL),
(2001, 2, 8, 2, 'PAK07', 'IND02', 4, 0, 'None', 0, NULL, NULL),
(2001, 2, 8, 3, 'PAK07', 'IND02', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 8, 4, 'PAK09', 'IND02', 4, 0, 'None', 0, NULL, NULL),
(2001, 2, 8, 5, 'PAK09', 'IND02', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 8, 6, 'PAK07', 'IND02', 2, 0, 'None', 0, NULL, NULL),
(2001, 2, 9, 1, 'PAK09', 'IND33', 1, 0, 'None', 0, NULL, NULL),
(2001, 2, 9, 2, 'PAK07', 'IND33', 4, 0, 'None', 0, NULL, NULL);


INSERT INTO Matches (matchID, tournamentName, matchFormat, matchType, isDayNight, team1Name, team2Name, venueID, matchDate, winnerName, tossWinnerName, winMargin, onFieldUmpire1ID, onFieldUmpire2ID, thirdUmpireID, team1TotalRuns, team1TotalWickets, team2TotalRuns, team2TotalWickets) 
VALUES (2002, 'ICC Champions Trophy', 'T10', 'League', 0, 'Australian Cricket Team', 'Pakistan Cricket Team', 102, '2026-03-04', NULL, 'Australian Cricket Team', NULL, 502, 503, 501, 0, 0, 0, 0);

INSERT INTO PlayingXI (matchID, playerID, matchRole) VALUES
(2002, 'AUS05', 'Captain'),(2002, 'AUS31', 'Player'),(2002, 'AUS49', 'Player'),(2002, 'AUS08', 'Player'),(2002, 'AUS32', 'Player'),(2002, 'AUS13', 'WicketKeeper'),(2002, 'AUS17', 'Player'),(2002, 'AUS30', 'Player'),(2002, 'AUS56', 'Player'),(2002, 'AUS38', 'Player'),(2002, 'AUS88', 'Player'),
(2002, 'PAK56', 'Captain'),(2002, 'PAK16', 'WicketKeeper'),(2002, 'PAK39', 'Player'),(2002, 'PAK29', 'Player'),(2002, 'PAK51', 'Player'),(2002, 'PAK07', 'Player'),(2002, 'PAK09', 'Player'),(2002, 'PAK10', 'Player'),(2002, 'PAK71', 'Player'),(2002, 'PAK97', 'Player'),(2002, 'PAK05', 'Player');


INSERT INTO BallByBall (matchID, inningsNumber, overNumber, ballNumber, batsmanID, bowlerID, runsScored, extras, extraType, wicketFallen, dismissedPlayerID, wicketType) VALUES

(2002, 1, 0, 1, 'AUS05', 'PAK10', 4, 0, 'None', 0, NULL, NULL),
(2002, 1, 0, 2, 'AUS05', 'PAK10', 1, 0, 'None', 0, NULL, NULL),
(2002, 1, 0, 3, 'AUS31', 'PAK10', 0, 0, 'None', 1, 'AUS31', 'Bowled'),
(2002, 1, 0, 4, 'AUS49', 'PAK10', 1, 0, 'None', 0, NULL, NULL),
(2002, 1, 0, 5, 'AUS05', 'PAK10', 4, 0, 'None', 0, NULL, NULL),
(2002, 1, 0, 6, 'AUS05', 'PAK10', 1, 0, 'None', 0, NULL, NULL),

(2002, 1, 1, 1, 'AUS49', 'PAK05', 6, 0, 'None', 0, NULL, NULL),
(2002, 1, 2, 1, 'AUS05', 'PAK71', 4, 0, 'None', 0, NULL, NULL),
(2002, 1, 3, 1, 'AUS49', 'PAK97', 1, 0, 'None', 0, NULL, NULL),
(2002, 1, 4, 1, 'AUS05', 'PAK07', 2, 0, 'None', 0, NULL, NULL),
(2002, 1, 5, 1, 'AUS49', 'PAK09', 4, 0, 'None', 0, NULL, NULL),
(2002, 1, 6, 1, 'AUS05', 'PAK71', 1, 0, 'None', 0, NULL, NULL),
(2002, 1, 7, 1, 'AUS08', 'PAK97', 6, 0, 'None', 0, NULL, NULL),
(2002, 1, 8, 1, 'AUS32', 'PAK07', 4, 0, 'None', 0, NULL, NULL),

(2002, 1, 9, 1, 'AUS32', 'PAK10', 2, 0, 'None', 0, NULL, NULL),
(2002, 1, 9, 2, 'AUS32', 'PAK10', 4, 0, 'None', 0, NULL, NULL),
(2002, 1, 9, 3, 'AUS32', 'PAK10', 0, 0, 'None', 1, 'AUS32', 'Caught'),
(2002, 1, 9, 4, 'AUS13', 'PAK10', 1, 0, 'None', 0, NULL, NULL),
(2002, 1, 9, 5, 'AUS08', 'PAK10', 6, 0, 'None', 0, NULL, NULL),
(2002, 1, 9, 6, 'AUS08', 'PAK10', 1, 0, 'None', 0, NULL, NULL);


INSERT INTO BallByBall (matchID, inningsNumber, overNumber, ballNumber, batsmanID, bowlerID, runsScored, extras, extraType, wicketFallen, dismissedPlayerID, wicketType) VALUES

(2002, 2, 0, 1, 'PAK56', 'AUS56', 4, 0, 'None', 0, NULL, NULL),
(2002, 2, 0, 2, 'PAK56', 'AUS56', 0, 0, 'None', 0, NULL, NULL),
(2002, 2, 0, 3, 'PAK56', 'AUS56', 1, 0, 'None', 0, NULL, NULL),
(2002, 2, 0, 4, 'PAK16', 'AUS56', 1, 0, 'None', 0, NULL, NULL),
(2002, 2, 0, 5, 'PAK56', 'AUS56', 0, 0, 'None', 1, 'PAK56', 'Caught'),
(2002, 2, 0, 6, 'PAK39', 'AUS56', 0, 0, 'None', 0, NULL, NULL),

(2002, 2, 1, 1, 'PAK16', 'AUS38', 1, 0, 'None', 0, NULL, NULL),
(2002, 2, 1, 2, 'PAK39', 'AUS38', 4, 0, 'None', 0, NULL, NULL),
(2002, 2, 1, 3, 'PAK39', 'AUS38', 1, 0, 'None', 0, NULL, NULL),
(2002, 2, 1, 4, 'PAK16', 'AUS38', 6, 0, 'None', 0, NULL, NULL),
(2002, 2, 1, 5, 'PAK16', 'AUS38', 0, 0, 'None', 0, NULL, NULL),
(2002, 2, 1, 6, 'PAK16', 'AUS38', 2, 0, 'None', 0, NULL, NULL),

(2002, 2, 2, 1, 'PAK39', 'AUS30', 1, 0, 'None', 0, NULL, NULL),
(2002, 2, 2, 2, 'PAK16', 'AUS30', 4, 0, 'None', 0, NULL, NULL),
(2002, 2, 2, 3, 'PAK16', 'AUS30', 0, 0, 'None', 1, 'PAK16', 'Lbw'),
(2002, 2, 2, 4, 'PAK29', 'AUS30', 1, 0, 'None', 0, NULL, NULL),
(2002, 2, 2, 5, 'PAK39', 'AUS30', 2, 0, 'None', 0, NULL, NULL),
(2002, 2, 2, 6, 'PAK39', 'AUS30', 1, 0, 'None', 0, NULL, NULL),

(2002, 2, 3, 1, 'PAK39', 'AUS88', 1, 0, 'None', 0, NULL, NULL),
(2002, 2, 3, 2, 'PAK29', 'AUS88', 0, 0, 'None', 0, NULL, NULL),
(2002, 2, 3, 3, 'PAK29', 'AUS88', 6, 0, 'None', 0, NULL, NULL),
(2002, 2, 3, 4, 'PAK29', 'AUS88', 1, 0, 'None', 0, NULL, NULL),
(2002, 2, 3, 5, 'PAK39', 'AUS88', 0, 0, 'None', 1, 'PAK39', 'Stumped'),
(2002, 2, 3, 6, 'PAK51', 'AUS88', 1, 0, 'None', 0, NULL, NULL),

(2002, 2, 4, 1, 'PAK51', 'AUS17', 1, 0, 'None', 0, NULL, NULL),
(2002, 2, 4, 2, 'PAK29', 'AUS17', 2, 0, 'None', 0, NULL, NULL),
(2002, 2, 4, 3, 'PAK29', 'AUS17', 4, 0, 'None', 0, NULL, NULL),
(2002, 2, 4, 4, 'PAK29', 'AUS17', 1, 0, 'None', 0, NULL, NULL),
(2002, 2, 4, 5, 'PAK51', 'AUS17', 6, 0, 'None', 0, NULL, NULL),
(2002, 2, 4, 6, 'PAK51', 'AUS17', 1, 0, 'None', 0, NULL, NULL);
GO





CREATE PROCEDURE getPlayingXI
    @TargetMatchID INT,
    @TargetTeamName VARCHAR(60)
AS
BEGIN
    SELECT playerID, playerName, playerRole
    FROM Players
    WHERE playerID IN (
        SELECT playerID FROM PlayingXI WHERE matchID = @TargetMatchID
        AND playerID IN (SELECT playerID FROM Squad WHERE teamName = @TargetTeamName)
    );
END;
GO


CREATE PROCEDURE GetPlayerMatchup
    @BatsmanID VARCHAR(15),
    @BowlerID VARCHAR(15)
AS
BEGIN
    SELECT 
        SUM(runsScored) AS TotalRunsScored,
        COUNT(ballID) AS BallsFaced,
        SUM(CAST(wicketFallen AS INT)) AS TimesDismissed
    FROM BallByBall
    WHERE batsmanID = @BatsmanID AND bowlerID = @BowlerID;
END;
GO

CREATE PROCEDURE getMatchSummary
    @MatchID INT
AS
BEGIN
    SELECT 
        matchID, 
        team1Name, 
        team1TotalRuns, 
        team1TotalWickets, 
        team2Name, 
        team2TotalRuns, 
        team2TotalWickets 
    FROM Matches
    WHERE matchID = @MatchID;
END;
GO

ALTER PROCEDURE getTopScore
    @MatchID INT
AS
BEGIN
    SELECT playerName
    FROM Players
    WHERE playerID IN
    (
        SELECT batsmanID
        FROM BallByBall
        WHERE matchID = @MatchID
        GROUP BY batsmanID
        HAVING SUM(runsScored) > 30 
    );
END;
GO



CREATE PROCEDURE getBatsmanRuns
    @MatchID INT
AS
BEGIN
    SELECT batsmanID, SUM(runsScored) AS TotalRuns
    FROM BallByBall
    WHERE matchID = @MatchID
    GROUP BY batsmanID;
END;
GO



CREATE PROCEDURE getTopScore
    @MatchID INT
AS
BEGIN
    SELECT playerName
    FROM Players
    WHERE playerID IN
    (
        SELECT batsmanID
        FROM BallByBall
        WHERE matchID = @MatchID
        GROUP BY batsmanID
        HAVING SUM(runsScored) > 50
    );
END;
GO

ALTER PROCEDURE getTopScore
    @MatchID INT
AS
BEGIN
    SELECT p.playerName, SUM(b.runsScored) AS TotalRuns
    FROM BallByBall b
    INNER JOIN Players p ON b.batsmanID = p.playerID
    WHERE b.matchID = @MatchID
    GROUP BY p.playerName
    HAVING SUM(b.runsScored) >= 30
    ORDER BY TotalRuns DESC;
END;
GO



SELECT * FROM teamRankings ORDER BY ranking ASC;

EXEC GetPlayingXI @TargetMatchID = 2002, @TargetTeamName = 'Australian Cricket Team';

EXEC GetPlayingXI @TargetMatchID = 2002, @TargetTeamName = 'Pakistan Cricket Team';

EXEC getMatchSummary @MatchID = 2001;

EXEC getBatsmanRuns @MatchID = 2001;

EXEC getTopScore @MatchID = 2001;

EXEC GetPlayerMatchup @BatsmanID = 'PAK56', @BowlerID = 'AUS56';




