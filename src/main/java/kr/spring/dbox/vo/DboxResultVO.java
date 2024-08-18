package kr.spring.dbox.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DboxResultVO {
	private long dbox_num;
	private long dbox_res_total;//기부 총 금액
	private int dbox_res_count;//기부 총 참여자수
	private String dbox_res_report;//결과보고
}