package kr.spring.payuid.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PayuidVO {
	private String pay_uid;
	private long mem_num;
	private String card_nickname;
	private String easypay_method;
	private String sub_method;
}
