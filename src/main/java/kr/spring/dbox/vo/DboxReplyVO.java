package kr.spring.dbox.vo;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DboxReplyVO {
	private int dbox_re_num;
	private long dbox_num;
	private long mem_num;
	private String dbox_re_content;
	private Date dbox_re_rdate;
	private Date dbox_re_mdate;
	private String dbox_re_ip;
}
