--商品维度表逻辑
insert overwrite table dwd_dim_sku_info partition(dt='2020-03-10')
select
sku.id,
sku.spu_id,
sku.price,
sku.sku_name,
sku.sku_desc,
sku.weight,
sku.tm_id,
ob.tm_name,
sku.category3_id,
c2.id category2_id,
c1.id category1_id,
c3.name category3_name,
c2.name category2_name,
c1.name category1_name,
spu.spu_name,
sku.create_time
from
(
select * from ods_sku_info where dt='2020-03-10'
)sku
join
(
select * from ods_base_trademark where dt='2020-03-10'
)ob on sku.tm_id=ob.tm_id
join
(
select * from ods_spu_info where dt='2020-03-10'
)spu on spu.id = sku.spu_id
join
(
select * from ods_base_category3 where dt='2020-03-10'
)c3 on sku.category3_id=c3.id
join
(
select * from ods_base_category2 where dt='2020-03-10'
)c2 on c3.category2_id=c2.id
join
(
select * from ods_base_category1 where dt='2020-03-10'
)c1 on c2.category1_id=c1.id;

insert overwrite table dwd_dim_coupon_info partition(dt='2020-03-10')
select
id,
coupon_name,
coupon_type,
condition_amount,
condition_num,
activity_id,
benefit_amount,
benefit_discount,
create_time,
range_type,
spu_id,
tm_id,
category3_id,
limit_num,
operate_time,
expire_time
from ods_coupon_info
where dt='2020-03-10';

insert overwrite table dwd_dim_activity_info partition(dt='2020-03-10')
select
info.id,
info.activity_name,
info.activity_type,
rule.condition_amount,
rule.condition_num,
rule.benefit_amount,
rule.benefit_discount,
rule.benefit_level,
info.start_time,
info.end_time,
info.create_time
from
(
select * from ods_activity_info where dt='2020-03-10'
)info
left join
(
select * from ods_activity_rule where dt='2020-03-10'
)rule on info.id = rule.activity_id;

insert overwrite table dwd_dim_base_province
select
bp.id,
bp.name,
bp.area_code,
bp.iso_code,
bp.region_id,
br.region_name
from ods_base_province bp
join ods_base_region br
on bp.region_id=br.id;

insert overwrite table dwd_fact_order_detail partition(dt='2020-03-10')
select
od.id,
od.order_id,
od.user_id,
od.sku_id,
od.sku_name,
od.order_price,
od.sku_num,
od.create_time,
oi.province_id,
od.order_price*od.sku_num
from
(
select * from ods_order_detail where dt='2020-03-10'
) od
join
(
select * from ods_order_info where dt='2020-03-10'
) oi
on od.order_id=oi.id;

insert overwrite table dwd_fact_payment_info partition(dt='2020-03-10')
select
pi.id,
pi.out_trade_no,
pi.order_id,
pi.user_id,
pi.alipay_trade_no,
pi.total_amount,
pi.subject,
pi.payment_type,
pi.payment_time,
oi.province_id
from
(
select * from ods_payment_info where dt='2020-03-10'
)pi
join
(
select id, province_id from ods_order_info where dt='2020-03-10'
)oi
on pi.order_id = oi.id;


insert overwrite table dwd_fact_order_refund_info partition(dt='2020-03-10')
select
id,
user_id,
order_id,
sku_id,
refund_type,
refund_num,
refund_amount,
refund_reason_type,
create_time
from ods_order_refund_info
where dt='2020-03-10';

insert overwrite table dwd_fact_comment_info partition(dt='2020-03-10')
select
id,
user_id,
sku_id,
spu_id,
order_id,
appraise,
create_time
from ods_comment_info
where dt='2020-03-10';

insert overwrite table dwd_fact_cart_info partition(dt='2020-03-10')
select
id,
user_id,
sku_id,
cart_price,
sku_num,
sku_name,
create_time,
operate_time,
is_ordered,
order_time
from ods_cart_info
where dt='2020-03-10';

insert overwrite table dwd_fact_favor_info partition(dt='2020-03-10')
select
id,
user_id,
sku_id,
spu_id,
is_cancel,
create_time,
cancel_time
from ods_favor_info
where dt='2020-03-10';


insert overwrite table dwd_fact_coupon_use partition(dt)
select
if(new.id is null,old.id,new.id),
if(new.coupon_id is null,old.coupon_id,new.coupon_id),
if(new.user_id is null,old.user_id,new.user_id),
if(new.order_id is null,old.order_id,new.order_id),
if(new.coupon_status is null,old.coupon_status,new.coupon_status),
if(new.get_time is null,old.get_time,new.get_time),
if(new.using_time is null,old.using_time,new.using_time),
if(new.used_time is null,old.used_time,new.used_time),
date_format(if(new.get_time is null,old.get_time,new.get_time),'yyyy-MM-dd')
from
(
select
id,
coupon_id,
user_id,
order_id,
coupon_status,
get_time,
using_time,
used_time
from dwd_fact_coupon_use
where dt in
(
select
date_format(get_time,'yyyy-MM-dd')
from ods_coupon_use
where dt='2020-03-10'
)
)old
full outer join
(
select
id,
coupon_id,
user_id,
order_id,
coupon_status,
get_time,
using_time,
used_time
from ods_coupon_use
where dt='2020-03-10'
)new
on old.id=new.id;

set hive.exec.dynamic.partition.mode=nonstrict;
insert overwrite table dwd_fact_order_info partition(dt)
select
if(new.id is null,old.id,new.id),
if(new.order_status is null,old.order_status,new.order_status),
if(new.user_id is null,old.user_id,new.user_id),
if(new.out_trade_no is null,old.out_trade_no,new.out_trade_no),
if(new.tms['1001'] is null,old.create_time,new.tms['1001']),--1001 对应未支付状态
if(new.tms['1002'] is null,old.payment_time,new.tms['1002']),
if(new.tms['1003'] is null,old.cancel_time,new.tms['1003']),
if(new.tms['1004'] is null,old.finish_time,new.tms['1004']),
if(new.tms['1005'] is null,old.refund_time,new.tms['1005']),
if(new.tms['1006'] is null,old.refund_finish_time,new.tms['1006']),
if(new.province_id is null,old.province_id,new.province_id),
if(new.activity_id is null,old.activity_id,new.activity_id),
if(new.original_total_amount is
null,old.original_total_amount,new.original_total_amount),
if(new.benefit_reduce_amount is
null,old.benefit_reduce_amount,new.benefit_reduce_amount),
if(new.feight_fee is null,old.feight_fee,new.feight_fee),
if(new.final_total_amount is null,old.final_total_amount,new.final_total_amount),
date_format(if(new.tms['1001'] is
null,old.create_time,new.tms['1001']),'yyyy-MM-dd')
from
(
select
id,
order_status,
user_id,
out_trade_no,
create_time,
payment_time,
cancel_time,
finish_time,
refund_time,
refund_finish_time,
province_id,
activity_id,
original_total_amount,
benefit_reduce_amount,
feight_fee,
final_total_amount
from dwd_fact_order_info
where dt
in
(
select
date_format(create_time,'yyyy-MM-dd')
from ods_order_info
where dt='2020-03-10'
)
)old
full outer join
(
select
info.id,
info.order_status,
info.user_id,
info.out_trade_no,
info.province_id,
act.activity_id,
log.tms,
info.original_total_amount,
info.benefit_reduce_amount,
info.feight_fee,
info.final_total_amount
from
(
select
order_id,
str_to_map(concat_ws(',',collect_set(concat(order_status,'=',operate_time))),',','=')
tms
from ods_order_status_log
where dt='2020-03-10'
group by order_id
)log
join
(
select * from ods_order_info where dt='2020-03-10'
)info
on log.order_id=info.id
left join
(
select * from ods_activity_order where dt='2020-03-10'
)act
on log.order_id=act.order_id
)new
on old.id=new.id;

insert overwrite table dwd_dim_user_info_his
select
id,
name,
birthday,
gender,
email,
user_level,
create_time,
operate_time,
'2020-03-10',
'9999-99-99'
from ods_user_info oi
where oi.dt='2020-03-10';