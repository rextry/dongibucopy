package kr.spring.member.vo;

import java.sql.Date;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Pattern;

import org.springframework.web.multipart.MultipartFile;

import kr.spring.config.validation.ValidationGroups;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberVO {
	private Long mem_num;
	private Integer auth_num;
	private String mem_social_id;
	@NotBlank(groups = ValidationGroups.NotNullGroup.class)
	@Email(groups = ValidationGroups.TypeCheckGroup.class)
	private String mem_email;
	@NotBlank(groups = ValidationGroups.NotNullGroup.class)
	private String mem_nick;
	private Integer mem_status;
	private Integer mem_reg_type;
	@NotBlank(groups = ValidationGroups.NotNullGroup.class)
	@Pattern(regexp = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,12}$", groups = ValidationGroups.PatternCheckGroup.class)
	private String mem_pw;

	private Integer pref_num;
	private String mem_photo;
	private String mem_name;
	private String mem_phone;
	private String mem_birth;
	private Date mem_date;
	private Date mem_mdate;
	private String mem_rcode;
	private String friend_rcode;
	private Integer recommend_status;
	private int mem_point;
	
	private MultipartFile upload;
	
	public boolean isCheckedPassword(String user_pw) {
		if (user_pw.equals(mem_pw)) {
			return true;
		}
		return false;
	}

}
