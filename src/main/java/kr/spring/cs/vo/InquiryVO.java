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
public class InquiryVO {
	private Long inquiry_num;			//문의번호
	private long mem_num;				//회원번호
	@NotNull
	private Integer inquiry_category;	//문의카테고리(0: 정기기부, 1: 기부박스, 2: 챌린지, 3: 굿즈샵, 4: 기타)
	@NotBlank
	private String inquiry_title;		//문의제목
	private String inquiry_filename;	//첨부파일
	@NotBlank
	private String inquiry_content;		//문의내용
	private String inquiry_reply;		//문의답변
	private Date inquiry_date;			//문의날짜
	private Date inquiry_rdate;			//답변날짜
	
	private MultipartFile upload;	//파일
	private String file_deleted;
	
	private String mem_nick;
	private String mem_email;
}
