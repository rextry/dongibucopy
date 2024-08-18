package kr.spring.notify.vo;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class NotifyVO {
	private long not_num;
	private long mem_num;
	private int notify_type;
	private String not_message;
	private String	not_url;
	private String not_datetime;
	private Date not_read_datetime;
}
