-- проверка ограничений - запросы не должны возвращать записи

-- 1) полис оформлен на уже зарегистрированного клиента
select *
from policy p, client c
where c.client_id = p.client_id
and   c.registration_date > p.start_date;

-- 2) среди активных полисов нет истекших
select *
from policy p
where p.status = 1
and   p.end_date < date('now');

-- 3) активные полисы полностью оплачены 
with h as (
select p.policy_id, p.premium - (select sum(pm.amount)
                                 from payment pm
                                 where pm.policy_id = p.policy_id
                                 and   pm.status = 1
                                 ) as dif
from policy p
where p.status = 1 
)
select *  
from h;


