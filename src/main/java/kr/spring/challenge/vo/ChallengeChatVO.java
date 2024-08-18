package kr.spring.challenge.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class ChallengeChatVO {
	private long chat_id;
	private long chal_num;
	private long mem_num;
	private String chat_content;
	private MultipartFile upload;
	private String chat_filename;
	private String chat_date;
	
	//추가 외부 필드
	private String mem_nick;
	private String mem_photo;
	private int chat_readCount;
}
