with clients as ( --Отбираем корректных клиентов
	select 
		card,
		datetime::date as datetime,
		summ,
		doc_id
	from bonuscheques b 
	where card like '2000%'
),
clients_groups as (
	select
		card as "Покупатель",  			   -- Группируем покупателей с их суммами и количества покупок,
		max(datetime) as "Дата последней покупки",-- а также смотрим сколько дней прошло с последней покупки
		make_date(2022, 06, 09) - max (datetime) as "Дней с последней покупки",
		sum(summ) as "Сумма покупок",
		count(distinct doc_id) as "Частота покупок"
	from clients
	group by card
	having count(distinct doc_id) > 1
),
perc as (											-- Определяем перцентили, чтобы границы автоматически менялись
													-- с изменением показателей (средний чек, частота покупок и тд)
	select 
		percentile_disc(0.3) within group (order by "Дней с последней покупки") as "1_R",
		percentile_disc(0.6) within group (order by "Дней с последней покупки") as "2_R",
		percentile_disc(0.8) within group (order by "Частота покупок") as "1_F",
		percentile_disc(0.3) within group (order by "Частота покупок") as "2_F",
		percentile_disc(0.8) within group (order by "Сумма покупок") as "1_M",
		percentile_disc(0.4) within group (order by "Сумма покупок") as "2_M"
	from clients_groups
),
rfm as (
	select
		"Покупатель",
		"Дата последней покупки",
		"Дней с последней покупки",
		"R",
		"Частота покупок",
		"F",
		"Сумма покупок",
		"M",
		"R" || "F" || "M" as "RFM"
	from (
		select
			"Покупатель",
			"Дата последней покупки",
			"Дней с последней покупки",
			case when "Дней с последней покупки" <= perc."1_R" then '1'
				when "Дней с последней покупки" <= perc."2_R" then '2'
				else '3' end "R",
			"Частота покупок",
			case when "Частота покупок" >=perc."1_F" then '1'
				when "Частота покупок" > perc."2_F" then '2'
				else '3' end "F",
			"Сумма покупок",
			case when "Сумма покупок" >= perc."1_M" then '1'
				when "Сумма покупок" >= perc."2_M" then '2'
				else '3' end "M"
		from clients_groups, perc
	) t
)
select
	"Покупатель",
	"Дата последней покупки",
	"Дней с последней покупки",
	"R",
	"Частота покупок",
	"F",
	"Сумма покупок",
	"M",
	"RFM",
	"Группа"
from (
	select
		"Покупатель",
		"Дата последней покупки",
		"Дней с последней покупки",
		"R",
		"Частота покупок",
		"F",
		"Сумма покупок",
		"M",
		case when "RFM" = '111' then 'VIP'
			when "RFM" in ('112', '121', '122') then 'Постоянники'
			when "RFM" in ('311', '312') then 'Давние постоянники'
			when "RFM" in ('211', '212', '221', '222', '231') then 'Потенциальные'
			when "RFM" in ('113', '123', '131', '132', '232') then 'Слабо потенциальные'
			when "RFM" in ('133', '213', '223') then 'Низкопотенциальные'
			when "RFM" in ('321', '322', '331', '332') then 'Ушедшие потенциальные'
			else 'Не потенциальные'
		end "Группа",
		"RFM"
	from rfm
) t
order by "Группа"