package kr.spring.member.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberTotalVO {
	long mem_num;
	int mem_point;
	int total_count;
	long total_amount;
}
