--��Ʒά�ȱ�
DROP TABLE IF EXISTS `dwd_dim_sku_info`;
CREATE EXTERNAL TABLE `dwd_dim_sku_info` (
`id` string COMMENT '��Ʒ id',
`spu_id` string COMMENT 'spuid',
`price` double COMMENT '��Ʒ�۸�',
`sku_name` string COMMENT '��Ʒ����',
`sku_desc` string COMMENT '��Ʒ����',
`weight` double COMMENT '����',
`tm_id` string COMMENT 'Ʒ�� id',
`tm_name` string COMMENT 'Ʒ������',
`category3_id` string COMMENT '�������� id',
`category2_id` string COMMENT '�������� id',
`category1_id` string COMMENT 'һ������ id',
`category3_name` string COMMENT '������������',
`category2_name` string COMMENT '������������',
`category1_name` string COMMENT 'һ����������',
`spu_name` string COMMENT 'spu ����',
`create_time` string COMMENT '����ʱ��'
)
COMMENT '��Ʒά�ȱ�'
PARTITIONED BY (`dt` string)
stored as parquet location '/warehouse/gmall/dwd/dwd_dim_sku_info/';

--�Ż�ȯ��Ϣ��
drop table if exists dwd_dim_coupon_info;
create external table dwd_dim_coupon_info(
`id` string COMMENT '����ȯ���',
`coupon_name` string COMMENT '����ȯ����',
`coupon_type` string COMMENT '����ȯ���� 1 �ֽ�ȯ 2 �ۿ�ȯ 3 ����ȯ 4 ��������ȯ',
`condition_amount` string COMMENT '������',
`condition_num` string COMMENT '������',
`activity_id` string COMMENT '����',
`benefit_amount` string COMMENT '�����',
`benefit_discount` string COMMENT '�ۿ�',
`create_time` string COMMENT '����ʱ��',
`range_type` string COMMENT '��Χ���� 1����Ʒ 2��Ʒ�� 3��Ʒ��',
`spu_id` string COMMENT '��Ʒ id',
`tm_id` string COMMENT 'Ʒ�� id',
`category3_id` string COMMENT 'Ʒ�� id',
`limit_num` string COMMENT '������ô���',
`operate_time` string COMMENT '�޸�ʱ��',
`expire_time` string COMMENT '����ʱ��'
) COMMENT '�Ż�ȯ��Ϣ��'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
stored as parquet location '/warehouse/gmall/dwd/dwd_dim_coupon_info/';

--���Ϣ��
drop table if exists dwd_dim_activity_info;
create external table dwd_dim_activity_info(
`id` string COMMENT '���',
`activity_name` string COMMENT '�����',
`activity_type` string COMMENT '�����',
`condition_amount` string COMMENT '�������',
`condition_num` string COMMENT '��������',
`benefit_amount` string COMMENT '�Żݽ��',
`benefit_discount` string COMMENT '�Ż��ۿ�',
`benefit_level` string COMMENT '�Żݼ���',
`start_time` string COMMENT '��ʼʱ��',
`end_time` string COMMENT '����ʱ��',
`create_time` string COMMENT '����ʱ��'
) COMMENT '���Ϣ��'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
stored as parquet
location '/warehouse/gmall/dwd/dwd_dim_activity_info/';


--����ʡ�б�
DROP TABLE IF EXISTS `dwd_dim_base_province`;
CREATE EXTERNAL TABLE `dwd_dim_base_province` (
`id` string COMMENT 'id',
`province_name` string COMMENT 'ʡ������',
`area_code` string COMMENT '��������',
`iso_code` string COMMENT 'ISO ����',
`region_id` string COMMENT '���� id',
`region_name` string COMMENT '��������'
)
COMMENT '����ʡ�б�'
stored as parquet
location '/warehouse/gmall/dwd/dwd_dim_base_province/';


--ʱ��ά��
DROP TABLE IF EXISTS `dwd_dim_date_info`;
CREATE EXTERNAL TABLE if exists `dwd_dim_date_info`(
`date_id` string COMMENT '��',
`week_id` int COMMENT '��',
`week_day` int COMMENT '�ܵĵڼ���',
`day` int COMMENT 'ÿ�µĵڼ���',
`month` int COMMENT '�ڼ���',
`quarter` int COMMENT '�ڼ�����',
`year` int COMMENT '��',
`is_workday` int COMMENT '�Ƿ�����ĩ',
`holiday_id` int COMMENT '�Ƿ��ǽڼ���'
)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/dwd/dwd_dim_date_info/';


--������ϸ��ʵ��
drop table if exists dwd_fact_order_detail;
create external table dwd_fact_order_detail (
`id` string COMMENT '�������',
`order_id` string COMMENT '������',
`user_id` string COMMENT '�û� id',
`sku_id` string COMMENT 'sku ��Ʒ id',
`sku_name` string COMMENT '��Ʒ����',
`order_price` decimal(10,2) COMMENT '��Ʒ�۸�',
`sku_num` bigint COMMENT '��Ʒ����',
`create_time` string COMMENT '����ʱ��',
`province_id` string COMMENT 'ʡ�� ID',
`total_amount` decimal(20,2) COMMENT '�����ܽ��'
)
PARTITIONED BY (`dt` string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_fact_order_detail/';


--֧����ʵ��
drop table if exists dwd_fact_payment_info;
create external table dwd_fact_payment_info (
`id` string COMMENT '',
`out_trade_no` string COMMENT '����ҵ����',
`order_id` string COMMENT '�������',
`user_id` string COMMENT '�û����',
`alipay_trade_no` string COMMENT '֧����������ˮ���',
`payment_amount` decimal(16,2) COMMENT '֧�����',
`subject` string COMMENT '��������',
`payment_type` string COMMENT '֧������',
`payment_time` string COMMENT '֧��ʱ��',
`province_id` string COMMENT 'ʡ�� ID'
)
PARTITIONED BY (`dt` string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_fact_payment_info/';


--�˿���ʵ��
drop table if exists dwd_fact_order_refund_info;
create external table dwd_fact_order_refund_info(
`id` string COMMENT '���',
`user_id` string COMMENT '�û� ID',
`order_id` string COMMENT '���� ID',
`sku_id` string COMMENT '��Ʒ ID',
`refund_type` string COMMENT '�˿�����',
`refund_num` bigint COMMENT '�˿����',
`refund_amount` decimal(16,2) COMMENT '�˿���',
`refund_reason_type` string COMMENT '�˿�ԭ������',
`create_time` string COMMENT '�˿�ʱ��'
) COMMENT '�˿���ʵ��'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/dwd/dwd_fact_order_refund_info/';


--������ʵ��
drop table if exists dwd_fact_comment_info;
create external table dwd_fact_comment_info(
`id` string COMMENT '���',
`user_id` string COMMENT '�û� ID',
`sku_id` string COMMENT '��Ʒ sku',
`spu_id` string COMMENT '��Ʒ spu',
`order_id` string COMMENT '���� ID',
`appraise` string COMMENT '����',
`create_time` string COMMENT '����ʱ��'
) COMMENT '������ʵ��'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/dwd/dwd_fact_comment_info/';


--�ӹ���ʵ��
drop table if exists dwd_fact_cart_info;
create external table dwd_fact_cart_info(
`id` string COMMENT '���',
`user_id` string COMMENT '�û� id',
`sku_id` string COMMENT 'skuid',
`cart_price` string COMMENT '���빺�ﳵʱ�۸�',
`sku_num` string COMMENT '����',
`sku_name` string COMMENT 'sku ���� (����)',
`create_time` string COMMENT '����ʱ��',
`operate_time` string COMMENT '�޸�ʱ��',
`is_ordered` string COMMENT '�Ƿ��Ѿ��µ���1 Ϊ���µ�;0 Ϊδ�µ�',
`order_time` string COMMENT '�µ�ʱ��'
) COMMENT '�ӹ���ʵ��'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/dwd/dwd_fact_cart_info/';

--�ղ���ʵ��
drop table if exists dwd_fact_favor_info;
create external table dwd_fact_favor_info(
`id` string COMMENT '���',
`user_id` string COMMENT '�û� id',
`sku_id` string COMMENT 'skuid',
`spu_id` string COMMENT 'spuid',
`is_cancel` string COMMENT '�Ƿ�ȡ��',
`create_time` string COMMENT '�ղ�ʱ��',
`cancel_time` string COMMENT 'ȡ��ʱ��'
) COMMENT '�ղ���ʵ��'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/dwd/dwd_fact_favor_info/';


--�Ż�ȯ������ʵ��
drop table if exists dwd_fact_coupon_use;
create external table dwd_fact_coupon_use(
`id` string COMMENT '���',
`coupon_id` string COMMENT '�Ż�ȯ ID',
`user_id` string COMMENT 'userid',
`order_id` string COMMENT '���� id',
`coupon_status` string COMMENT '�Ż�ȯ״̬',
`get_time` string COMMENT '��ȡʱ��',
`using_time` string COMMENT 'ʹ��ʱ��(�µ�)',
`used_time` string COMMENT 'ʹ��ʱ��(֧��)'
) COMMENT '�Ż�ȯ������ʵ��'
PARTITIONED BY (`dt` string)
row format delimited fields terminated by '\t'
location '/warehouse/gmall/dwd/dwd_fact_coupon_use/';

--������ʵ��
drop table if exists dwd_fact_order_info;
create external table dwd_fact_order_info (
`id` string COMMENT '�������',
`order_status` string COMMENT '����״̬',
`user_id` string COMMENT '�û� id',
`out_trade_no` string COMMENT '֧����ˮ��',
`create_time` string COMMENT '����ʱ��(δ֧��״̬)',
`payment_time` string COMMENT '֧��ʱ��(��֧��״̬)',
`cancel_time` string COMMENT 'ȡ��ʱ��(��ȡ��״̬)',
`finish_time` string COMMENT '���ʱ��(�����״̬)',
`refund_time` string COMMENT '�˿�ʱ��(�˿���״̬)',
`refund_finish_time` string COMMENT '�˿����ʱ��(�˿����״̬)',
`province_id` string COMMENT 'ʡ�� ID',
`activity_id` string COMMENT '� ID',
`original_total_amount` string COMMENT 'ԭ�۽��',
`benefit_reduce_amount` string COMMENT '�Żݽ��',
`feight_fee` string COMMENT '�˷�',
`final_total_amount` decimal(10,2) COMMENT '�������'
)
PARTITIONED BY (`dt` string)
stored as parquet
location '/warehouse/gmall/dwd/dwd_fact_order_info/';


--�û�������
drop table if exists dwd_dim_user_info_his;
create external table dwd_dim_user_info_his(
`id` string COMMENT '�û� id',
`name` string COMMENT '����',
`birthday` string COMMENT '����',
`gender` string COMMENT '�Ա�',
`email` string COMMENT '����',
`user_level` string COMMENT '�û��ȼ�',
`create_time` string COMMENT '����ʱ��',
`operate_time` string COMMENT '����ʱ��',
`start_date` string COMMENT '��Ч��ʼ����',
`end_date` string COMMENT '��Ч��������'
) COMMENT '����������'
stored as parquet
location '/warehouse/gmall/dwd/dwd_dim_user_info_his/';

--�û�������ʱ��
drop table if exists dwd_dim_user_info_his_tmp;
create external table dwd_dim_user_info_his_tmp(
`id` string COMMENT '�û� id',
`name` string COMMENT '����',
`birthday` string COMMENT '����',
`gender` string COMMENT '�Ա�',
`email` string COMMENT '����',
`user_level` string COMMENT '�û��ȼ�',
`create_time` string COMMENT '����ʱ��',
`operate_time` string COMMENT '����ʱ��',
`start_date` string COMMENT '��Ч��ʼ����',
`end_date` string COMMENT '��Ч��������'
) COMMENT '����������ʱ��'
stored as parquet
location '/warehouse/gmall/dwd/dwd_dim_user_info_his_tmp/';