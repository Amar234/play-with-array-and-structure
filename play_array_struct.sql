/*
Here we have prepared the set of query for getting better understanding of Nested and Repeated_Fields.
Please go through the in line comments and hopefully it will give you a better understanding of array and struct.
In this script you donot neeed to create a any table. open it and run manually one by one and see the result.
*/



#Creating Array Data Defining with data type
Select ARRAY<STRING>['Deepak','Abhishek','Shyam','Parakh'] as Friends

#Creating Array Data Defining without data type you cannot define integer and string datatype in in the array at once. 
Select ARRAY['Deepak','Abhishek','Shyam','Parakh'] as Friends

# From this way as well we can create a array type column 
Select ['Deepak','Ashish Batra','Sunil','Abhishek','Shyam','Parakh'] as Friends

#Another way to declare an array
select Array(
	SELECT 'Deepak' as Team_Member
	union all
	SELECT 'Ashish Batra'  as Team_Member
	union all
	SELECT 'Sunil'  as Team_Member
	union all
	SELECT 'Abhishek'  as Team_Member
	union all
	SELECT 'Shyam'  as Team_Member
	union all
	SELECT 'Parakh'  as Team_Member
  ORDER BY  Team_Member
) as Teams

#Fetching data from array column based on the index. Ordinal start with 1
With friends as
(Select ARRAY['Deepak','Abhishek','Shyam','Parakh'] as Friend_Array
)
 select Friend_Array[ORDINAL(1)] as frnd_1st,
		Friend_Array[ORDINAL(2)] as frnd_2nd,
		Friend_Array[ORDINAL(3)] as frnd_3rd,
		Friend_Array[ORDINAL(4)] as frnd_4th 
	from friends

#Fetching data from array column based on the index. Offset start with zero
With friends as
(Select ARRAY['Deepak','Abhishek','Shyam','Parakh'] as Friend_Array
) select Friend_Array[OFFSET(1)] as frnd_1st,
         Friend_Array[OFFSET(2)] as frnd_2nd,
         Friend_Array[OFFSET(3)] as frnd_3rd,
        -- Friend_Array[OFFSET(4)] as frnd_4th 
        from friends

 
 # Finding the no. of friends from a array type table. Here it will give the count is 1 which is wrong. For getting the true count we have to move to next query
  With friends as
(Select ARRAY['Deepak','Abhishek','Shyam','Parakh'] as Friend_Array
)
 select count(*)
	from friends
  
  #Below query will provide us the exact no. of friends
 With friends as
(Select ARRAY['Deepak','Abhishek','Shyam','Parakh'] as Friend_Array
)
 select ARRAY_LENGTH(Friend_Array) no_Of_Frnds
	from friends
#Below query is select statement with repeated column and normal column 
Select 
	['Deepak','Ashish Batra','Sunil','Abhishek','Shyam','Parakh'] as Team_Member, 
	'Project1' Project
  
  
 # Changing the array type data to a normal table where you can perform your query
  Select Team_Member,Project
	from UNNEST(['Deepak','Ashish Batra','Sunil','Abhishek','Shyam','Parakh']) as Team_Member
	cross join (select 'Project1' Project )
  
#providing the index in the repeated column 
Select Team_Member,rownumber
	from UNNEST(['Deepak','Ashish Batra','Sunil','Abhishek','Shyam','Parakh']) as Team_Member
	with OFFSET as rownumber
order by rownumber


select Array(
	SELECT 'Deepak' as Team_Member
	union all
	SELECT 'Ashish Batra'  as Team_Member
	union all
	SELECT 'Sunil'  as Team_Member
	union all
	SELECT 'Abhishek'  as Team_Member
	union all
	SELECT 'Shyam'  as Team_Member
	union all
	SELECT 'Parakh'  as Team_Member
  ORDER BY  Team_Member
) as Teams

#Searching a value in the repeated column. In below query
With projectdetails as -- We are creating a temperorary table teams
(
	select ['Deepak','Shyam','Sapna'] Teams, 'Project1' Project
	union all
	select ['Shyam','Dhruv','Radhika'] Teams, 'Project2' Project
	union all
	select ['Yaduveer','Abhishek','Vaibhav'] Teams, 'HST' Project
)
select * from projectdetails 


# We are finding the Ashish batra is present in which project
With projectdetails as
(
	select ['Deepak','Shyam','Sapna','Ashish Batra'] Teams, 'Project1' Project
	union all
	select ['Shyam','Dhruv','Radhika','Ashish Batra'] Teams, 'Project2' Project
	union all
	select ['Yaduveer','Abhishek','Vaibhav','Manish'] Teams, 'HST' Project
)
select ARRAY(
		select Teammember 
			from UNNEST(Teams) as Teammember
			where 'Ashish Batra' in UNNEST(Teams) -- We are filtering here in above table ashish batra in the Teams
			),Project
			from projectdetails

#Creating a struct type data on the fly
select STRUCT<INT64, STRING>(3, 'Project1') as teams

#Creating a struct type data on the fly
select STRUCT(3 As noofpeople, 'Project1' as project) teams
#Creating a multiple row struct type data on the fly
select STRUCT(3 As noofpeople, 'Project1' as project)  teams
union all
select STRUCT(3 As noofpeople, 'Project2' as project) teams

# Struct type data with array column
select STRUCT(3 As noofpeople, 'Project1' as project,['Deepak','Shyam','Sapna','Ashish Batra'] as teammember)  as teams

# multiple Struct type data with array column
select STRUCT(3 As noofpeople, 'Project1' as project,['Deepak','Shyam','Sapna','Ashish Batra'] as teammember) AS teams
union all
select STRUCT(3 As noofpeople, 'Project2' as project, ['Shyam','Dhruv','Radhika','Ashish Batra'] ) teams

/*We have to found Shyam is working in how many projects. 
  Currently you can't filter it directly in where clause.
  So you have to unnest the array first then you can apply the filter.
*/
with cte as 
(
    select STRUCT(3 As noofpeople, 'Project1' as project,['Deepak','Shyam','Sapna','Ashish Batra'] as teammember) AS teams
      union all
     select STRUCT(3 As noofpeople, 'Project2' as project, ['Shyam','Dhruv','Radhika','Ashish Batra'] ) teams
)
select tm,teams.project from cte
left join UNNEST(teams.teammember) tm
where tm='Shyam'


