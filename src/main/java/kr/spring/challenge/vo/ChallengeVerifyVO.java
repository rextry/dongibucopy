package kr.spring.challenge.vo;

import java.sql.Date;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class ChallengeVerifyVO {
    private long chal_ver_num;
    @NotNull
    private long chal_joi_num;
    @NotNull
    private long mem_num;
    private String chal_content;
    @NotNull
    private MultipartFile upload; 		//파일 업로드를 위한 필드
    private String chal_ver_photo; 		//파일명
    @NotNull
    private int chal_ver_status = 0; 	//기본값:0 (인증완료)
    @NotNull
    private int chal_ver_report = 0;	//기본값:0 (신고안됨)
    private Date chal_reg_date;
    
    //추가 멤버 필드
    private long chal_num;
    private int reported_num;           //인증의 제보된 수

}