-- 추천인 이벤트로 포인트 적립
INSERT INTO point_event (pevent_type, pevent_detail, pevent_amount)
VALUES (1, '추천인 이벤트', 3000);

-- 챌린지 달성률 90% 이상으로 포인트 적립
INSERT INTO point_event (pevent_type, pevent_detail)
VALUES (11, '챌린지 달성률 90% 이상');

-- 회원가입으로 포인트 적립
INSERT INTO point_event (pevent_type, pevent_detail, pevent_amount)
VALUES (12, '회원가입', 1000);

-- 챌린지 포인트 결제로 포인트 사용
INSERT INTO point_event (pevent_type, pevent_detail)
VALUES (20, '챌린지 포인트 결제');

-- 기부박스 포인트 결제로 포인트 사용
INSERT INTO point_event (pevent_type, pevent_detail)
VALUES (21, '기부박스 포인트 결제');

-- 굿즈샵 포인트 결제로 포인트 사용
INSERT INTO point_event (pevent_type, pevent_detail)
VALUES (22, '굿즈샵 포인트 결제');

-- 결제취소로 인한 포인트 환불
INSERT INTO point_event (pevent_type, pevent_detail)
VALUES (30, '결제취소로 인한 환불');

-- 포인트 회수
INSERT INTO point_event (pevent_type, pevent_detail)
VALUES (40, '포인트 회수');