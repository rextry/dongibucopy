package kr.spring.cs.vo;

import java.sql.Date;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReportVO {
	private long report_num;
	private long mem_num;
	private long reported_mem_num;
	@NotNull
	private Integer report_type;
	@NotBlank
	private String report_content;
	private String report_filename;
	private String report_reply;
	private Date report_rdate;
	private Integer report_status;
	private Date report_date;
	
	private String mem_nick;
	private String reported_mem_nick;
	private int reported_mem_status;

	private Integer report_source;
	private Long chal_num;
	private Long chal_rev_num;
	private Long dbox_re_num;
	
	private MultipartFile upload;
}
