-- 알림 테이블

-- DB_NOTIFY_TEMPLATE 테이블 생성
CREATE TABLE DB_NOTIFY_TEMPLATE (
    notify_type NUMBER(3) PRIMARY KEY,              -- 알림 종류, 기본키
    notify_template VARCHAR2(500) NOT NULL          -- 알림 템플릿
);

-- NOTIFY_LOG 테이블 생성
CREATE TABLE NOTIFY_LOG (
    not_num NUMBER PRIMARY KEY,                     -- 알림번호, 기본키
    mem_num NUMBER NOT NULL,                        -- 회원번호, 외래키
    target_mem_num NUMBER,                          -- 알림 발생시킨 회원번호, 외래키
    notify_type NUMBER(3) NOT NULL,                 -- 알림 종류, 외래키
    not_message VARCHAR2(400) NOT NULL,             -- 알림 내용
    not_url VARCHAR2(100),                          -- 알림 클릭시 이동할 주소
    not_datetime DATE DEFAULT SYSDATE NOT NULL,     -- 알림 발생 일시
    not_read_datetime DATE,                         -- 알림 확인 일시
    CONSTRAINT fk_notify_type FOREIGN KEY (notify_type) REFERENCES DB_NOTIFY_TEMPLATE(notify_type)
);

INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (1, '''{chalTitle}'' 챌린지에서 인증을 완료해주세요.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (2, '챌린지 ''{chalTitle}''이(가) 종료되었습니다. 참여해 주셔서 감사합니다.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (3, '챌린지 ''{chalTitle}''이(가) 개설되었습니다.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (4, '{memNick}님이 ''{chalTitle}'' 챌린지에 참가하셨습니다.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (5, '''{chalTitle}'' 챌린지에 후기가 등록되었습니다.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (6, '기부박스 ''{dboxTitle}''이(가) 등록 신청되었습니다.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (7, '기부박스 ''{dboxTitle}''의 심사가 완료되었습니다. 심사 결과를 확인해주세요.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (8, '기부박스 ''{dboxTitle}''의 모금이 시작되었습니다.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (9, '기부박스 ''{dboxTitle}''이(가) 종료되었습니다. 참여해주셔서 감사합니다.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (10, '기부박스 ''{dboxTitle}''의 결과보고를 등록해주세요.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (11, '기부박스 ''{dboxTitle}''의 결과보고가 등록되었습니다.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (12, '''{dcateName}'' 카테고리의 정기기부 신청이 완료되었습니다. 감사합니다.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (13, '''{dcateName}'' 카테고리의 정기기부 결제가 하루 앞으로 다가왔습니다. 계좌를 확인해 주세요.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (14, '''{dcateName}'' 카테고리의 정기기부 결제가 성공적으로 완료되었습니다. 감사의 마음을 전합니다.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (15, '잔액이 부족하여 ''{dcateName}'' 카테고리 정기기부 결제가 실패했습니다. 계좌를 확인해주세요');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (16, '굿즈샵에서 주문이 접수되었습니다. 주문 번호: {odUid}. 곧 배송이 시작됩니다.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (17, '굿즈샵에서 주문이 취소되었습니다. 주문 번호: {odUid}.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (18, '굿즈샵에서 주문의 배송이 시작되었습니다. 주문 번호: {odUid}.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (19, '굿즈샵에서 주문이 배송 완료되었습니다. 주문 번호: {odUid}. 감사합니다!');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (20, '축하합니다! {authName} 등급이 되었습니다.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (21, '신고 번호 ''{reportNum}''번에 대한 답변이 등록되었습니다.');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (22, '''{pointAmount}'' 포인트가 적립되었습니다. [{peventDetail}]');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (23, '''{pointAmount}'' 포인트가 사용되었습니다. [{peventDetail}]');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (24, '''{pointAmount}'' 포인트가 환불되었습니다. [{peventDetail}]');
INSERT INTO DB_NOTIFY_TEMPLATE (notify_type, notify_template) VALUES (25, '문의 ''{inquiryTitle}''에 대한 답변이 등록되었습니다.');

CREATE SEQUENCE not_seq;