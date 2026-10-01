-- количество полисов по типу
select count(1) active_count
from   policy p
where  p.status = (select ps.status_id
                   from policy_statuses ps
                   where ps.status = 'Активен');

-- количество полисов по типам
select pt.type_name,
       count(1) policy_type_count,
       round(count(1) * 100.0 / (select count(1) from policy), 2) part_count
from   policy p, policy_types pt
where  p.policy_type = pt.type_id
group  by pt.type_name;

-- для Oracle
select pt.type_name,
       count(1) policy_type_count,
       round(ratio_to_report(count(1)) over (), 2) part_count
from   policy p, policy_types pt
where  p.policy_type = pt.type_id
group  by pt.type_name;

-- количество полисов по регионам
select c.region,
       count(1) policy_region_count,
       round(count(1) * 100.0 / (select count(1) from policy), 2) part_count
from   policy p, client c
where  p.client_id = c.client_id
group  by c.region;

-- для Oracle
select c.region,
       count(1) policy_region_count,
       round(ratio_to_report(count(1)) over (), 2) part_count
from   policy p, client c
where  p.client_id = c.client_id
group  by c.region;

-- основной запрос для дальнейшей работы
-- policy_id, client_id, region, policy_type, premium,
-- total_payments, claim_count, total_claims, loss_ratio
with main_table as (
select p.policy_id,
       c.client_id,
       c.region,
       p.policy_type, 
       p.premium,
       ifnull((select sum(pm.amount)
        from payment pm
        where pm.policy_id = p.policy_id
        and   pm.status = 1), 0) total_payments,
       (select count(1)
         from  claim cl
         where cl.policy_id = p.policy_id
         and   cl.status = 1) claim_count,
        ifnull((select sum(cl.claim_amount)
         from  claim cl
         where cl.policy_id = p.policy_id
         and   cl.status = 1), 0) total_claims
from policy p, 
     client c
where c.client_id = p.client_id
)
select mt.*,
       case 
         when mt.premium = 0 then 0
         else round(mt.total_claims * 1.0 / mt.premium, 2)
       end loss_ratio,
       case 
         when mt.premium = 0 then 'No premium'
         else case 
                when round(mt.total_claims * 1.0 / mt.premium, 2) > 1 then 'High'
                when round(mt.total_claims * 1.0 / mt.premium, 2) >= 0.5 then 'Medium'
                else 'Low'
              end
       end loss_ratio_type
from main_table mt
;


