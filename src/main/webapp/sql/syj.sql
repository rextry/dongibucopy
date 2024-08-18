CREATE TABLE CHALLENGE (
	chal_num		number						NOT NULL,
	mem_num			number							NOT NULL,
	chal_type		number(2)						NOT NULL,
	chal_title		varchar2(50)					NOT NULL,
	chal_content	clob							NULL,
	chal_photo		varchar2(400)					NULL,
	chal_verify		varchar2(4000)					NOT NULL,
	chal_freq		number(1)						NOT NULL,
	chal_sdate		varchar2(10)					NOT NULL,
	chal_edate		varchar2(10)					NOT NULL,
	chal_fee		number(10)						NOT NULL,
	chal_max		number(9)		DEFAULT 1		NULL,
	chal_rdate		date			DEFAULT SYSDATE	NOT NULL,
	chal_public		number(1) 		DEFAULT 0		NOT NULL,
	chal_ip			varchar2(40) 					NOT NULL
);

COMMENT ON COLUMN CHALLENGE.chal_num IS '챌린지 식별 번호,sequence 사용';

COMMENT ON COLUMN CHALLENGE.mem_num IS '챌린지를 개설 신청한 리더,sequence 사용';

COMMENT ON COLUMN CHALLENGE.chal_public IS '챌린지 공개여부 (0:공개, 1:비공개)';

COMMENT ON COLUMN CHALLENGE.chal_type IS '챌린지 카테고리';

COMMENT ON COLUMN CHALLENGE.chal_title IS '챌린지 제목';

COMMENT ON COLUMN CHALLENGE.chal_content IS '챌린지 소개';

COMMENT ON COLUMN CHALLENGE.chal_photo IS '챌린지 썸네일';

COMMENT ON COLUMN CHALLENGE.chal_verify IS '챌린지 인증방법 설명';

COMMENT ON COLUMN CHALLENGE.chal_freq IS '챌린지 인증 빈도 (0: 매일, 1: 주1일, 2: 주2일, 3: 주3일, 4:주4일, 5:주5일, 6:주6일)';

COMMENT ON COLUMN CHALLENGE.chal_sdate IS '챌린지 시작일';

COMMENT ON COLUMN CHALLENGE.chal_edate IS '챌린지 종료일';

COMMENT ON COLUMN CHALLENGE.chal_fee IS '챌린지 참가비';

COMMENT ON COLUMN CHALLENGE.chal_max IS '참가가능 인원수';

COMMENT ON COLUMN CHALLENGE.chal_rdate IS '챌린지 개설일';

COMMENT ON COLUMN CHALLENGE.chal_ip IS '챌린지 개설자 ip';

ALTER TABLE CHALLENGE ADD CONSTRAINT CHALLENGE_FK1 FOREIGN KEY (
	chal_type
)
REFERENCES CHAL_CATEGORY (
	ccate_num
);

CREATE TABLE CHAL_REVIEW (
	chal_rev_num		number					NOT NULL,
	chal_num			number					NOT NULL,
	mem_num				number					NOT NULL,
	chal_rev_date		date	DEFAULT SYSDATE	NOT NULL,
	chal_rev_mdate		date					NULL,
	chal_rev_content	varchar2(4000)			NOT NULL,
	chal_rev_grade		number(1)				NOT NULL,
	chal_rev_ip			varchar2(40)			NOT NULL
);

COMMENT ON COLUMN CHAL_REVIEW.chal_rev_num IS '후기 고유 번호,sequence 사용';

COMMENT ON COLUMN CHAL_REVIEW.chal_num IS '챌린지 식별 번호,sequence 사용';

COMMENT ON COLUMN CHAL_REVIEW.mem_num IS '챌린지 참여 회원 확인용 회원 고유 번호,sequence 사용';

COMMENT ON COLUMN CHAL_REVIEW.chal_rev_date IS '챌린지 후기 등록일';

COMMENT ON COLUMN CHAL_REVIEW.chal_rev_mdate IS '챌린지 후기 수정일';

COMMENT ON COLUMN CHAL_REVIEW.chal_rev_content IS '후기 내용';

COMMENT ON COLUMN CHAL_REVIEW.chal_rev_grade IS '챌린지 별점(5점 만점)';

COMMENT ON COLUMN CHAL_REVIEW.chal_rev_ip IS '챌린지 후기 작성자 ip';

create table chal_chat_read(
  chal_num number not null,
  chat_id number not null,
  mem_num number not null,
  constraint read_fk foreign key (chal_num) references challenge (chal_num),
  constraint read_fk2 foreign key (chat_id) references chal_chat (chat_id),
  constraint read_fk3 foreign key (mem_num) references member (mem_num)
);

CREATE TABLE chal_verify_rpt(
    report_mem_num   number NOT NULL,
    chal_ver_num     number NOT NULL,
    reported_joi_num number NOT NULL,
    CONSTRAINT chal_rpt1 FOREIGN KEY (report_mem_num) REFERENCES member (mem_num),
    CONSTRAINT chal_rpt2 FOREIGN KEY (chal_ver_num) REFERENCES chal_verify (chal_ver_num),
    CONSTRAINT chal_rpt3 FOREIGN KEY (reported_joi_num) REFERENCES chal_join (chal_joi_num)
);