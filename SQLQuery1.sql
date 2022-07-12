select * from portfolioproject..data1;

select * from portfolioproject..data2;


-- total number of rows

select count(*) from PortfolioProject..data1;

select count(*) from PortfolioProject..data2;

-- data for two different states.

select * from PortfolioProject..data1
where State in ('kerala' , 'karnataka')
order by 4,5

-- total population of india

select sum(Population) as total_population from PortfolioProject..data2


-- average sex ratio of india by state

select state,avg(Sex_Ratio) as avg_sex_ratio from PortfolioProject..data1
group by State
order by  avg_sex_ratio desc;

-- average literacy rate

select State, AVG(Literacy) as avg_literacy from PortfolioProject..data1
	group by State
	having AVG(Literacy) > 83
		order by avg_literacy desc;

-- top 5 highest sex ratio

select top 5 State, round(avg(Sex_Ratio),0) as avg_sex_ratio from PortfolioProject..data1
group by State
order by  2 desc;


--last 5 lowest sex ratio

select TOp 5 State, round(avg(Sex_Ratio),0) as avg_sex_ratio from PortfolioProject..data1
group by State
order by  2 asc;


-- top and bottom 5 in literacy states

drop table if exists #bottomstates;
create table #bottomstates
(state nvarchar(255),
 bottomstate float)

 insert into #bottomstates
 select State, round(AVG(Literacy),1) as avg_literacy from PortfolioProject..data1
	group by State
		order by avg_literacy asc;

select top 5 * from #bottomstates
order by #bottomstates.bottomstate asc;





drop table if exists #topstates;
create table #topstates
(state nvarchar(255),
 topstate float)

 insert into #topstates
 select State, round(AVG(Literacy),1) as avg_literacy from PortfolioProject..data1
	group by State
		order by avg_literacy desc;

select top 5 * from #topstates
order by #topstates.topstate desc;





-- union operator

select * from (
select top 5 * from #topstates order by #topstates.topstate desc) a

union

select* from (
select top 5 * from #bottomstates order by #bottomstates.bottomstate asc) b
order by topstate desc;



--male vs female

select d.state, sum(d.males) as total_males, sum(d.females) as total_females from
(select c.District, c.State, round(c.Population/(c.Sex_Ratio + 1),0) as males, round(c.Population*(c.Sex_Ratio)/(c.Sex_Ratio+1),0) as females from
(select a.District, a.State, a.Sex_Ratio, b.Population from portfolioproject..data1 a
INNER JOIN portfolioproject..data2 b
ON a.District=b.District) c) d
group by d.state






-- total literacy rate

select  e.state,sum(literate_people) as total_literate_people, sum(illeterate_people)as total_illiterate_people from
(select c.district, c.state, c.population, round(c.literacy_ratio * c.population,0)as literate_people, round((1-c.literacy_ratio)*c.population,0) as illeterate_people from
(select a.State, a.District,b.Population,round(a.Literacy,0)/100 as literacy_ratio from portfolioproject..data1 a
inner join portfolioproject..data2 b
on a.District = b.District) c)e
group by e.state;



-- area by state

select a.state, sum(b.Area_km2) as Area_km2 from portfolioproject..data1 a
inner join portfolioproject..data2 b
on a.District=b.District
group by a.State


