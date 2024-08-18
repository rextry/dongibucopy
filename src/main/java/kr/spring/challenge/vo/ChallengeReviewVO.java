package kr.spring.challenge.vo;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class ChallengeReviewVO {
    
    private long chal_rev_num;  	// 챌린지 후기번호
    private long chal_num;  		// 챌린지번호
    private long mem_num;  			// 회원번호
    private String chal_rev_ip;  	// ip
    private Date chal_rev_date;  	// 후기 등록일
    private Date chal_rev_mdate;  	// 수정일
    private int chal_rev_grade;  	// 챌린지 별점
    private String chal_rev_content;// 후기 내용
    
    private String mem_nick;  		// 회원 닉네임
    private String mem_photo;  		// 회원 프로필 사진
}