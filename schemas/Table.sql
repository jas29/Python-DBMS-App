drop table Activist_Organization;
create table Activist_Organization(
	Name char(7),
	ID real primary key,
	Address char(28),
	Rent real
);

insert into Activist_Organization values('GNG',1011,'3800 Finerty Road',7000);
insert into Activist_Organization values('ONC',1012,'1011 Richmond Road',5000);
insert into Activist_Organization values('BWC',1013,'4455 Quadra Street',9000);
insert into Activist_Organization values('ELW',1014,'7127 Blanshard Street',10000);
insert into Activist_Organization values('HSD',1015,'9125 Shelbourne Street',8000);
insert into Activist_Organization values('DTB',1016,'2525 Mckenzie Avenue',5000);



drop table Campaigns;
create table Campaigns(
	Camp_Name char(24),
	Campaign_ID real primary key,
	Funds_Raised real,
	Cost real,
	Issue char(25),
	Duartion char(20),
	Org_ID real,
	foreign key(Org_ID) references Activist_Organization(ID)
	on delete cascade
    on update cascade
);

insert into Campaigns values('Trees for Cities',101,20000,10000,'Saving trees for cities','2 Weeks',1011);
insert into Campaigns values('No Farms No Food',102,15000,5000,'Protecting Farmers','1 Month',1013);
insert into Campaigns values('Beat Pollution',103,20000,10000,'Increasing Pollutants','2 Weeks',1011);
insert into Campaigns values('Clean Seas',104,7000,2000,'Dangered Marine Life','5 Weeks',1012);
insert into Campaigns values('Leave Lead',105,20000,10000,'Use of lead paint','2 Weeks',1015);
insert into Campaigns values('Ice Bridge',106,25000,9000,'Melting of Glaciers','3 Weeks',1011);
insert into Campaigns values('Fossil Free',107,20000,10000,'Use fossil fuels','2 Weeks',1015);
insert into Campaigns values('Feel The Heat',108,15000,2000,'Rising Temperatures','3 Weeks',1016);
insert into Campaigns values('Charity Water',109,20000,10000,'Polluted Water','2 Weeks',1012);
insert into Campaigns values('Suffer against Sewage',110,8000,2000,'Bad Sewage System','5 Weeks',1014);

drop table Events;
create table Events(
	Event_Name char(20),
	Event_ID real primary key,
	Start_Date date,
	End_Date date,
	Org_ID real,
	Camp_ID real,
	foreign key(Camp_ID) references Campaigns(Campaign_ID)
	on delete cascade
	on update cascade,
	foreign key(Org_ID) references Activist_Organization(ID)
	on delete cascade
	on update cascade
);

insert into Events values('TreeCon',00011,'2019-09-15','2019-09-30',1011,101);
insert into Events values('Find the tree',00012,'2019-07-01','2019-09-25',1011,101);
insert into Events values('Plant one',00013,'2019-05-06','2019-07-08',1011,101);
insert into Events values('Stop Pol',00014,'2019-10-15','2019-10-30',1011,103);
insert into Events values('Freeze fisrt',00015,'2019-12-25','2020-01-30',1011,106);
insert into Events values('Stop melt',00016,'2019-04-02','2019-07-20',1011,106);
insert into Events values('Red noise',00017,'2019-01-15','2019-03-17',1011,103);
insert into Events values('Water Clean',00018,'2019-04-20','2019-07-18',1011,103);

drop table Donor;
create table Donor(
	FirstName char(20),
	LastName char(20),
	AmountDonated real,
	Camp_ID real,
	primary key(FirstName,LastName),
	foreign key(Camp_ID) references Campaigns(Campaign_ID)
	on delete cascade
	on update cascade
);

insert into Donor values('Lodu','Chand',10000,101);
insert into Donor values('Jackie','Chan',25000,103);
insert into Donor values('Leo','Caprio',7000,106);
insert into Donor values('Juan','Mata',2000,101);
insert into Donor values('Andres','Iniesta',50000,106);
insert into Donor values('Romelu','Lukaku',30000,103);

drop table Employees;
create table Employees(
	Employee_ID real primary key,
	First_Name char(20),
	Last_Name char(20),
	Salary real,
	Org_ID real,
	Camp_ID real,
	foreign key(Org_ID) references Activist_Organization(ID)
	on delete cascade
	on update cascade,
	foreign key(Camp_ID) references Campaigns(Campaign_ID)
	on delete cascade
	on update cascade
);

insert into Employees values(10115,'Olly','Marshall',25000,1011,103);
insert into Employees values(20115,'John','Snow',37000,1014,110);
insert into Employees values(30115,'Rob','Anderson',29000,1016,108);
insert into Employees values(40115,'Josh','Morrid',42000,1011,101);
insert into Employees values(50115,'Harry','Kane',15000,1012,104);
insert into Employees values(60115,'Lionel','Messi',27000,1015,105);
insert into Employees values(70115,'Cristiano','Ronaldo',49000,1013,102);
insert into Employees values(80115,'Sadio','Mane',37000,1011,106);


drop table Members;
create table Members(
	Member_First_Name char(20),
	Member_Last_Name char(20),
	Member_Id real primary key,
	Org_ID real,
	Camp_ID real,
	foreign key(Org_ID) references Activist_Organization(ID)
	on delete cascade
	on update cascade,
	foreign key(Camp_ID) references Campaigns(Campaign_ID)
	on delete cascade
	on update cascade
);

insert into Members values('Eden','Hazard',5712,1011,103);
insert into Members values('Gerard','Pique',5745,1013,102);
insert into Members values('Ivan','Rakitic',5983,1014,110);
insert into Members values('Sergio','Busquets',5376,1016,108);
insert into Members values('Arthur','Melo',5672,1013,102);
insert into Members values('Phillipe','Coutinho',5812,1015,105);
insert into Members values('Luis','Suarez',5552,1011,103);
insert into Members values('Ousmane','Dembele',5385,1012,104);
insert into Members values('Frenkie','Dejong',5988,1016,108);
insert into Members values('Leroy','Sane',5294,1015,105);


drop table Areas;
create table Areas(
	Area_Name char(20),
	Severity char(10), -- Severity here refers to the severity of impact on the area.
	Org_ID real,
	foreign key(Org_ID) references Activist_Organization(ID)
	on delete cascade
	on update cascade,
	primary key (Area_Name,Severity)
);

insert into Areas values('Uplands','High',1011);
insert into Areas values('Oak Bay','Medium',1016);
insert into Areas values('Langford','High',1012);
insert into Areas values('Sooke','Low',1011);
insert into Areas values('Cordova Bay','Medium',1014);
insert into Areas values('Sidney','Low',1013);
insert into Areas values('Saanichton','High',1011);
insert into Areas values('Goldstream','Low',1015);
insert into Areas values('Colwood','High',1012);
insert into Areas values('Duncan','Medium',1014);

drop table Volunteers;
create table Volunteers(
	Tier char(20),
	Mem_ID real primary key,
	foreign key(Mem_ID) references Members(Member_Id)
	on delete cascade
	on update cascade
);

insert into Volunteers values('Tier1',5712);
insert into Volunteers values('Tier1',5745);
insert into Volunteers values('Tier2',5983);
insert into Volunteers values('Tier1',5376);
insert into Volunteers values('Tier2',5672);

drop table Supporters;
create table Supporters(
	Role char(20),
	Mem_ID real primary key,
	foreign key(Mem_ID) references Members(Member_Id)
	on delete cascade
	on update cascade
);

insert into Supporters values('Reporter',5552);
insert into Supporters values('Environmentalist',5385);
insert into Supporters values('Scientist',5988);
insert into Supporters values('Media-Spokesperson',5294);

drop table IsMember;
create table IsMember(
	Mem_ID real,
	Org_ID real,
	primary key(Org_ID,Mem_ID),
	foreign key(Mem_ID) references Members(Member_Id)
	on delete cascade
	on update cascade,
	foreign key(Org_ID) references Activist_Organization(ID)
	on delete cascade
	on update cascade
);

insert into IsMember values(5712,1011);
insert into IsMember values(5745,1013);
insert into IsMember values(5983,1014);
insert into IsMember values(5672,1013);
insert into IsMember values(5988,1016);

drop table WorksIn;
create table WorksIn(
	Emp_ID real,
	Camp_ID real,
	primary key(Camp_ID,Emp_ID),
	foreign key (Camp_ID) references Campaigns(Campaign_ID)
	on delete cascade
	on update cascade,
	foreign key (Emp_ID) references Employees(Employee_ID)
	on delete cascade
	on update cascade
);

insert into WorksIn values(10115,103);
insert into WorksIn values(40115,101);
insert into WorksIn values(60115,105);
insert into WorksIn values(10115,110);
insert into WorksIn values(70115,102);
insert into WorksIn values(30115,108);

drop table PartOf;
create table PartOf(
	Mem_ID real,
	Camp_ID real,
	primary key(Camp_ID,Mem_ID),
	foreign key (Camp_ID) references Campaigns(Campaign_ID)
	on delete cascade
	on update cascade,
	foreign key (Mem_ID) references Members(Member_Id)
	on delete cascade
	on update cascade

);

insert into PartOf values(5712,103);
insert into PartOf values(5745,102);
insert into PartOf values(5983,110);
insert into PartOf values(5552,103);
insert into PartOf values(5385,104);
