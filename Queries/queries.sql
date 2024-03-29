-- NAME OF ALL THE CAMPAIGNS CONDUCTED BY GNG
CREATE VIEW CAMPAIGNSCONDUCTEDBYGNG AS
SELECT CAMP_NAME,CAMPAIGN_ID,ISSUE FROM CAMPAIGNS
WHERE CAMPAIGNS.ORG_ID = (SELECT ID FROM ACTIVIST_ORGANIZATION 
							WHERE NAME = 'GNG');

-- NAME OF ALL THE ORGANIZATIONS AND CAMPAIGNS WHERE EARNING THROUGH CAMPAIN WAS MORE THAN 5000
CREATE VIEW MORETHAN5K AS
SELECT NAME,CAMP_NAME,(CAMPAIGNS.FUNDS_RAISED - CAMPAIGNS.COST) AS TOTAL FROM CAMPAIGNS
JOIN ACTIVIST_ORGANIZATION ON ACTIVIST_ORGANIZATION.ID = CAMPAIGNS.ORG_ID
WHERE (CAMPAIGNS.FUNDS_RAISED - CAMPAIGNS.COST) > 5000 ORDER BY TOTAL DESC;

--NET EARNINGS OF ALL THE ORGANIZATIONS
CREATE VIEW NETINCOME AS
SELECT NAME,ID,(CAMPAIGNS.FUNDS_RAISED - CAMPAIGNS.COST - ACTIVIST_ORGANIZATION.RENT) AS NETINCOME FROM
ACTIVIST_ORGANIZATION JOIN CAMPAIGNS ON ACTIVIST_ORGANIZATION.ID = CAMPAIGNS.ORG_ID;

-- NAME OF ALL THE EMPLOYEES EMPLOYED BY GNG
CREATE VIEW ALLEMPLOYEESGNG AS
SELECT FIRST_NAME, LAST_NAME,EMPLOYEE_ID FROM EMPLOYEES
WHERE EMPLOYEES.ORG_ID = (SELECT ID FROM ACTIVIST_ORGANIZATION
							WHERE NAME = 'GNG');

--TOTAL NUMBER OF MEMBERS (VOLUNTEERS & SUPPORTERS IN GNG)
CREATE VIEW TOTALMEMBERS AS
SELECT COUNT(MEMBER_FIRST_NAME) FROM MEMBERS
WHERE MEMBERS.ORG_ID = (SELECT ID FROM ACTIVIST_ORGANIZATION
						WHERE NAME = 'GNG');

-- NAME OF ALL THE ORGANIZATIONS WHERE THE SEVERITY OF IMPACT IS 'HIGH'
CREATE VIEW HIGHASTHESKY AS
SELECT NAME,AREA_NAME,ORG_ID FROM ACTIVIST_ORGANIZATION JOIN AREAS
ON ACTIVIST_ORGANIZATION.ID = AREAS.ORG_ID
WHERE AREAS.SEVERITY = 'High';

-- NAME OF ALL THE EMPLOYEES WHO DO NOT WORK FOR GNG
CREATE VIEW NOTINGNG AS
SELECT DISTINCT FIRST_NAME,LAST_NAME,EMPLOYEE_ID FROM EMPLOYEES JOIN CAMPAIGNS
ON EMPLOYEES.ORG_ID = CAMPAIGNS.ORG_ID WHERE CAMPAIGNS.ORG_ID NOT IN (SELECT ID
										FROM ACTIVIST_ORGANIZATION WHERE NAME = 'GNG');

-- NAME OF ALL THE CAMPAIGNS WHERE THE THE SEVERITY IS LOW
CREATE VIEW CAMPLOW AS
SELECT CAMP_NAME,AREA_NAME,SEVERITY FROM CAMPAIGNS JOIN AREAS
ON CAMPAIGNS.ORG_ID = AREAS.ORG_ID
WHERE AREAS.SEVERITY = 'Low';

-- NAME OF ALL THE VOLUNTEERS WHO ARE IN TIER1 AND WORK FOR GNG
CREATE VIEW TIER1VOLUNTEERS AS
SELECT MEMBER_FIRST_NAME,MEMBER_LAST_NAME,MEMBER_ID FROM MEMBERS JOIN VOLUNTEERS
ON MEMBERS.MEMBER_ID = VOLUNTEERS.MEM_ID WHERE MEMBERS.ORG_ID = (SELECT ID FROM ACTIVIST_ORGANIZATION
											WHERE NAME = 'GNG') ;

-- NAME OF MEMBERS WHO ARE NOT A PART OF CAMPAIGNS BY GNG
CREATE VIEW NOTGNGCAMPAIGNS AS
SELECT CAMP_NAME,MEMBER_FIRST_NAME,MEMBER_LAST_NAME FROM CAMPAIGNS JOIN MEMBERS
ON MEMBERS.ORG_ID = CAMPAIGNS.ORG_ID WHERE MEMBERS.ORG_ID NOT IN (SELECT ID FROM ACTIVIST_ORGANIZATION
										WHERE NAME = 'GNG');
