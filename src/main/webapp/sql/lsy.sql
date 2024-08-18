CREATE TABLE CHAL_JOIN (
	chal_joi_num		number							NOT NULL,
	chal_num			number							NOT NULL,
	mem_num				number							NOT NULL,
	dcate_num			number(2)						NOT NULL,
	chal_joi_rate		number(5)						NULL,
	chal_joi_total		number(9)						NULL,
	chal_joi_success	number(9)						NULL,
	chal_joi_refund		number(10)						NULL,
	chal_joi_status		number(1)	DEFAULT 0		NOT NULL,
	chal_joi_date		date		DEFAULT SYSDATE	NOT NULL,
	chal_joi_ip			varchar2(40)				NOT NULL
);
CREATE SEQUENCE CHAL_JOIN_SEQ;

COMMENT ON COLUMN CHAL_JOIN.chal_joi_num IS '챌린지 참가를 식별하는 번호,sequence 사용';

COMMENT ON COLUMN CHAL_JOIN.chal_num IS '챌린지 식별 번호,sequence 사용';

COMMENT ON COLUMN CHAL_JOIN.mem_num IS '챌린지에 참가하는 회원 번호,sequence 사용';

COMMENT ON COLUMN CHAL_JOIN.dcate_num IS '기부 카테고리를 식별하는 번호,sequence 사용';

COMMENT ON COLUMN CHAL_JOIN.chal_joi_rate IS '챌린지 최종 달성 퍼센트';

COMMENT ON COLUMN CHAL_JOIN.chal_joi_total IS '챌린지 최종 달성 퍼센트에 따른 최종 기부액 (challenge 테이블의 chal_fee 컬럼 참고해서 계산)';

COMMENT ON COLUMN CHAL_JOIN.chal_joi_success IS '(1:성공) 챌린지 90%이상 달성 (2:실패) 챌린지 90%미만 달성';

COMMENT ON COLUMN CHAL_JOIN.chal_joi_refund IS '챌린지 완료후의 환급액';

COMMENT ON COLUMN CHAL_JOIN.chal_joi_status IS '챌린지 참가상태 (0:참가중,1:완료,2:취소)';

COMMENT ON COLUMN CHAL_JOIN.chal_joi_date IS '챌린지 참가 날짜';

COMMENT ON COLUMN CHAL_JOIN.chal_joi_ip IS '챌린지 참가자 ip';

ALTER TABLE CHAL_JOIN ADD CONSTRAINT PK_CHAL_JOIN PRIMARY KEY (
	chal_joi_num
);

ALTER TABLE CHAL_JOIN ADD CONSTRAINT FK_CHALLENGE_TO_CHAL_JOIN_1 FOREIGN KEY (
	chal_num
)
REFERENCES CHALLENGE (
	chal_num
);

ALTER TABLE CHAL_JOIN ADD CONSTRAINT FK_MEMBER_TO_CHAL_JOIN_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);
									--너무 길어서 축약
ALTER TABLE CHAL_JOIN ADD CONSTRAINT FK_D_CATE_TO_CHAL_JOIN_1 FOREIGN KEY (
	dcate_num
)
REFERENCES DONA_CATEGORY (
	dcate_num
);

ALTER TABLE CHAL_VERIFY ADD CONSTRAINT FK_CHAL_JOIN_TO_CHAL_VERIFY_1 FOREIGN KEY (
	chal_joi_num
)
REFERENCES CHAL_JOIN (
	chal_joi_num
);


CREATE TABLE CHAL_PAYMENT (
	chal_pay_num		number						NOT NULL,
	chal_joi_num		number						NOT NULL,
	mem_num				number						NOT NULL,
	od_imp_uid			varchar2(17)				NULL,
	chal_pay_price		number(30)					NOT NULL,
	chal_point			number(9)	DEFAULT 0		NOT NULL,
	chal_pay_date		date		DEFAULT SYSDATE	NOT NULL,
	chal_pay_status		number(2)					NOT NULL
);
CREATE SEQUENCE CHAL_PAYMENT_SEQ;

COMMENT ON COLUMN CHAL_PAYMENT.chal_pay_num IS '챌린지 결제를 식별하는 번호,sequence 사용';

COMMENT ON COLUMN CHAL_PAYMENT.chal_joi_num IS '챌린지 참가를 식별하는 번호,sequence 사용';

COMMENT ON COLUMN CHAL_PAYMENT.mem_num IS '회원을 식별하는 번호,sequence 사용';

COMMENT ON COLUMN CHAL_PAYMENT.od_imp_uid IS '포트원 api로 전달받은 결제를 식별하는 id';

COMMENT ON COLUMN CHAL_PAYMENT.chal_pay_price IS '챌린지 결제금액';

COMMENT ON COLUMN CHAL_PAYMENT.chal_point IS '사용된 포인트';

COMMENT ON COLUMN CHAL_PAYMENT.chal_pay_date IS '챌린지 결제날짜';

COMMENT ON COLUMN CHAL_PAYMENT.chal_pay_status IS '챌린지 결제상태(0:결제완료,1:결제취소)';

ALTER TABLE CHAL_PAYMENT ADD CONSTRAINT PK_CHAL_PAYMENT PRIMARY KEY (
	chal_pay_num
);
ALTER TABLE CHAL_PAYMENT ADD CONSTRAINT FK_CHAL_JOIN_TO_CHAL_PAYMENT_1 FOREIGN KEY (
	chal_joi_num
)
REFERENCES CHAL_JOIN (
	chal_joi_num
);
ALTER TABLE CHAL_PAYMENT ADD CONSTRAINT FK_MEMBER_TO_CHAL_PAYMENT_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);