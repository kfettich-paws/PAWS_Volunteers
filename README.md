Analytics for PAWS
======

[Philadelphia Animal Welfare Society - PAWS](https://phillypaws.org/) - is a 501(c)3 non-profit organization dedicated to saving Philadelphia’s homeless and at-risk animals. PAWS is the city’s largest rescue partner and provider of low-cost, basic veterinary care for pet owners and rescue organizations that cannot otherwise access or afford it. PAWS currently runs three no-kill shelters, manages an extensive foster care network, and organizes special events almost every week to help animals find good homes. 

The [efforts of PAWS to make Philadelphia a no-kill city](http://www.acctphilly.org/news/introducing-the-philadelphia-no-kill-coalition/) rely heavily on the volunteers who give their time to feed, clean, walk, socialize, care for, and advertize the animals that arrive at PAWS' shelters every week. However, coordinating day-to-day operations leaves little time for the staff to gain a deep understanding of volunteer engagement and behavior, even though these data are tracked and saved. 

I have proposed to PAWS that R Ladies could help - after all, we have a dedicated group of expert data analysts who love to tackle questions of human behavior through data! They agreed to give us access to some of their data, and gave us a set of initial ideas for research that would be of high value to them. I would like to invite you to join us in this project - provide expertise, analysis, creative new questions, creative new solutions, or just moral support (and cookies?) :) The more, the merrier!


So, let's get started! 
- Karla

------

## Research Questions

The primary problem we would like to address is what PAWS can do to increase the likelihood that, after signing up for orientation, volunteers remain engaged with PAWS and continue to sign up and show up for their shifts. The initial set of research questions from PAWS are below. We will attempt to answer these, but we have full freedom to explore other things in the data as well. 

1. What is the typical engagement timeline for a volunteer, from attending orientation to completing first shift?
2. What is the typical volunteer behavior in the first month? In the first 2 months?
3. What is the typical pattern for volunteer disengagement? 
4. What factors contribute to a volunteer returning after shift 1? e.g. time of first shift attended; day/month/season of first shift attended; who else/how many others were there during first shift attended;  zip code; initial engagement pattern; sign-up pattern in first month; 
5. What factors contribute to a volunteer becoming a regular? e.g. time of first shift attended; day/month/season of first shift attended; who else/how many others were there during first shift attended;  zip code; initial engagement pattern; sign-up pattern in first month; 

------

## Data

There are 3 datasets we can use, with the following fields:

1. **master.csv**
- *ID* = unique de-identified ID number (identifies the same person across all datasets)
- *Status* = "Active"/"Inactive"/"Prospect"
- *City*
- *State*
- *Zip*
- *Life.hours* = total number of hours served by this volunteer since joining
- *Life.No.Call.No.Show* = total number of no call/no show times since joining
- *Life.Absence* = total number of absences since joining
- *YTD.hours* = total number of hours for current year
- *No.Call.No.Show* = total number of no call/no show times for current year
- *Call.Email.to.miss.shift* = total number of times called/emailed to miss a shift for current year
- *Absence*  = total number of absences for current year
- *Date.entered* = Date when the volunteer was entered into the volunteer management system by PAWS staff (occurs after orientation)
- *Start.date* = Date when the vlunteer signed into the system for the first time  
- *Orientation.Date* = Date of orientation (there's better info in another file)

2. **service.csv** (records of service for each volunteer)
This dataset only covers shifts between March 1, 2017 and March 1, 2018. We can expand this dataset in the future. In order to limit it to the people for whom we know we have all available records, we should filter out volunteers who had their orientation prior to March 1 2017, because otherwise volunteers who signed up in e.g. 2015 will appear as attending their first shift 3 years later.  

- *ID*
- *Site* = Site where the volunteer served for that entry; main values are "PAWS Adoption Center - Old City", "Grays Ferry Clinic - GF" and "PAWS Grant Ave. Adoption Center/Wellness Clinic", but other values are also possible (e.g. "PAWS off-site events", "Mutt Strut")
- *Assignment* = Specific duties the volunteer performed for that entry
- *From.date* = Date when assignment started
- *To.date* = Date when assignment ended (usually the same as above)
- *From.time* = Time when assignment started
- *To.time* = Time when assignment ended
- *Hours* = Number of hours served for that entry
- *No.Call.No.Show*
- *Call.Email.to.miss.shift*
- *Absence*

3. **signupsheet.csv** (when people signed up for initial orientation)
- *ID*
- *Orientation.Date* 
- *Type* = Type of orientation; each PAWS location has their own orientations, and some locations have multiple orientation types (e.g. "GF Basic", "GF WD" are Gray's Ferry Basic Orientation and Gray's Ferry Dog Orientation); sometimes volunteers can do 2 orientations in one day (e.g. "GF Basic + GF WD")
- *NOT.Attending* = Whether the volunteer cancelled ahead of time
- *Present* = whether the volunteer showed up
- *orientation* = Primary/Secondary; Primary indicates first ever orientation for this volunteer, secondary indicates a subsequent one. 

## Workflow and GitHub

- stay tuned :) please don't start pulling anything from the repo yet!