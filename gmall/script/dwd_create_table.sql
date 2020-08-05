--商品维度表
DROP TABLE IF EXISTS `dwd_dim_sku_info`;
CREATE EXTERNAL TABLE `dwd_dim_sku_info` (
`id` string COMMENT '商品 id',
`spu_id` string COMMENT 'spuid',
`price` double COMMENT '商品价格',
`sku_name` string COMMENT '商品名称',
`sku_desc` string COMMENT '商品描述',
`weight` double COMMENT '重量',
`tm_id` string COMMENT '品牌 id',
`tm_name` string COMMENT '品牌名称',
`category3_id` string COMMENT '三级分类 id',
`category2_id` string COMMENT '二级分类 id',
`category1_id` string COMMENT '一级分类 id',
`category3_name` string COMMENT '三级分类名称',
`category2_name` string COMMENT '二级分类名称',
`category1_name` string COMMENT '一级分类名称',
`spu_name` string COMMENT 'spu 名称',
`create_time` string COMMENT '创建时间'
)
COMMENT '商品维度表'
PARTITIONED BY (`dt` string)
stored as parquet location '/warehouse/gmall/dwd/dwd_dim_sku_info/';

--优惠券信息表
drop table if exists dwd_dim_coupon_info;
create external table dwd_dim_coupon_info(
`id` string COMMENT '购物券编号',
`coupon_name` string COMMENT '购物券名称',
`coupon_type` string COMMENT '购物券类型 1 现金券 2 折扣券 3 满减券 4 满件打折券',
`condition_amount` string COMMENT '满额数',
`condition_num` string COMMENT '满件数',
`activity_id` string COMMENT '活动编号',
`benefit_amount` string COMMENT '减金额',
`benefit_discount` string COMMENT '折扣',
`create_time` string COMMENT '创建时间',
`range_type` string COMMENT '范围类型 1、商品 2、品类 3、品牌',
`spu_id` string COMMENT '商品 id',
`tm_id` string COMMENT '品牌 id',
`category3_id` string COMMENT '品类 id',
`limit_num` string COMMENT '最多领用次数',
`operate_time` string COMMENT '修改时间',
`expire_time` string COMMENT '过期时间'
) COMMENT '优惠券信息表'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
stored as parquet location '/warehouse/gmall/dwd/dwd_dim_coupon_info/';

--活动信息表
drop table if exists dwd_dim_activity_info;
create external table dwd_dim_activity_info(
`id` string COMMENT '编号',
`activity_name` string COMMENT '活动名称',
`activity_type` string COMMENT '活动类型',
`condition_amount` string COMMENT '满减金额',
`condition_num` string COMMENT '满减件数',
`benefit_amount` string COMMENT '优惠金额',
`benefit_discount` string COMMENT '优惠折扣',
`benefit_level` string COMMENT '优惠级别',
`start_time` string COMMENT '开始时间',
`end_time` string COMMENT '结束时间',
`create_time` string COMMENT '创建时间'
) COMMENT '活动信息表'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
stored as parquet
location '/warehouse/gmall/dwd/dwd_dim_activity_info/';


--地区省市表
DROP TABLE IF EXISTS `dwd_dim_base_province`;
CREATE EXTERNAL TABLE `dwd_dim_base_province` (
`id` string COMMENT 'id',
`province_name` string COMMENT '省市名称',
`area_code` string COMMENT '地区编码',
`iso_code` string COMMENT 'ISO 编码',
`region_id` string COMMENT '地区 id',
`region_name` string COMMENT '地区名称'
)
COMMENT '地区省市表'
stored as parquet
location '/warehouse/gmall/dwd/dwd_dim_base_province/';


--时间维度
DROP TABLE IF EXISTS `dwd_dim_date_info`;
CREATE EXTERNAL TABLE if exists `dwd_dim_date_info`(
`date_id` string COMMENT '日',
`week_id` int COMMENT '周',
`week_day` int COMMENT '周的第几天',
`day` int COMMENT '每月的第几天',
`month` int COMMENT '第几月',
`quarter` int COMMENT '第几季度',
`year` int COMMENT '年',
`is_workday` int COMMENT '是否是周末',
`holiday_id` int COMMENT '是否是节假日'
)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/dwd/dwd_dim_date_info/';


--订单明细事实表
drop table if exists dwd_fact_order_detail;
create external table dwd_fact_order_detail (
`id` string COMMENT '订单编号',
`order_id` string COMMENT '订单号',
`user_id` string COMMENT '用户 id',
`sku_id` string COMMENT 'sku 商品 id',
`sku_name` string COMMENT '商品名称',
`order_price` decimal(10,2) COMMENT '商品价格',
`sku_num` bigint COMMENT '商品数量',
`create_time` string COMMENT '创建时间',
`province_id` string COMMENT '省份 ID',
`total_amount` decimal(20,2) COMMENT '订单总金额'
)
PARTITIONED BY (`dt` string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_fact_order_detail/';


--支付事实表
drop table if exists dwd_fact_payment_info;
create external table dwd_fact_payment_info (
`id` string COMMENT '',
`out_trade_no` string COMMENT '对外业务编号',
`order_id` string COMMENT '订单编号',
`user_id` string COMMENT '用户编号',
`alipay_trade_no` string COMMENT '支付宝交易流水编号',
`payment_amount` decimal(16,2) COMMENT '支付金额',
`subject` string COMMENT '交易内容',
`payment_type` string COMMENT '支付类型',
`payment_time` string COMMENT '支付时间',
`province_id` string COMMENT '省份 ID'
)
PARTITIONED BY (`dt` string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_fact_payment_info/';


--退款事实表
drop table if exists dwd_fact_order_refund_info;
create external table dwd_fact_order_refund_info(
`id` string COMMENT '编号',
`user_id` string COMMENT '用户 ID',
`order_id` string COMMENT '订单 ID',
`sku_id` string COMMENT '商品 ID',
`refund_type` string COMMENT '退款类型',
`refund_num` bigint COMMENT '退款件数',
`refund_amount` decimal(16,2) COMMENT '退款金额',
`refund_reason_type` string COMMENT '退款原因类型',
`create_time` string COMMENT '退款时间'
) COMMENT '退款事实表'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/dwd/dwd_fact_order_refund_info/';


--评价事实表
drop table if exists dwd_fact_comment_info;
create external table dwd_fact_comment_info(
`id` string COMMENT '编号',
`user_id` string COMMENT '用户 ID',
`sku_id` string COMMENT '商品 sku',
`spu_id` string COMMENT '商品 spu',
`order_id` string COMMENT '订单 ID',
`appraise` string COMMENT '评价',
`create_time` string COMMENT '评价时间'
) COMMENT '评价事实表'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/dwd/dwd_fact_comment_info/';


--加购事实表
drop table if exists dwd_fact_cart_info;
create external table dwd_fact_cart_info(
`id` string COMMENT '编号',
`user_id` string COMMENT '用户 id',
`sku_id` string COMMENT 'skuid',
`cart_price` string COMMENT '放入购物车时价格',
`sku_num` string COMMENT '数量',
`sku_name` string COMMENT 'sku 名称 (冗余)',
`create_time` string COMMENT '创建时间',
`operate_time` string COMMENT '修改时间',
`is_ordered` string COMMENT '是否已经下单。1 为已下单;0 为未下单',
`order_time` string COMMENT '下单时间'
) COMMENT '加购事实表'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/dwd/dwd_fact_cart_info/';

--收藏事实表
drop table if exists dwd_fact_favor_info;
create external table dwd_fact_favor_info(
`id` string COMMENT '编号',
`user_id` string COMMENT '用户 id',
`sku_id` string COMMENT 'skuid',
`spu_id` string COMMENT 'spuid',
`is_cancel` string COMMENT '是否取消',
`create_time` string COMMENT '收藏时间',
`cancel_time` string COMMENT '取消时间'
) COMMENT '收藏事实表'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/dwd/dwd_fact_favor_info/';


--优惠券领用事实表
drop table if exists dwd_fact_coupon_use;
create external table dwd_fact_coupon_use(
`id` string COMMENT '编号',
`coupon_id` string COMMENT '优惠券 ID',
`user_id` string COMMENT 'userid',
`order_id` string COMMENT '订单 id',
`coupon_status` string COMMENT '优惠券状态',
`get_time` string COMMENT '领取时间',
`using_time` string COMMENT '使用时间(下单)',
`used_time` string COMMENT '使用时间(支付)'
) COMMENT '优惠券领用事实表'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/dwd/dwd_fact_coupon_use/';

--订单事实表
drop table if exists dwd_fact_order_info;
create external table dwd_fact_order_info (
`id` string COMMENT '订单编号',
`order_status` string COMMENT '订单状态',
`user_id` string COMMENT '用户 id',
`out_trade_no` string COMMENT '支付流水号',
`create_time` string COMMENT '创建时间(未支付状态)',
`payment_time` string COMMENT '支付时间(已支付状态)',
`cancel_time` string COMMENT '取消时间(已取消状态)',
`finish_time` string COMMENT '完成时间(已完成状态)',
`refund_time` string COMMENT '退款时间(退款中状态)',
`refund_finish_time` string COMMENT '退款完成时间(退款完成状态)',
`province_id` string COMMENT '省份 ID',
`activity_id` string COMMENT '活动 ID',
`original_total_amount` string COMMENT '原价金额',
`benefit_reduce_amount` string COMMENT '优惠金额',
`feight_fee` string COMMENT '运费',
`final_total_amount` decimal(10,2) COMMENT '订单金额'
)
PARTITIONED BY (`dt` string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_fact_order_info/';


--用户拉链表
drop table if exists dwd_dim_user_info_his;
create external table dwd_dim_user_info_his(
`id` string COMMENT '用户 id',
`name` string COMMENT '姓名',
`birthday` string COMMENT '生日',
`gender` string COMMENT '性别',
`email` string COMMENT '邮箱',
`user_level` string COMMENT '用户等级',
`create_time` string COMMENT '创建时间',
`operate_time` string COMMENT '操作时间',
`start_date` string COMMENT '有效开始日期',
`end_date` string COMMENT '有效结束日期'
) COMMENT '订单拉链表'
stored as parquet
location '/warehouse/gmall/dwd/dwd_dim_user_info_his/'