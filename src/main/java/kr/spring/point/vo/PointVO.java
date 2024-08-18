package kr.spring.point.vo;


import java.sql.Date;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class PointVO {
	public long point_num;
	public long mem_num;
	public int pevent_type;
	public int point_amount;
	public String pevent_detail;
	public Date point_date;
	
	public PointVO(int pevent_type, int point_amount) {
		super();
		this.pevent_type = pevent_type;
		this.point_amount = point_amount;
	}
	
	public PointVO(int pevent_type, int point_amount, long mem_num) {
		super();
		this.pevent_type = pevent_type;
		this.point_amount = point_amount;
		this.mem_num = mem_num;
	}
}