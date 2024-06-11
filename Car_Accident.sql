#how many accidents have occurred in urban areas versus rural area?
select Area,count(AccidentIndex) as 'Total_accidents' 
from my_sqlp.accident
group by Area;

#-----------------------------
#which day of the week has the highest number of accidents?
select Day,count(AccidentIndex) as 'Total_accidents'
from my_sqlp.accident
group by Day
order by Total_accidents desc limit 1;

#------------------------------
#what is the average age of vehicles involved in accidents based on their type?
select VehicleType,count(AccidentIndex) as 'Total_accidents',round(avg(AgeVehicle),2) as 'AVG_ageVehicle'
from my_sqlp.vehicle
where AgeVehicle is not NULL
group by VehicleType
order by Total_accidents desc;

#can we identify any trends in accidents based on the age of vehicles involved?
#select distinct(AgeVehicle) from my_sqlp.vehicle;
select count(AccidentIndex) as 'Total_accidents' ,round(avg(AgeVehicle),2) as 'avg_year',Age_group
from (select AccidentIndex, AgeVehicle,
	  case
      when AgeVehicle between 0 and 5 then 'NEW'
      when AgeVehicle between 6 and 10 then 'FINE/MODRATE'
      else 'OLD'
      end as 'Age_group'
      from my_sqlp.vehicle)  as subquery
group by Age_group 
order by Total_accidents desc;


#-------------------------------------------
#are there any specific weather conditions that contribute to severe accidents?
#declare @Severity varchar(125)
#set @Severity='Slight'
select WeatherConditions,Severity,count(Severity) as 'Total_accidents' from my_sqlp.accident
#where Severity = @Severity 
group by WeatherConditions
order by WeatherConditions ;


#-------------------------------------------
#do accidents often involve impact on the left-hand side of the vehicles?
select LeftHand,count(AccidentIndex) as 'Total_accidents' from my_sqlp.vehicle
group by LeftHand
order by Total_accidents desc ;


#--------------------------------------------
#are there any relationships btw journey purpose and severity of accidents?
create temporary table t1 as 
(select 
V.JourneyPurpose,
count(A.Severity) as 'Total_accident'
case
when count(A.Severity) between 0 and 700 then 'low'
when count(A.Severity) between 701 and 1500 then 'medium'
else 'high'
end as 'level'
from 
my_sqlp.accident A 
join
my_sqlp.vehicle V on A.AccidentIndex = V.AccidentIndex
group by V.JourneyPurpose
order by Total_accident desc)
select * from t1 ;


#----------------------------------------------
#calculate the average age of vehicles involved in accident, considering day-light and point of impact:
select A.LightConditions,V.PointImpact,avg(V.AgeVehicle) as 'AvgYear' 
from 
my_sqlp.accident A
join 
my_sqlp.vehicle V 
on A.AccidentIndex = V.AccidentIndex
group by A.LightConditions,V.PointImpact