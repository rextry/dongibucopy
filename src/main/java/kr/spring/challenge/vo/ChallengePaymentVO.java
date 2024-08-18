package kr.spring.challenge.vo;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class ChallengePaymentVO {
	
	private long chal_pay_num;      // 챌린지 결제 번호
    private long chal_joi_num;      // 챌린지 참가 번호
    private long mem_num;           // 회원 번호
    private String od_imp_uid;      // 포트원 결제 id
    private int chal_pay_price;    // 결제 금액
    private int chal_point;        // 사용된 포인트
    private Date chal_pay_date;     // 결제 날짜
    private int chal_pay_status;    // 결제 상태 (0:결제완료, 1:결제취소)
    private long chal_num;			// 챌린지 번호
}
