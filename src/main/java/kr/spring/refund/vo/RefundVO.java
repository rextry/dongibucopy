package kr.spring.refund.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class RefundVO {
	private long refund_num;
	private long mem_num;
	private int payment_type;
	private String imp_uid;
	private int amount;
	private int reason;
	private String reason_other;
	private int return_point;
	private String reg_date;
	private String refund_date;
	private int refund_status;
	private long id;
}
