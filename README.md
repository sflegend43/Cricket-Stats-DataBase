# Cricket-Stats-DataBase
📌 Overview
This repository contains a robust SQL Server database schema (CricketStatsDB) designed to manage and query detailed cricket match data. It goes beyond basic team statistics by logging granular, ball-by-ball progression, automatically updating match scorecards, and providing pre-built analytical procedures.

⚙️ Key Features
Comprehensive Schema: Structured tables for Players, Teams, Venues, Umpires, Matches, and Squads.

Ball-by-Ball Tracking: A highly detailed transactional table that records individual deliveries, including runs, extras (wides/no-balls), and specific wicket types.

Automated Scorecard Triggers: Includes an updateScoreCard trigger that automatically calculates and updates a team's total runs and wickets in the Matches table whenever new ball-by-ball data is inserted.

Analytical Stored Procedures: Pre-written procedures to instantly fetch:

Match summaries (getMatchSummary).

Specific team lineups for a match (getPlayingXI).

Head-to-head player matchups, such as a specific batsman's record against a specific bowler (GetPlayerMatchup).

Top scorers for a specific match (getTopScore).

Live Rankings View: A dedicated teamRankings view to quickly query the current global standings of international teams.

🗄️ Database Structure
The database is built on the following primary tables:

Players: Stores demographic data, batting/bowling styles, and specific roles (Batsman, Bowler, AllRounder, WicketKeeper).

Team & Squad: Manages national teams, coaches, captains, and overall 15-man rosters.

Matches & PlayingXI: Logs tournament info (Format, Type, Day/Night), venues, umpires, and the specific 11 players competing.

BallByBall: The core engine tracking innings, overs, individual balls, batsman/bowler IDs, runs scored, extras, and dismissals.

Venue & Umpire: Reference tables for stadiums and match officials.

🚀 How to Use
Clone this repository to your local machine.

Open final (1).sql in SQL Server Management Studio (SSMS) or your preferred SQL client.

Execute the script. It will automatically:

Create the CricketStatsDB database.

Build the complete relational table schema.

Insert sample data (including T10 tournament match data between Pakistan, India, and Australia).

Create all necessary triggers, views, and stored procedures.

Test the database using the sample EXEC commands provided at the bottom of the script (e.g., EXEC GetPlayerMatchup @BatsmanID = 'PAK56', @BowlerID = 'AUS56';).
