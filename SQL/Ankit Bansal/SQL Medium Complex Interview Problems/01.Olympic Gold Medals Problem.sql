--1.where we need to find player with no of gold medals won by them only for players who won only gold medals.
--Methods1: filter only gold player which is not included in silver and bronze then do group by 

select * from events

select gold,count(*) as gold_cnts from events 
where gold not in (select silver from events) and gold not in (select bronze from events)
group by gold 