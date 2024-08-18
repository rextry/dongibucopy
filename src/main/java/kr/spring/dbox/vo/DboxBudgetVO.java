package kr.spring.dbox.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DboxBudgetVO {
	private String dbox_bud_purpose;
	private long dbox_bud_price;
	
	private long dbox_num;
}