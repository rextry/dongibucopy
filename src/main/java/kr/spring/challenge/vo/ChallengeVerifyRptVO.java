package kr.spring.challenge.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class ChallengeVerifyRptVO {
	private long report_mem_num;
	private long chal_ver_num;
	private long reported_joi_num;
}
