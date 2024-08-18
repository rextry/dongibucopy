-- erdcloud export 기능 이용하여 작성
-- PRIMARY KEY, FOREIGN KEY는 자동 생성, UNIQUE는 추가로 작성한 것
-- FOREIGN KEY 제약조건 중 일부 KEY는 이름이 너무 길어서 임의로 축약함
-- 시퀀스는 자동생성이 안되므로 따로 FUNAL_SEQUENCE.sql 작성 

CREATE TABLE MEMBER (
	mem_num			number						NOT NULL,
	auth_num		number(1)		DEFAULT 1	NOT NULL,
	mem_social_id	varchar2(12)				NULL,
	mem_email		varchar2(50)				NOT NULL,
	mem_nick		varchar2(12)				NOT NULL,
	mem_status		number(1)		DEFAULT 2	NOT NULL,
	mem_reg_type	number(1)					NOT NULL,
	mem_pw			varchar2(100)				NULL
);

COMMENT ON COLUMN MEMBER.mem_num IS '회원을 식별하는 번호,sequence 사용';

COMMENT ON COLUMN MEMBER.auth_num IS '기부등급 식별번호 (1~6),회원등급(1:기부흙,2:기부씨앗,3:기부새싹,4:기부꽃,5:기부나무,6:기부숲) (default 1)';

COMMENT ON COLUMN MEMBER.mem_social_id IS '소셜로그인 시 생기는 고유 아이디,UK';

COMMENT ON COLUMN MEMBER.mem_email IS '이메일(test@test.com 형식으로 입력) , UK';

COMMENT ON COLUMN MEMBER.mem_nick IS '회원의 닉네임 (소셜 로그인시 랜덤 닉네임 부여) UK';

COMMENT ON COLUMN MEMBER.mem_status IS '0: 탈퇴, 1: 정지, 2: 일반, 9: 관리자';

COMMENT ON COLUMN MEMBER.mem_reg_type IS '1:자체회원가입, 2:네이버로그인, 3:카카오로그인';

COMMENT ON COLUMN MEMBER.mem_pw IS '비밀번호 (영문,숫자)혼합 (해시함수로 암호화해서 저장. 소셜 로그인의 경우는 임의로 N 값 주기)';

CREATE TABLE MEMBER_DETAIL (
	mem_num				number								NOT NULL,
	pref_num			number(1)							NULL,
	mem_photo			varchar2(400)						NULL,
	mem_name			varchar2(30)						NULL,
	mem_phone			varchar2(11)						NULL,
	mem_birth			number(6)							NULL,
	mem_date			date			DEFAULT SYSDATE		NULL,
	mem_mdate			date								NULL,
	mem_rcode			varchar2(6)							NOT NULL,
	recommend_status	number(1)							NOT NULL,
	mem_point			number(9)		DEFAULT 0			NOT NULL
);

COMMENT ON COLUMN MEMBER_DETAIL.mem_num IS '회원을 식별하는 번호,  PK이면서FK';

COMMENT ON COLUMN MEMBER_DETAIL.pref_num IS '기부 성향 결과별 고유번호,sequence 사용';

COMMENT ON COLUMN MEMBER_DETAIL.mem_photo IS '회원 프로필 사진';

COMMENT ON COLUMN MEMBER_DETAIL.mem_name IS '회원의 이름';

COMMENT ON COLUMN MEMBER_DETAIL.mem_phone IS '전화번호 (숫자 11자리)';

COMMENT ON COLUMN MEMBER_DETAIL.mem_birth IS '생년월일 (숫자 6자리)';

COMMENT ON COLUMN MEMBER_DETAIL.mem_date IS '회원 가입일 (default sysdate)';

COMMENT ON COLUMN MEMBER_DETAIL.mem_mdate IS '회원 정보 수정일';

COMMENT ON COLUMN MEMBER_DETAIL.mem_rcode IS '추천인 코드 (회원번호 넣어서 랜덤값 부여)';

COMMENT ON COLUMN MEMBER_DETAIL.recommend_status IS '0: 미참여, 1: 참여 (중복참여 방지)';

COMMENT ON COLUMN MEMBER_DETAIL.mem_point IS '회원이 보유한 포인트';

CREATE TABLE DB_AUTH (
	auth_num		number(1)			NOT NULL,
	auth_name		varchar2(30)		NOT NULL,
	auth_icon		varchar2(400)		NOT NULL,
	auth_fee		number(9)			NOT NULL,
	auth_count		number(5)			NOT NULL
);

COMMENT ON COLUMN DB_AUTH.auth_num IS '기부등급 식별번호 (1~6)';

COMMENT ON COLUMN DB_AUTH.auth_name IS '1:기부흙,2:기부씨앗,3:기부새싹,4:기부꽃,5:기부나무,6:기부숲';

COMMENT ON COLUMN DB_AUTH.auth_icon IS '등급별 아이콘';

COMMENT ON COLUMN DB_AUTH.auth_fee IS '(2.씨앗: 10,000, 3.새싹: 100,000, 4.꽃:1,000,000,  5.나무:10,000,000, 6.숲:100,000,000)';

COMMENT ON COLUMN DB_AUTH.auth_count IS '(2.씨앗:5, 3.새싹:10, 4.꽃:30, 5.나무:30, 6.숲:30)';

CREATE TABLE DONA_CATEGORY (
	dcate_num			number(2)			NOT NULL,
	dcate_name			varchar2(20)		NOT NULL,
	dcate_charity		varchar2(20)		NOT NULL,
	dcate_icon			varchar2(400)		NOT NULL,
	dcate_filename		varchar2(400)		NOT NULL,
	dcate_content		varchar2(4000)		NOT NULL
);

COMMENT ON COLUMN DONA_CATEGORY.dcate_num IS '기부 카테고리를 식별하는 번호,sequence 사용';

COMMENT ON COLUMN DONA_CATEGORY.dcate_name IS '기부 카테고리를 나타내는 이름';

COMMENT ON COLUMN DONA_CATEGORY.dcate_charity IS '기부처를 나타내는 이름';

COMMENT ON COLUMN DONA_CATEGORY.dcate_icon IS '기부처 아이콘 파일명';

COMMENT ON COLUMN DONA_CATEGORY.dcate_content IS '기부처 설명';

CREATE TABLE ITEM (
	item_num		number								NOT NULL,
	dcate_num		number(2)							NOT NULL,
	item_name		varchar2(90)						NOT NULL,
	item_photo		varchar2(400)						NOT NULL,
	item_detail		clob								NOT NULL,
	item_price		number(7)							NOT NULL,
	item_stock		number(7)							NOT NULL,
	item_reg_date	date			DEFAULT SYSDATE		NOT NULL,
	item_mdate		date								NULL,
	item_status		number(1)							NOT NULL
);

COMMENT ON COLUMN ITEM.item_num IS '상품을 식별하는 번호,sequence 사용';

COMMENT ON COLUMN ITEM.dcate_num IS '해당 상품의 기부 카테고리 (기부 카테고리 테이블 외래키 참조)';

COMMENT ON COLUMN ITEM.item_name IS '상품명';

COMMENT ON COLUMN ITEM.item_photo IS '상품 썸네일 사진';

COMMENT ON COLUMN ITEM.item_detail IS '상품 설명';

COMMENT ON COLUMN ITEM.item_price IS '상품 가격';

COMMENT ON COLUMN ITEM.item_stock IS '재고';

COMMENT ON COLUMN ITEM.item_reg_date IS '상품 등록 날짜';

COMMENT ON COLUMN ITEM.item_mdate IS '상품을 수정한 날짜';

COMMENT ON COLUMN ITEM.item_status IS '1:표시(판매 가능) 2:미표시(판매 불가능)';

CREATE TABLE GORDER (
	od_uid				varchar2(30)					NOT NULL,
	mem_num				number							NOT NULL,
	ou_total			number(9)						NOT NULL,
	od_point			number(9)		DEFAULT 0		NOT NULL,
	od_donation			number(9)						NOT NULL,
	od_imp_uid			varchar2(17)					NULL,
	od_ship_status		number(1)		DEFAULT 1		NOT NULL,
	od_ship_name		varchar2(30)					NOT NULL,
	od_ship_post		number(5)						NOT NULL,
	od_ship_address1	varchar2(90)					NOT NULL,
	od_ship_address2	varchar2(90)					NOT NULL,
	od_ship_phone		varchar2(15)					NOT NULL,
	od_notice			varchar2(4000)					NULL,
	od_reg_date			date			DEFAULT SYSDATE	NOT NULL,
	od_mdate			date							NULL
);

COMMENT ON COLUMN GORDER.od_uid IS '주문을 식별하는 고유 id,sequence 사용';

COMMENT ON COLUMN GORDER.mem_num IS '주문자 회원번호,sequence 사용';

COMMENT ON COLUMN GORDER.ou_total IS '주문한 총 액수';

COMMENT ON COLUMN GORDER.od_point IS '사용된 포인트';

COMMENT ON COLUMN GORDER.od_donation IS '해당 주문으로 발생한 기부액';

COMMENT ON COLUMN GORDER.od_imp_uid IS '포트원 api로 전달받은 결제 식별 id';

COMMENT ON COLUMN GORDER.od_ship_status IS '1: 상품 준비중, 2: 배송 준비, 3: 배송 중,  4: 배송 완료, 5: 주문 취소';

COMMENT ON COLUMN GORDER.od_ship_name IS '수취인명';

COMMENT ON COLUMN GORDER.od_ship_post IS '배송 우편번호';

COMMENT ON COLUMN GORDER.od_ship_address1 IS '배송 주소';

COMMENT ON COLUMN GORDER.od_ship_address2 IS '배송 상세주소';

COMMENT ON COLUMN GORDER.od_ship_phone IS '수취인 전화번호';

COMMENT ON COLUMN GORDER.od_notice IS '주문 요청사항';

COMMENT ON COLUMN GORDER.od_reg_date IS '주문 날짜';

COMMENT ON COLUMN GORDER.od_mdate IS '주문 수정 날짜';

CREATE TABLE CHAL_CATEGORY (
	ccate_num		number				NOT NULL,
	ccate_name		varchar2(30)		NOT NULL
);

COMMENT ON COLUMN CHAL_CATEGORY.ccate_num IS '자기계발 카테고리 식별번호,sequence 사용';

COMMENT ON COLUMN CHAL_CATEGORY.ccate_name IS '자기계발 항목';

CREATE TABLE DB_POINT_EVENT (
	prevent_type		varchar2(2)		NOT NULL,
	prevent_detail		varchar2(30)	NOT NULL,
	prevent_amount		number(4)		NULL
);

COMMENT ON COLUMN DB_POINT_EVENT.prevent_type IS '10: 추천인 이벤트, 11:챌린지 달성률 90%이상, 12:회원가입 20: 사용 30: 결제취소로 인한 환불 40: 포인트 회수,sequence 사용';

COMMENT ON COLUMN DB_POINT_EVENT.prevent_detail IS '추천인 이벤트, 챌린지 달성률 90% 이상, 회원가입, 결제취소로 인한 환불, 사용, 회수 등';

COMMENT ON COLUMN DB_POINT_EVENT.prevent_amount IS '포인트의 양(point type이 사용이거나 환불일 때는 null)';

CREATE TABLE CHALLENGE (
	chal_num		number						NOT NULL,
	mem_num			number							NOT NULL,
	chal_person		number(1)						NOT NULL,
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
	chal_public		number(1) 		DEFAULT 0		NOT NULL
);

COMMENT ON COLUMN CHALLENGE.chal_num IS '챌린지 식별 번호,sequence 사용';

COMMENT ON COLUMN CHALLENGE.mem_num IS '챌린지를 개설 신청한 리더,sequence 사용';

COMMENT ON COLUMN CHALLENGE.chal_person IS '챌린지 인원 (0:개인,1:단체)';

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

COMMENT ON COLUMN CHALLENGE.chal_rdate IS '챌린지 공개여부 (0:공개, 1:비공개)';

CREATE TABLE DBOX (
	dbox_num				number							NOT NULL,
	mem_num					number							NOT NULL,
	dcate_num				number(2)						NOT NULL,
	dbox_team_type			number(1)						NOT NULL,
	dbox_team_name			varchar2(60)					NOT NULL,
	dbox_team_detail		varchar2(1500)					NOT NULL,
	dbox_team_photo			varchar2(400)					NULL,
	dbox_business_rnum		varchar2(10)					NULL,
	dbox_title				varchar2(150)					NOT NULL,
	dbox_photo				varchar2(400)					NOT NULL,
	dbox_business_plan		varchar2(400)					NOT NULL,
	dbox_budget_data		varchar2(400)					NULL,
	dbox_bank				varchar2(30)					NOT NULL,
	dbox_account			varchar2(20)					NOT NULL,
	dbox_account_name		varchar2(21)					NOT NULL,
	dbox_content			clob							NOT NULL,
	dbox_comment			varchar2(4000)					NULL,
	dbox_goal				number(15)						NOT NULL,
	dbox_sdate				varchar2(50)					NOT NULL,
	dbox_edate				varchar2(50)					NOT NULL,
	dbox_rdate				date			DEFAULT SYSDATE	NOT NULL,
	dbox_status				number(1)		DEFAULT 0		NOT NULL
);

COMMENT ON COLUMN DBOX.dbox_num IS '기부박스 고유 식별 번호,sequence 사용';

COMMENT ON COLUMN DBOX.mem_num IS '회원을 식별하는 번호,sequence 사용';

COMMENT ON COLUMN DBOX.dcate_num IS '기부 카테고리를 식별하는 번호,sequence 사용';

COMMENT ON COLUMN DBOX.dbox_team_type IS '1:기관, 2:개인';

COMMENT ON COLUMN DBOX.dbox_team_name IS '기부박스를 주최하는 팀명';

COMMENT ON COLUMN DBOX.dbox_team_detail IS '기부박스를 주최하는 팀에 대한 설명';

COMMENT ON COLUMN DBOX.dbox_team_photo IS '기부박스 주최팀을 대표하는 사진';

COMMENT ON COLUMN DBOX.dbox_business_rnum IS '기부박스 주최팀의 사업자등록번호. dbox_team_type이 1(기관)일 시 필수 작성';

COMMENT ON COLUMN DBOX.dbox_title IS '기부박스의 제목';

COMMENT ON COLUMN DBOX.dbox_photo IS '썸네일에 보일 이미지의 이름';

COMMENT ON COLUMN DBOX.dbox_business_plan IS '구체적인 사업계획서';

COMMENT ON COLUMN DBOX.dbox_budget_data IS '견적서 등 금액책정의 근거자료';

COMMENT ON COLUMN DBOX.dbox_bank IS '정산받을 계좌의 은행';

COMMENT ON COLUMN DBOX.dbox_account_name IS '정산받을 계좌의 예금주명';

COMMENT ON COLUMN DBOX.dbox_account IS '정산받을 계좌의 계좌번호';

COMMENT ON COLUMN DBOX.dbox_content IS '기부박스를 설명하는 내용';

COMMENT ON COLUMN DBOX.dbox_comment IS '심사위원에게 남길 말';

COMMENT ON COLUMN DBOX.dbox_goal IS '기부박스로 모금할 목표 금액';

COMMENT ON COLUMN DBOX.dbox_sdate IS '기부박스 프로젝트 시작일';

COMMENT ON COLUMN DBOX.dbox_edate IS '기부박스 프로젝트 종료일';

COMMENT ON COLUMN DBOX.dbox_rdate IS '기부박스 등록 신청일';

COMMENT ON COLUMN DBOX.dbox_status IS '0:신청완료(기본값), 1.심사완료, 2:신청반려, 3:진행중, 4:진행완료, 5. 진행중단';

CREATE TABLE SUBSCRIPTION (
	sub_num			number					NOT NULL,
	mem_num			number					NOT NULL,
	dcate_num		number(2)				NOT NULL,
	sub_name		varchar2(45)			NULL,
	sub_annony		number(1)				NOT NULL,
	sub_price		number(9)				NOT NULL,
	sub_ndate		varchar2(10)			NOT NULL,
	sub_status		number(1)	DEFAULT 0	NOT NULL
);



COMMENT ON COLUMN SUBSCRIPTION.sub_num IS '회원이 신청한 정기기부를 식별하는 번호,sequence 사용';

COMMENT ON COLUMN SUBSCRIPTION.mem_num IS '기부신청 회원을 식별하는 번호,sequence 사용';

COMMENT ON COLUMN SUBSCRIPTION.dcate_num IS '회원이 설정한 기부 카테고리를 식별하는 번호,sequence 사용';

COMMENT ON COLUMN SUBSCRIPTION.sub_pay_uid IS '빌링키와 일대일 대응하는 아이디(카드 하나에 1:1 대응),UK';

COMMENT ON COLUMN SUBSCRIPTION.sub_name IS '0:기명, 1:익명';

COMMENT ON COLUMN SUBSCRIPTION.sub_annony IS '0:기명,  1:익명';

COMMENT ON COLUMN SUBSCRIPTION.sub_price IS '정기기부시 납부할 기부금액';

COMMENT ON COLUMN SUBSCRIPTION.sub_ndate IS '다음 정기기부 날짜';

COMMENT ON COLUMN SUBSCRIPTION.sub_status IS '정기기부 종료 여부를 식별하는 번호 (DEFAULT 0, 종료시 1)';

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

COMMENT ON COLUMN CHAL_PAYMENT.chal_pay_num IS '챌린지 결제를 식별하는 번호,sequence 사용';

COMMENT ON COLUMN CHAL_PAYMENT.chal_joi_num IS '챌린지 참가를 식별하는 번호,sequence 사용';

COMMENT ON COLUMN CHAL_PAYMENT.mem_num IS '회원을 식별하는 번호,sequence 사용';

COMMENT ON COLUMN CHAL_PAYMENT.od_imp_uid IS '포트원 api로 전달받은 결제를 식별하는 id';

COMMENT ON COLUMN CHAL_PAYMENT.chal_pay_price IS '챌린지 결제금액';

COMMENT ON COLUMN CHAL_PAYMENT.chal_point IS '사용된 포인트';

COMMENT ON COLUMN CHAL_PAYMENT.chal_pay_date IS '챌린지 결제날짜';

COMMENT ON COLUMN CHAL_PAYMENT.chal_pay_status IS '챌린지 결제상태(0:결제완료,1:결제취소)';

CREATE TABLE POINT_LOG (
	point_num			number					NOT NULL,
	mem_num				number					NOT NULL,
	prevent_type		varchar2(2)				NOT NULL,
	prevent_amount		number(9)				NOT NULL,
	point_date			date	DEFAULT SYSDATE	NOT NULL
);

COMMENT ON COLUMN POINT_LOG.point_num IS '포인트 내역 식별번호,sequence 사용';

COMMENT ON COLUMN POINT_LOG.mem_num IS '회원을 식별하는 번호';

COMMENT ON COLUMN POINT_LOG.prevent_type IS '포인트가 오고 갈때 어떤 형태인지 식별하는 번호(10,11,12,20,30,40...)';

COMMENT ON COLUMN POINT_LOG.prevent_amount IS '포인트의 양(음수의 경우 -, 양수의 경우 +, 0일 경우 0) (db_point_event 테이블의 type과 무관하게 직접 기입)';

COMMENT ON COLUMN POINT_LOG.point_date IS '포인트가 적립/사용/환불된 날짜(default SYSDATE)';

CREATE TABLE DBOX_BUDGET (
	dbox_bud_num	number		NOT NULL,
	dbox_num	number		NOT NULL,
	dbox_bud_purpose	varchar2(150)		NOT NULL,
	dbox_bud_price	number(9)		NOT NULL
);

COMMENT ON COLUMN DBOX_BUDGET.dbox_bud_num IS '예산 사용 계획 고유 식별 번호,sequence 사용';

COMMENT ON COLUMN DBOX_BUDGET.dbox_num IS '기부박스 고유 식별 번호,sequence 사용';

COMMENT ON COLUMN DBOX_BUDGET.dbox_bud_purpose IS '모금액을 어떻게 사용할지 표시';

COMMENT ON COLUMN DBOX_BUDGET.dbox_bud_price IS '해당 목적을 위해 필요한 금액';

CREATE TABLE GORDER_DETAIL (
	od_detail_num		number			NOT NULL,
	od_uid				varchar2(30)	NOT NULL,
	od_item_num			number			NOT NULL,
	od_item_name		varchar2(90)	NOT NULL,
	od_item_price		number(7)		NOT NULL,
	od_item_total		number(9)		NOT NULL,
	od_quantity			number(7)		NOT NULL
);

COMMENT ON COLUMN GORDER_DETAIL.od_detail_num IS '상세 주문을 식별하는 고유 번호,sequence 사용';

COMMENT ON COLUMN GORDER_DETAIL.od_uid IS '주문 식별 고유 id,sequence 사용';

COMMENT ON COLUMN GORDER_DETAIL.od_item_num IS '주문 상품 번호';

COMMENT ON COLUMN GORDER_DETAIL.od_item_name IS '주문 상품명';

COMMENT ON COLUMN GORDER_DETAIL.od_item_price IS '주문 상품 가격';

COMMENT ON COLUMN GORDER_DETAIL.od_item_total IS '주문 상품 총액(해당 상품만)';

COMMENT ON COLUMN GORDER_DETAIL.od_quantity IS '주문 상품 수(해당 상품만)';

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
	chal_joi_date		date		DEFAULT SYSDATE	NOT NULL
);

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

CREATE TABLE CART (
	cart_num			number			NOT NULL,
	item_num			number			NOT NULL,
	mem_num				number			NOT NULL,
	cart_quantity		number(7)		NOT NULL
);

COMMENT ON COLUMN CART.cart_num IS '장바구니를 식별하는 고유 번호,sequence 사용';

COMMENT ON COLUMN CART.item_num IS '상품 식별하는 고유 번호,sequence 사용';

COMMENT ON COLUMN CART.mem_num IS '회원을 식별하는 번호,sequence 사용';

COMMENT ON COLUMN CART.cart_quantity IS '장바구니에 넣은 상품수';

CREATE TABLE CHAL_REVIEW (
	chal_rev_num		number					NOT NULL,
	chal_num			number					NOT NULL,
	mem_num				number					NOT NULL,
	chal_rev_date		date	DEFAULT SYSDATE	NOT NULL,
	chal_rev_mdate		date					NULL,
	chal_rev_content	varchar2(4000)			NOT NULL,
	chal_rev_grade		VARCHAR(255)			NOT NULL
);

COMMENT ON COLUMN CHAL_REVIEW.chal_rev_num IS '후기 고유 번호,sequence 사용';

COMMENT ON COLUMN CHAL_REVIEW.chal_num IS '챌린지 식별 번호,sequence 사용';

COMMENT ON COLUMN CHAL_REVIEW.mem_num IS '챌린지 참여 회원 확인용 회원 고유 번호,sequence 사용';

COMMENT ON COLUMN CHAL_REVIEW.chal_rev_date IS '챌린지 후기 등록일';

COMMENT ON COLUMN CHAL_REVIEW.chal_rev_mdate IS '챌린지 후기 수정일';

COMMENT ON COLUMN CHAL_REVIEW.chal_rev_content IS '후기 내용';

COMMENT ON COLUMN CHAL_REVIEW.chal_rev_grade IS '챌린지 별점(5점 만점)';

CREATE TABLE INQUIRY (
	inquiry_num				number							NOT NULL,
	mem_num					number							NOT NULL,
	inquiry_category		number(1)						NOT NULL,
	inquiry_title			varchar2(50)					NOT NULL,
	inquiry_filename		varchar2(400)					NULL,
	inquiry_content			varchar2(4000)					NOT NULL,
	inquiry_reply			varchar2(4000)					NULL,
	inquiry_date			date			DEFAULT SYSDATE	NOT NULL
);

COMMENT ON COLUMN INQUIRY.inquiry_num IS '문의번호,sequence 사용';

COMMENT ON COLUMN INQUIRY.mem_num IS '유저번호,sequence 사용';

COMMENT ON COLUMN INQUIRY.inquiry_category IS '문의 카테고리 번호(0: 정기기부, 1: 기부박스, 2: 챌린지, 3: 굿즈샵, 4: 기타)';

COMMENT ON COLUMN INQUIRY.inquiry_title IS '문의제목';

COMMENT ON COLUMN INQUIRY.inquiry_filename IS '문의관련 파일첨부 가능';

COMMENT ON COLUMN INQUIRY.inquiry_content IS '문의내용';

COMMENT ON COLUMN INQUIRY.inquiry_reply IS '답변';

COMMENT ON COLUMN INQUIRY.inquiry_date IS '문의를 등록한 날짜';

CREATE TABLE DB_PREFERENCE (
	pref_num		number				NOT NULL,
	pref_result		varchar2(60)		NOT NULL,
	pref_detail		varchar2(4000)		NOT NULL
);

COMMENT ON COLUMN DB_PREFERENCE.pref_num IS '기부 성향조사 결과별 고유번호,sequence 사용';

COMMENT ON COLUMN DB_PREFERENCE.pref_result IS '기부 성향조사 결과';

COMMENT ON COLUMN DB_PREFERENCE.pref_detail IS '기부 성향 조사 결과 설명';

CREATE TABLE CHAL_FAV (
	mem_num			number		NOT NULL,
	chal_num		number		NOT NULL
);

COMMENT ON COLUMN CHAL_FAV.mem_num IS '회원을 식별하는 번호,sequence 사용';

COMMENT ON COLUMN CHAL_FAV.chal_num IS '챌린지 고유 번호,sequence 사용';

CREATE TABLE REPORT (
	report_num			number							NOT NULL,
	mem_num				number							NOT NULL,
	reported_mem_num	number							NOT NULL,
	chal_num			number							NULL,
	chal_rev_num		number							NULL,
	chal_ver_num		number							NULL,
	dbox_re_num			number							NULL,
	report_type			number(1)						NOT NULL,
	report_content		varchar2(4000)					NULL,
	report_filename		varchar2(400)					NULL,
	report_reply		varchar2(4000)					NULL,
	report_status		number(1)						NULL,
	report_date			date			DEFAULT SYSDATE	NOT NULL
);

COMMENT ON COLUMN REPORT.report_num IS '문의번호,sequence 사용';

COMMENT ON COLUMN REPORT.mem_num IS '신고자 회원번호,sequence 사용';

COMMENT ON COLUMN REPORT.reported_mem_num IS '피신고자 회원번호,sequence 사용';

COMMENT ON COLUMN REPORT.chal_num IS '챌린지 고유 번호,sequence 사용';

COMMENT ON COLUMN REPORT.chal_rev_num IS '후기 고유 번호,sequence 사용';

COMMENT ON COLUMN REPORT.chal_ver_num IS '챌린지 인증 고유 번호';

COMMENT ON COLUMN REPORT.dbox_re_num IS '기부박스 댓글의 고유식별번호,sequence 사용';

COMMENT ON COLUMN REPORT.report_type IS '신고신고 종류 (1: 스팸/광고, 2: 폭력/위협, 3:혐오발언/차별, 4:음란물/부적절한 콘텐츠, 5:챌린지 인증) 종류';

COMMENT ON COLUMN REPORT.report_content IS '신고 내용';

COMMENT ON COLUMN REPORT.report_filename IS '신고 내용 관련 파일첨부';

COMMENT ON COLUMN REPORT.report_reply IS '답변';

COMMENT ON COLUMN REPORT.report_status IS '신고 승인 여부(1: 승인, 2: 반려)';

COMMENT ON COLUMN REPORT.report_date IS '신고한 날짜';

CREATE TABLE DBOX_FAV (
	dbox_num	number		NOT NULL,
	mem_num		number		NOT NULL
);

COMMENT ON COLUMN DBOX_FAV.dbox_num IS '기부박스 고유 식별 번호,sequence 사용';

COMMENT ON COLUMN DBOX_FAV.mem_num IS '기부박스 신청한 회원 고유 식별 번호,sequence 사용';

CREATE TABLE DBOX_REPLY (
	dbox_re_num			number							NOT NULL,
	dbox_num			number							NOT NULL,
	mem_num				number							NOT NULL,
	dbox_re_content		varchar2(900)					NOT NULL,
	dbox_re_rdate		date			DEFAULT SYSDATE	NOT NULL,
	dbox_re_mdate		date							NULL,
	dbox_re_ip			varchar2(40)					NOT NULL
);

COMMENT ON COLUMN DBOX_REPLY.dbox_re_num IS '기부박스 댓글의 고유식별번호,sequence 사용';

COMMENT ON COLUMN DBOX_REPLY.dbox_num IS '기부박스 고유 식별 번호,sequence 사용';

COMMENT ON COLUMN DBOX_REPLY.mem_num IS '회원을 식별하는 번호,sequence 사용';

COMMENT ON COLUMN DBOX_REPLY.dbox_re_content IS '댓글 내용 (최대 300자)';

COMMENT ON COLUMN DBOX_REPLY.dbox_re_rdate IS '댓글 등록일';

COMMENT ON COLUMN DBOX_REPLY.dbox_re_mdate IS '댓글 수정일 (수정할 경우만)';

COMMENT ON COLUMN DBOX_REPLY.dbox_re_ip IS '작성자 IP (서버에서 자동등록)';

CREATE TABLE DBOX_DONATION (
	dbox_do_num			number								NOT NULL,
	dbox_num			number								NOT NULL,
	mem_num				number								NOT NULL,
	dbox_do_price		number(15)							NOT NULL,
	dbox_do_point		number(9)		DEFAULT 0			NOT NULL,
	dbox_imp_uid		varchar2(45)						NULL,
	dbox_do_comment		varchar2(300)	DEFAULT '기부합니다.'	NULL,
	dbox_do_status		number(1)							NOT NULL,
	dbox_do_annony		number(1)							NOT NULL,
	dbox_do_reg_date	date			DEFAULT SYSDATE		NOT NULL
);

COMMENT ON COLUMN DBOX_DONATION.dbox_do_num IS '기부신청 고유 식별 번호';

COMMENT ON COLUMN DBOX_DONATION.dbox_num IS '기부박스 고유 식별 번호,sequence 사용';

COMMENT ON COLUMN DBOX_DONATION.mem_num IS '기부박스 신청한 회원 고유 식별 번호,sequence 사용';

COMMENT ON COLUMN DBOX_DONATION.dbox_do_price IS '직접 기부하는 기부금액';

COMMENT ON COLUMN DBOX_DONATION.dbox_do_point IS '사용된 포인트';

COMMENT ON COLUMN DBOX_DONATION.dbox_imp_uid IS '포트원 결제id';

COMMENT ON COLUMN DBOX_DONATION.dbox_do_comment IS '기부 시 남길 코멘트';

COMMENT ON COLUMN DBOX_DONATION.dbox_do_status IS '결제상태 (0:결제완료, 1:결제취소)';

COMMENT ON COLUMN DBOX_DONATION.dbox_do_annony IS '익명 여부 (0:기명, 1:익명)';

CREATE TABLE CHAL_CHAT (
	chat_id			number							NOT NULL,
	chal_num		number							NOT NULL,
	mem_num			number							NOT NULL,
	chat_content	varchar2(900)					NOT NULL,
	chat_filename	varchar2(400)					NULL,
	chat_date		date			DEFAULT SYSDATE	NOT NULL,
	chat_status		number							NOT NULL
);

COMMENT ON COLUMN CHAL_CHAT.chat_id IS '메시지 식별 번호,sequence 사용';

COMMENT ON COLUMN CHAL_CHAT.chal_num IS '챌린지 식별 번호,sequence 사용';

COMMENT ON COLUMN CHAL_CHAT.mem_num IS '메시지 발신 유저번호,sequence 사용';

COMMENT ON COLUMN CHAL_CHAT.chat_content IS '메시지 내용';

COMMENT ON COLUMN CHAL_CHAT.chat_filename IS '전송 사진 파일명';

COMMENT ON COLUMN CHAL_CHAT.chat_date IS '메시지 전송 시간';

COMMENT ON COLUMN CHAL_CHAT.chat_status IS '0 수신, 1 비수신';

CREATE TABLE DBOX_RESULT (
	dbox_num			number			NOT NULL,
	dbox_res_total		number(15)		NOT NULL,
	dbox_res_count		number(10)		NOT NULL,
	dbox_res_report		clob			NULL
);

COMMENT ON COLUMN DBOX_RESULT.dbox_num IS '기부박스 고유 식별 번호,PK이면서FK';

COMMENT ON COLUMN DBOX_RESULT.dbox_res_total IS '기부 총 금액';

COMMENT ON COLUMN DBOX_RESULT.dbox_res_count IS '기부 참여자 수';

COMMENT ON COLUMN DBOX_RESULT.dbox_res_report IS '기부박스 주최자가 작성한 결과보고';

CREATE TABLE CHAL_VERIFY (
	chal_ver_num		number							NOT NULL,
	chal_joi_num		number							NOT NULL,
	mem_num				number							NOT NULL,
	chal_ver_photo		varchar2(400)					NOT NULL,
	chal_ver_status		number(2)		DEFAULT 0		NOT NULL,
	chal_reg_date		date			DEFAULT SYSDATE	NOT NULL,
	chal_ver_report		number(1)		DEFAULT 0		NOT NULL,
	chal_content		varchar2(4000)					NULL
);

COMMENT ON COLUMN CHAL_VERIFY.chal_ver_num IS '챌린지 인증을 식별하는 번호,sequence 사용';

COMMENT ON COLUMN CHAL_VERIFY.chal_joi_num IS '챌린지 참가를 식별하는 번호,sequence 사용';

COMMENT ON COLUMN CHAL_VERIFY.mem_num IS '회원을 식별하는 번호,sequence 사용';

COMMENT ON COLUMN CHAL_VERIFY.chal_ver_photo IS '챌린지 인증사진';

COMMENT ON COLUMN CHAL_VERIFY.chal_ver_status IS '챌린지 인증상태  (0:승인전,1:인증완료,2:인증실패)';

COMMENT ON COLUMN CHAL_VERIFY.chal_reg_date IS '챌린지 인증 업로드 날짜,하루에 중복인증 불가능';

COMMENT ON COLUMN CHAL_VERIFY.chal_ver_report IS '챌린지 신고 여부 (0: 신고 안 됨, 1: 신고됨)';

COMMENT ON COLUMN CHAL_VERIFY.chal_content IS '챌린지 인증시 작성 가능한 한줄평';

CREATE TABLE SUB_PAYMENT (
	sub_pay_num			number					NOT NULL,
	mem_num				number					NOT NULL,
	sub_num				number					NOT NULL,
	sub_price			number(9)				NOT NULL,
	sub_pay_date		date	DEFAULT SYSDATE	NOT NULL,
	sub_pay_status		number(1)				NOT NULL
);

COMMENT ON COLUMN SUB_PAYMENT.sub_pay_num IS '정기기부 결제를 식별하는 번호,sequence 사용';

COMMENT ON COLUMN SUB_PAYMENT.mem_num IS '결제한 회원을 식별하는 번호,sequence 사용';

COMMENT ON COLUMN SUB_PAYMENT.sub_num IS '회원이 신청한 정기기부를 식별하는 번호,sequence 사용';

COMMENT ON COLUMN SUB_PAYMENT.sub_price IS '정기기부시 납부한 기부금액';

COMMENT ON COLUMN SUB_PAYMENT.sub_pay_date IS '결제가 완료된 날짜';

COMMENT ON COLUMN SUB_PAYMENT.sub_pay_status IS '결제상태(0:결제완료, 1:결제취소, 2:결제실패)';

CREATE TABLE FAQ (
    faq_num NUMBER(10) NOT NULL,
    faq_category NUMBER(1) NOT NULL,
    faq_question VARCHAR2(100) NOT NULL,
    faq_answer VARCHAR2(4000) NOT NULL,
    CONSTRAINT PK_FAQ PRIMARY KEY (faq_num)
);

COMMENT ON COLUMN FAQ.faq_num IS 'faq 번호';
COMMENT ON COLUMN FAQ.faq_category IS 'faq 카테고리 번호(0: 정기기부, 1: 기부박스, 2: 챌린지, 3: 굿즈샵, 4: 기타)';
COMMENT ON COLUMN FAQ.faq_question IS 'faq 질문';
COMMENT ON COLUMN FAQ.faq_answer IS 'faq 답변';

--------------------------------------------------------------------------------------------------------------------------PRIMARY KEY
ALTER TABLE MEMBER ADD CONSTRAINT PK_MEMBER PRIMARY KEY (
	mem_num
);

ALTER TABLE MEMBER_DETAIL ADD CONSTRAINT PK_MEMBER_DETAIL PRIMARY KEY (
	mem_num
);

ALTER TABLE DB_AUTH ADD CONSTRAINT PK_DB_AUTH PRIMARY KEY (
	auth_num
);

ALTER TABLE DONA_CATEGORY ADD CONSTRAINT PK_DONA_CATEGORY PRIMARY KEY (
	dcate_num
);

ALTER TABLE ITEM ADD CONSTRAINT PK_ITEM PRIMARY KEY (
	item_num
);

ALTER TABLE GORDER ADD CONSTRAINT PK_GORDER PRIMARY KEY (
	od_uid
);

ALTER TABLE CHAL_CATEGORY ADD CONSTRAINT PK_CHAL_CATEGORY PRIMARY KEY (
	ccate_num
);

ALTER TABLE DB_POINT_EVENT ADD CONSTRAINT PK_DB_POINT_EVENT PRIMARY KEY (
	prevent_type
);

ALTER TABLE CHALLENGE ADD CONSTRAINT PK_CHALLENGE PRIMARY KEY (
	chal_num
);

ALTER TABLE DBOX ADD CONSTRAINT PK_DBOX PRIMARY KEY (
	dbox_num
);

ALTER TABLE SUBSCRIPTION ADD CONSTRAINT PK_SUBSCRIPTION PRIMARY KEY (
	sub_num
);

ALTER TABLE CHAL_PAYMENT ADD CONSTRAINT PK_CHAL_PAYMENT PRIMARY KEY (
	chal_pay_num
);

ALTER TABLE POINT_LOG ADD CONSTRAINT PK_POINT_LOG PRIMARY KEY (
	point_num
);

ALTER TABLE DBOX_BUDGET ADD CONSTRAINT PK_DBOX_BUDGET PRIMARY KEY (
	dbox_bud_num
);

ALTER TABLE GORDER_DETAIL ADD CONSTRAINT PK_GORDER_DETAIL PRIMARY KEY (
	od_detail_num
);

ALTER TABLE CHAL_JOIN ADD CONSTRAINT PK_CHAL_JOIN PRIMARY KEY (
	chal_joi_num
);

ALTER TABLE CART ADD CONSTRAINT PK_CART PRIMARY KEY (
	cart_num
);

ALTER TABLE CHAL_REVIEW ADD CONSTRAINT PK_CHAL_REVIEW PRIMARY KEY (
	chal_rev_num
);

ALTER TABLE INQUIRY ADD CONSTRAINT PK_INQUIRY PRIMARY KEY (
	inquiry_num
);

ALTER TABLE DB_PREFERENCE ADD CONSTRAINT PK_DB_PREFERENCE PRIMARY KEY (
	pref_num
);

ALTER TABLE REPORT ADD CONSTRAINT PK_REPORT PRIMARY KEY (
	report_num
);

ALTER TABLE DBOX_REPLY ADD CONSTRAINT PK_DBOX_REPLY PRIMARY KEY (
	dbox_re_num
);

ALTER TABLE DBOX_DONATION ADD CONSTRAINT PK_DBOX_DONATION PRIMARY KEY (
	dbox_do_num
);

ALTER TABLE CHAL_CHAT ADD CONSTRAINT PK_CHAL_CHAT PRIMARY KEY (
	chat_id
);

ALTER TABLE DBOX_RESULT ADD CONSTRAINT PK_DBOX_RESULT PRIMARY KEY (
	dbox_num
);

ALTER TABLE CHAL_VERIFY ADD CONSTRAINT PK_CHAL_VERIFY PRIMARY KEY (
	chal_ver_num
);

ALTER TABLE SUB_PAYMENT ADD CONSTRAINT PK_SUB_PAYMENT PRIMARY KEY (
	sub_pay_num
);
--------------------------------------------------------------------------------------------------------------------------FOREIGN KEY
ALTER TABLE MEMBER ADD CONSTRAINT FK_DB_AUTH_TO_MEMBER_1 FOREIGN KEY (
	auth_num
)
REFERENCES DB_AUTH (
	auth_num
);

ALTER TABLE MEMBER_DETAIL ADD CONSTRAINT FK_MEMBER_TO_MEMBER_DETAIL_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);
										--너무 길어서 축약
ALTER TABLE MEMBER_DETAIL ADD CONSTRAINT FK_DB_PRETO_MEM_DETAIL_1 FOREIGN KEY (
	pref_num
)
REFERENCES DB_PREFERENCE (
	pref_num
);

ALTER TABLE ITEM ADD CONSTRAINT FK_DONA_CATEGORY_TO_ITEM_1 FOREIGN KEY (
	dcate_num
)
REFERENCES DONA_CATEGORY (
	dcate_num
);

ALTER TABLE GORDER ADD CONSTRAINT FK_MEMBER_TO_GORDER_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);

ALTER TABLE CHALLENGE ADD CONSTRAINT FK_MEMBER_TO_CHALLENGE_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);

ALTER TABLE DBOX ADD CONSTRAINT FK_MEMBER_TO_DBOX_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);

ALTER TABLE DBOX ADD CONSTRAINT FK_DONA_CATEGORY_TO_DBOX_1 FOREIGN KEY (
	dcate_num
)
REFERENCES DONA_CATEGORY (
	dcate_num
);

ALTER TABLE SUBSCRIPTION ADD CONSTRAINT FK_MEMBER_TO_SUBSCRIPTION_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);
									--너무 길어서 축약
ALTER TABLE SUBSCRIPTION ADD CONSTRAINT FK_D_CATE_TO_SUBSCRIPTION_1 FOREIGN KEY (
	dcate_num
)
REFERENCES DONA_CATEGORY (
	dcate_num
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

ALTER TABLE POINT_LOG ADD CONSTRAINT FK_MEMBER_TO_POINT_LOG_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);
									--너무 길어서 축약
ALTER TABLE POINT_LOG ADD CONSTRAINT FK_P_EVENT_TO_PLOG_1 FOREIGN KEY (
	prevent_type
)
REFERENCES DB_POINT_EVENT (
	prevent_type
);

ALTER TABLE DBOX_BUDGET ADD CONSTRAINT FK_DBOX_TO_DBOX_BUDGET_1 FOREIGN KEY (
	dbox_num
)
REFERENCES DBOX (
	dbox_num
);

ALTER TABLE GORDER_DETAIL ADD CONSTRAINT FK_GORDER_TO_GORDER_DETAIL_1 FOREIGN KEY (
	od_uid
)
REFERENCES GORDER (
	od_uid
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

ALTER TABLE CART ADD CONSTRAINT FK_ITEM_TO_CART_1 FOREIGN KEY (
	item_num
)
REFERENCES ITEM (
	item_num
);

ALTER TABLE CART ADD CONSTRAINT FK_MEMBER_TO_CART_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);

ALTER TABLE CHAL_REVIEW ADD CONSTRAINT FK_CHALLENGE_TO_CHAL_REVIEW_1 FOREIGN KEY (
	chal_num
)
REFERENCES CHALLENGE (
	chal_num
);

ALTER TABLE CHAL_REVIEW ADD CONSTRAINT FK_MEMBER_TO_CHAL_REVIEW_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);

ALTER TABLE INQUIRY ADD CONSTRAINT FK_MEMBER_TO_INQUIRY_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);

ALTER TABLE CHAL_FAV ADD CONSTRAINT FK_MEMBER_TO_CHAL_FAV_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);

ALTER TABLE CHAL_FAV ADD CONSTRAINT FK_CHAL_TO_CHAL_FAV_1 FOREIGN KEY (
	chal_num
)
REFERENCES CHALLANGE (
	chal_num
);

ALTER TABLE REPORT ADD CONSTRAINT FK_MEMBER_TO_REPORT_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);

ALTER TABLE REPORT ADD CONSTRAINT FK_MEMBER_TO_REPORT_2 FOREIGN KEY (
	reported_mem_num
)
REFERENCES MEMBER (
	mem_num
);

ALTER TABLE REPORT ADD CONSTRAINT FK_CHALLENGE_TO_REPORT_1 FOREIGN KEY (
	chal_num
)
REFERENCES CHALLENGE (
	chal_num
);

ALTER TABLE REPORT ADD CONSTRAINT FK_CHAL_VER_NUM_TO_REPORT_1 FOREIGN KEY (
	chal_ver_num
)
REFERENCES CHAL_VERIFY (
	chal_ver_num
);

ALTER TABLE REPORT ADD CONSTRAINT FK_CHAL_REVIEW_TO_REPORT_1 FOREIGN KEY (
	chal_rev_num
)
REFERENCES CHAL_REVIEW (
	chal_rev_num
);

ALTER TABLE REPORT ADD CONSTRAINT FK_DBOX_REPLY_TO_REPORT_1 FOREIGN KEY (
	dbox_re_num
)
REFERENCES DBOX_REPLY (
	dbox_re_num
);

ALTER TABLE DBOX_FAV ADD CONSTRAINT FK_DBOX_TO_DBOX_FAV_1 FOREIGN KEY (
	dbox_num
)
REFERENCES DBOX (
	dbox_num
);

ALTER TABLE DBOX_FAV ADD CONSTRAINT FK_MEMBER_TO_DBOX_FAV_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);

ALTER TABLE DBOX_REPLY ADD CONSTRAINT FK_DBOX_TO_DBOX_REPLY_1 FOREIGN KEY (
	dbox_num
)
REFERENCES DBOX (
	dbox_num
);

ALTER TABLE DBOX_REPLY ADD CONSTRAINT FK_MEMBER_TO_DBOX_REPLY_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);

ALTER TABLE DBOX_DONATION ADD CONSTRAINT FK_DBOX_TO_DBOX_DONATION_1 FOREIGN KEY (
	dbox_num
)
REFERENCES DBOX (
	dbox_num
);

ALTER TABLE DBOX_DONATION ADD CONSTRAINT FK_MEMBER_TO_DBOX_DONATION_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);

ALTER TABLE CHAL_CHAT ADD CONSTRAINT FK_CHALLENGE_TO_CHAL_CHAT_1 FOREIGN KEY (
	chal_num
)
REFERENCES CHALLENGE (
	chal_num
);

ALTER TABLE CHAL_CHAT ADD CONSTRAINT FK_MEMBER_TO_CHAL_CHAT_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);

ALTER TABLE DBOX_RESULT ADD CONSTRAINT FK_DBOX_TO_DBOX_RESULT_1 FOREIGN KEY (
	dbox_num
)
REFERENCES DBOX (
	dbox_num
);

ALTER TABLE CHAL_VERIFY ADD CONSTRAINT FK_CHAL_JOIN_TO_CHAL_VERIFY_1 FOREIGN KEY (
	chal_joi_num
)
REFERENCES CHAL_JOIN (
	chal_joi_num
);

ALTER TABLE CHAL_VERIFY ADD CONSTRAINT FK_MEMBER_TO_CHAL_VERIFY_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);

ALTER TABLE SUB_PAYMENT ADD CONSTRAINT FK_MEMBER_TO_SUB_PAYMENT_1 FOREIGN KEY (
	mem_num
)
REFERENCES MEMBER (
	mem_num
);
									--너무 길어서 축약
ALTER TABLE SUB_PAYMENT ADD CONSTRAINT FK_SUBSC_TO_SUB_PAY_1 FOREIGN KEY (
	sub_num
)
REFERENCES SUBSCRIPTION (
	sub_num
);
--------------------------------------------------------------------------------------------------------------------------UNIQUE
ALTER TABLE MEMBER ADD CONSTRAINT UK_MEMBER_1 UNIQUE (
	 mem_social_id
);
ALTER TABLE MEMBER ADD CONSTRAINT UK_MEMBER_2 UNIQUE (
	mem_email
);
ALTER TABLE MEMBER ADD CONSTRAINT UK_MEMBER_3 UNIQUE (
	mem_nick
);
ALTER TABLE SUBSCRIPTION ADD CONSTRAINT UK_SUBSCRIPTION UNIQUE (
	sub_pay_uid
);
