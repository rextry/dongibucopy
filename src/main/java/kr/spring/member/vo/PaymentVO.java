package kr.spring.member.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PaymentVO {
	private int type;
	private String payment_id;
	private String id;
	private String mem_num;
	private String price;
	private String donation;
	private String point;
	private String status;
	private String pay_date;
	private String ref;
}