CREATE TABLE PAY_UID(
	pay_uid	varchar2(17) primary key,
	mem_num number not null,
	 constraint member_fk foreign key (mem_num)
                           references member (mem_num)
);