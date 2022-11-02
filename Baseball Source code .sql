--C
CREATE TABLE Coaches( 
CoachID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
first_name TEXT NOT NULL, 
last_name TEXT NOT NULL, 
DOB DATE NOT NULL, 
POB INTEGER NOT NULL
TeamName TEXT,
FOREIGN KEY(TeamName) REFERENCES Teams(Name)
);

CREATE TABLE Managers( 
ManagerID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
first_name TEXT NOT NULL, 
last_name TEXT NOT NULL, 
DOB DATE NOT NULL, 
POB INTEGER NOT NULL
TeamName TEXT,
FOREIGN KEY(TeamName) REFERENCES Teams(Name)
);

CREATE TABLE Players( 
PlayerID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
first_name TEXT NOT NULL, 
last_name TEXT NOT NULL, 
DOB DATE NOT NULL, 
POB INTEGER NOT NULL, 
LifetimeBA INTEGER NOT NULL, 
BattingOrientation TEXT NOT NULL
TeamName TEXT,
FOREIGN KEY(TeamName) REFERENCES Teams(Name)
);

CREATE TABLE Umpires( 
UmpireID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
first_name TEXT NOT NULL, 
last_name TEXT NOT NULL, 
DOB DATE NOT NULL, 
POB INTEGER NOT NULL 
);

CREATE TABLE Teams( 
Name TEXT PRIMARY KEY NOT NULL, 
City TEXT NOT NULL, 
Division TEXT NOT NULL, 
League TEXT NOT NULL, 
)

CREATE TABLE Games( 
GameID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
Date DATE NOT NULL, 
UmpireID INTEGER NOT NULL, 
FOREIGN KEY(UmpireID) REFERENCES Umpires(UmpireID) 
);

CREATE TABLE Pitchers( 
PitcherID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
LifetimeERA INTEGER NOT NULL, 
PlayerID INTEGER NOT NULL, 
FOREIGN KEY(PlayerID) REFERENCES Players(PlayerID) 
);

CREATE TABLE Hit_Track( 
HitID INTEGER PRIMARY KEY NOT NULL, 
PlayerID INTEGER NOT NULL, 
GameID INTEGER NOT NULL,
Singles INTEGER	NOT NULL,
Doubles INTEGER	NOT NULL,
Triples INTEGER	NOT NULL,
Homeruns INTEGER NOT NULL,
FOREIGN KEY(GameID) REFERENCES Games(GameID), 
FOREIGN KEY(PlayerID) REFERENCES Players(PlayerID) 
);

CREATE TABLE Team_Track( 
TrackID INTEGER PRIMARY KEY NOT NULL, 
TeamName TEXT NOT NULL, 
GameID INTEGER NOT NULL, 
HomeOrAway TEXT NOT NULL, 
Run INTEGER, 
Hit INTEGER, 
Error INTEGER, 
WinOrLoseOrSave TEXT NOT NULL, 
PitcherID INTEGER NOT NULL, 
FOREIGN KEY(TeamName) REFERENCES Teams(Name), 
FOREIGN KEY(GameID) REFERENCES Games(GameID), 
FOREIGN KEY(PitcherID) REFERENCES Pitchers(PitcherID) 
);

--D
INSERT INTO Teams(Name,City,Division,League)
VALUES  ("Wolf","New York","Premium","League 1"),
		("Dog","London","Premium","League 2");


INSERT INTO Managers(ManagerID,first_name,last_name,DOB,POB,TeamName)
VALUES  (1,"Ee","Eee","01/01/1990","New York","Wolf"),
		(2,"Ff","Fff","01/01/1991","London","Dog");

INSERT INTO Coaches(CoachID,first_name,last_name,DOB,POB,TeamName)
VALUES  (1,"Aa","Aaa","01/01/1990","New York","Wolf"),
		(2,"Bb","Bbb","01/01/1991","London","Wolf"),
		(3,"Cc","Ccc","01/01/1992","Paris","Dog"),
		(4,"Dd","Ddd","01/01/1993","Beijing","Dog");

INSERT INTO Umpires(UmpireID,first_name,last_name,DOB,POB)
VALUES  (1,"Gg","Ggg","01/01/1990","New York"),
		(2,"Hh","Hhh","01/01/1991","London"),
		(3,"Ii","Ii","01/01/1992","Paris"),
		(4,"Jj","Jj","01/01/1993","Beijing");

INSERT INTO Players(PlayerID,first_name,last_name,DOB,POB,LifetimeBA,BattingOrientation,TeamName)
VALUES  (1,"Kk","Kkk","01/01/1990","New York",0.2,"Left","Wolf"),
		(2,"Ll","Lll","01/01/1991","London",0.25,"Left","Wolf"),
		(3,"Mm","Mmm","01/01/1992","Paris",0.3,"Right","Dog"),
		(4,"Nn","Nnn","01/01/1993","Beijing",0.32,"Switch","Wolf"),
		(5,"Oo","Ooo","01/01/1994","Shanghai",0.35,"Right","Dog");
		
INSERT INTO Games(GameID,Date,UmpireID)
VALUES  (1,"01/01/1990",1),
		(2,"01/01/1990",2);
		
INSERT INTO Hit_Track(HitID,PlayerID,GameID,Singles,Doubles,Triples,Homeruns)
VALUES  (1,3,1,8,4,1,1),
		(2,4,2,6,1,0,0),
		(3,1,1,10,5,3,1);
		
INSERT INTO Team_Track(TrackID,TeamName,GameID,HomeOrAway,Run,Hit,Error,WinOrLoseOrSave,PitcherID)
VALUES (1,"Wolf",1,"Home",10,20,5,"Win",1),
	   (2,"Dog",1,"Away",8,15,6,"Lose",2);

--E	   
SELECT 
	T.Name as TeamName,
	M.first_name || " "|| M.last_name as ManagerName,
	C.first_name || " "|| C.last_name as CoachName,
	P.first_name || " "|| P.last_name as PlayerName
FROM
	Teams T,Managers M,Coaches C, Players P
ORDER BY T.name ASC

--F
SELECT 
	HT.GameID,
	sum(HT.Singles+HT.Doubles+HT.Triples+HT.Homeruns) as TotalHits
FROM Hit_Track HT 
GROUP BY HT.GameID
ORDER BY TotalHits DESC;

-- G
SELECT
	P.first_name || " "|| P.last_name as PlayerName,
	P.LifetimeBA,
	PI.LifetimeERA
FROM Players P
LEFT JOIN Pitchers PI ON P.PlayerID=PI.PlayerID
WHERE P.PlayerID IN(
SELECT
	PlayerID
FROM Hit_Track HT
ORDER BY (HT.Singles+HT.Doubles+HT.Triples+HT.Homeruns) DESC
LIMIT 1)

--H
SELECT
	T.name,
	T.City
FROM Teams T
LEFT JOIN Team_Track TT ON T.name=TT.TeamName
WHERE TT.WinOrLoseOrSave="Win"
GROUP BY T.name