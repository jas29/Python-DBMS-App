#!/usr/bin/env python3
import os
import sys
import psycopg2

# Globally declared cursors
dbconn = psycopg2.connect(host='studsql.csc.uvic.ca',
                          cursor = dbconn.cursor()

def selectviews():
	print("Phase 1: \n"
	"Enter the index for the query \n"
	"1 - Campaigns Conducted by gng \n"
	"2 - Campaigns where earning was more than 5000 \n"
	"3 - Net earning of all the organizations \n"
	"4 - employees in GNG \n"
	"5 - Total number of Volunteers (Members+Supporters) in GNG \n"
	"6 - Organizations where the severity of impact is high \n"
	"7 - Employees who do not work for GNG \n"
	"8 - Campaigns where the severity of impact is low \n"
	"9 - Names of all the Tier1 GNG Employees \n"
	"10 - Members who are not a part of Campaigns by GNG \n")

	# Exception Handling only accepts integers between 1 and 10
	start = 1
	end = 10
	while True:
		try:
			user_input = input("Enter the query index:")
			user_input = int(user_input)
			if start <= user_input <=end:
				break
		except ValueError:
			print("You did not enter a valid index!! Please try again")

	Views = ['CAMPAIGNSCONDUCTEDBYGNG','MORETHAN5K','NETINCOME','ALLEMPLOYEESGNG','TOTALMEMBERS',
	'HIGHASTHESKY','NOTINGNG','CAMPLOW','TIER1VOLUNTEERS','NOTGNGCAMPAIGNS']
	name_view =  Views[(user_input)-1]
	cursor.execute(""" select * from %s """ %(name_view))
	for row in cursor.fetchall():
		print("%s %s %s" % (row[0],row[1],row[2]))
	print("\n")



def View_Campaign():
	print("Viewing Campaign")
	cursor.execute(""" select * from Campaigns """)
	for row in cursor.fetchall():
		print("%s %s %s %s %s %s %s" % (row[0],row[1],row[2],row[3],row[4],row[5],row[6]))
	print("\n")
	Campaign_Management()

def Add_Campaign():
	print("Add a campaign")
	# Used dictionary to store the credentials of a Campaign
	# Used type casting for integers and strings where needed
	Campaign = {
	'Name' : str(input("Enter name of the campaign:")),
	'ID' : int(input("Enter Campaign ID:")),
	'FundsRaised': int(input("Enter amount of funds raised:")),
	'Cost': int(input("Enter the cost of the campaign:")),
	'Issue': str(input("What is the issue of the campaign:")),
	'Duration': str(input("Enter the duration of the campaign:")),
	'OrgId': int(input("Enter the ID of the organization conducting the campaign:"))
	}
	cursor.execute(""" insert into Campaigns values (%(Name)s,%(ID)s,%(FundsRaised)s,%(Cost)s,%(Issue)s,%(Duration)s,%(OrgId)s); """,Campaign)
	print("---- Inserted into Campaigns ----")
	print("\n")
	View_Campaign()
	print("\n")
	Campaign_Management()

def Add_Volunteer():
	# According to my relational schema, volunteers are considered as members
	print("Add volunteer")
	Volunteer = {
	'FirstName': str(input("Enter the first name of the volunteer:")),
	'LastName': str(input("Enter the last name of the volunteer:")),
	'MemberID': int(input("Enter the member ID of the volunteer:")),
	'OrgID': int(input("Enter the ID of the organization, the volunteer works for:")),
	'CampID': int(input("Enter the ID of the Campaign, the volunteer works in:"))
	}
	cursor.execute(""" insert into Members values (%(FirstName)s,%(LastName)s,%(MemberID)s,%(OrgID)s,%(CampID)s);""",Volunteer)
	print("---- Inserted into Members ----")
	print("\n")
	cursor.execute(""" select Member_First_Name, Member_Last_Name,Campaigns.Camp_Name from Members join Campaigns on Members.Camp_ID = Campaigns.Campaign_ID """)
	for row in cursor.fetchall():
		print("%s %s %s" % (row[0],row[1],row[2]))
	print("\n")
	Campaign_Management()

def Add_Event():
	print("Add event")
	Event = {
	'Name': str(input("Enter the name of the event:")),
	'ID': int(input("Enter the ID of the event:")),
	'StartDate': str(input("Enter start date in YYYY-MM-DD:")),
	'EndDate': str(input("Enter the end date in YYYY-MM-DD:")),
	'OrgID': int(input("Enter the organization Id:")),
	'CampID': int(input("Enter the Campaign Id:"))
	}
	cursor.execute(""" insert into Events values (%(Name)s,%(ID)s,%(StartDate)s,%(EndDate)s,%(OrgID)s,%(CampID)s)""",Event)
	print("---- Inserted into Events ----")
	cursor.execute(""" select Event_Name,Event_Id, Campaigns.Camp_Name from Events join Campaigns on Events.Camp_ID = Campaigns.Campaign_ID """)
	for row in cursor.fetchall():
		print("%s %s %s" % (row[0],row[1],row[2]))
	print("\n")
	Campaign_Management()

def Campaign_Management():
	print("Phase 2: \n"
		"How do you want to manage Campaigns:\n"
		"1 - View details about Campaigns \n"
		"2 - Set up a Campaign \n"
		"3 - Add a Volunteer \n"
		"4 - Schedule/Add Event \n"
		"5 - Exit Campaign Management \n")

	# Exception Handling only accepts integers between 1 and 5
	start = 1
	end = 5
	while True:
		try:
			user_inp = input("Which function would you like to use:")
			user_inp = int(user_inp)
			if start <= user_inp <= end:
				break
		except ValueError:
			print("You did not enter a valid index!! Please try again")
	
	if user_inp == 1:
		View_Campaign()
	elif user_inp == 2:
		Add_Campaign()
	elif user_inp == 3:
		Add_Volunteer()
	elif user_inp == 4:
		Add_Event()
	elif user_inp == 5:
		return

def Camp_Cost():
	print("Campaign costs")
	cursor.execute(""" select camp_name,cost from Campaigns """)
	for row in cursor.fetchall():
		print("%s %s" % (row[0],row[1]))
	print("\n")
	Account_Management()

def Camp_Revenue():
	print("Campaign Revenue")
	cursor.execute(""" select camp_name, funds_raised from Campaigns """)
	for row in cursor.fetchall():
		print("%s %s" % (row[0],row[1]))
	print("\n")
	Account_Management()

def Net_Income():
	print("Net income Generated by campaigns")
	cursor.execute(""" select camp_name, (Funds_raised + Donor.AmountDonated - cost) as netincome from Campaigns join Donor on Campaign_ID = Donor.Camp_ID """)
	for row in cursor.fetchall():
		print("%s %s" % (row[0],row[1]))
	print("\n")
	Account_Management()

def Donor_Info():
	print("Information on Donors")
	cursor.execute(""" select FirstName,LastName,AmountDonated,Campaigns.Camp_Name from Donor join Campaigns on Camp_ID = Campaigns.Campaign_ID """)
	for row in cursor.fetchall():
		print("%s %s %s %s" % (row[0],row[1],row[2],row[3]))
	print("\n")
	Account_Management()

def Account_Management():
	print("Phase 3: \n"
		"How would you like to manage the accounts:\n"
		"1 - Costs of Campaigns \n"
		"2 - Revenue Generated from Campaigns \n"
		"3 - Net Income including all expenses \n"
		"4 - Donor Information \n"
		"5 - Exit Account Management \n")
	start = 1
	end = 5
	while True:
		try:
			inp = input("Which function would you like to use:")
			inp = int(inp)
			if start <= inp <=end:
				break
		except ValueError:
			print("You did not enter a valid index!! Please try again")

	if inp == 1:
		Camp_Cost()
	elif inp == 2:
		Camp_Revenue()
	elif inp == 3:
		Net_Income()
	elif inp == 4:
		Donor_Info()
	elif inp == 5:
		return

def Membership_History():
	print("Viewing Membership History")
	cursor.execute(""" select Member_First_Name, Member_Last_Name, Camp_Name from Members join Campaigns on Camp_ID = Campaigns.Campaign_ID """)
	for row in cursor.fetchall():
		print("%s %s %s" % (row[0],row[1],row[2]))
	print("\n")
	Membership_Management()

def Add_Members_toCampaign():
	campID = input("Enter the Id of the campaign to which the member will be added")
	Member = {
	'FirstName': str(input("Enter the first name of the volunteer:")),
	'LastName': str(input("Enter the last name of the volunteer:")),
	'MemberID': int(input("Enter the member ID of the volunteer:")),
	'OrgID': int(input("Enter the ID of the organization, the volunteer works for:")),
	'CampID': int(campID)
	}
	cursor.execute(""" insert into Members values(%(FirstName)s,%(LastName)s,%(MemberID)s,%(OrgID)s,%(CampID)s)""",Member)
	print("---- Inserted into Members ----")
	print("\n")
	Membership_History()
	print("\n")
	Membership_Management()

def Members_whichCampaign():
	name = input("Which campaign are you looking for:")
	cursor.execute(""" select Member_First_Name,Member_Last_Name,Campaigns.Camp_Name from Members join Campaigns on Camp_ID = Campaigns.Campaign_ID where Camp_Name = '%s' """%(name))
	for row in cursor.fetchall():
		print("%s %s %s" % (row[0],row[1],row[2]))
	print("\n")
	Membership_Management()


def Membership_Management():
	print("Phase 4: \n"
		"How would you like to manage Membership: \n"
		"1 - Membership History: \n"
		"2 - Add members to Campaigns: \n"
		"3 - Members in Specific Campaign: \n"
		"4 - Exit Member Management: \n")
	start = 1
	end = 4
	while True:
		try:
			us_inp = input("Which function would you like to use:")
			us_inp = int(us_inp)
			if start <= us_inp <= end:
				break
		except ValueError:
			print("You did not enter a valid index!! Please try again")

	if us_inp == 1:
		Membership_History()
	if us_inp == 2:
		Add_Members_toCampaign()
	if us_inp == 3:
		Members_whichCampaign()
	if us_inp == 4:
		return

def View_Donor():
	print("View all the donors")
	cursor.execute(""" select * from Donor """)
	for row in cursor.fetchall():
		print("%s %s %s %s" % (row[0],row[1],row[2],row[3]))
	print("\n")
	Donor_Management()

def Add_Donor():
	print("Add a new donor")
	Donor = {
	'FirstName': str(input("Enter the first name of the donor:")),
	'LastName': str(input("Enter the last name of the donor:")),
	'AmountDonated': int(input("Enter the amount donated:")),
	'CampID': int(input("Enter the Id of the Campaign fow which donation was made:"))
	}
	cursor.execute(""" insert into Donor values(%(FirstName)s,%(LastName)s,%(AmountDonated)s,%(CampID)s)""",Donor)
	print("---- Inserted into Donor ----")
	print("\n")
	View_Donor()

def See_Donation():
	print("See how much a donor donated")
	first = input("Enter the first name of the donor:")
	last = input("Enter the last name of the donor:")
	cursor.execute(""" select * from Donor where FirstName = '%s' and LastName = '%s' """%(first,last))
	for row in cursor.fetchall():
		print("%s %s %s %s" % (row[0],row[1],row[2],row[3]))
	print("\n")
	Donor_Management()

def Donor_Management():
	print("Phase 5: \n"
		"How would you like to manage the donors today: \n"
		"1 - View all donors: \n"
		"2 - Add a donor: \n"
		"3 - See how much a donor donated: \n"
		"4 - Exit donor management: \n")
	start = 1
	end = 4
	while True:
		try:
			some_inp = input("Which function would you like to use:")
			some_inp = int(some_inp)
			if start <= some_inp <= end:
				break
		except ValueError:
			print("You did not enter a valid index!! Please try again")

	if some_inp == 1:
		View_Donor()
	elif some_inp == 2:
		Add_Donor()
	elif some_inp == 3:
		See_Donation()
	elif some_inp == 4:
		return


def Master():
	print("Which phase would you like to go to: \n"
		"1 - Phase 1 \n"
		"2 - Phase 2 \n"
		"3 - Phase 3 \n"
		"4 - Phase 4 \n"
		"5 - Phase 5 \n"
		"6 - Exit")
	start = 1
	end = 6
	while True:
		try:
			inp = input("Which phase would you like to go to:")
			inp = int(inp)
			if start <= inp <= end:
				break
		except ValueError:
			print("You did not enter a valid index!! Please try again")
	if inp == 1:
		selectviews()
		print("\n")
	elif inp == 2:
		Campaign_Management()
		print("\n")
	elif inp == 3:
		Account_Management()
		print("\n")
	elif inp == 4:
		Membership_Management()
		print("\n")
	elif inp == 5:
		Donor_Management()
		print("\n")
	elif inp == 6:
		return


def main():

	Master()
	print("\n")
	Campaign_Management()
	print("\n")
	Account_Management()
	print("\n")
	Membership_Management()
	print("\n")
	Donor_Management()
	print("\n")

	cursor.close()
	dbconn.close()
	

if __name__ == "__main__":
	main()
