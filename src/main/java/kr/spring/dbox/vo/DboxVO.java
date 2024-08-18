package kr.spring.dbox.vo;

import java.sql.Date;
import java.util.List;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DboxVO {
	private long dbox_num;							//제안 완료시 - 시퀀스
	private long mem_num;							//제안 완료시 - session에서 불러오기
	@Min(value = 1)
	private long dcate_num;				//STEP1 - 카테고리 선택
	@Min(value = 1, groups=DboxValidationGroup_2.class)
	private int dbox_team_type;				//STEP2 - 1:기관, 2:개인/단체
	@NotBlank(groups=DboxValidationGroup_2.class)
	private String dbox_team_name;			//STEP2 - 팀명(60byte)
	@NotBlank(groups=DboxValidationGroup_2.class)
	private String dbox_team_detail;		//STEP2 - 팀설명(1500byte)
	private String dbox_team_photo;			//STEP2 - 팀사진)
	@Pattern(regexp="^[0-9]{10}$")
	private String dbox_business_rnum;		//STEP2 - 사업자번호(10자)
	@NotBlank(groups=DboxValidationGroup_3.class)
	private String dbox_title;					//STEP3 - 기부박스 제목(150byte)
	private String dbox_photo;					//STEP3 - 기부박스 대표이미지
	@NotBlank(groups=DboxValidationGroup_3.class)
	private String dbox_content;				//STEP3 - 기부박스 내용
	private String dbox_business_plan;		//STEP2 - 사업계획서
	private String dbox_budget_data;		//STEP2 - 금액책정 근거자료
	@NotEmpty(groups=DboxValidationGroup_2.class)
	private String dbox_bank;				//STEP2 - 은행
	@Pattern(regexp="^[0-9]{6,20}$", groups=DboxValidationGroup_2.class)
	private String dbox_account;			//STEP2 - 계좌번호(최대20자)
	@NotBlank(groups=DboxValidationGroup_2.class)
	private String dbox_account_name;		//STEP2 - 예금주명 
	private String dbox_comment;			//STEP2 - 남길말(4000byte)
	private long dbox_goal;					//STEP2 - 목표금액
	@NotEmpty(groups=DboxValidationGroup_2.class)
	private String dbox_sdate;				//STEP2 - 시작일
	@NotEmpty(groups=DboxValidationGroup_2.class)
	private String dbox_edate;				//STEP2 - 종료일
	private Date dbox_rdate;						//제안 완료시 - 신청등록일
	private int dbox_status;						//제안 완료시 - 0:신청완료,1:심사완료,2:신청반려,3:진행중,4:진행완료,5:진행중단
	private String dbox_acomment;
	
	//파일처리
	private MultipartFile dbox_team_photo_file;
	@NotNull(groups=DboxValidationGroup_2.class)
	private MultipartFile dbox_business_plan_file;	
	private MultipartFile dbox_budget_data_file;
	@NotNull(groups=DboxValidationGroup_3.class)
	private MultipartFile dbox_photo_file;
	
	//기부액 사용계획
	private DboxBudgetVO dboxBudget;
	
	private List<DboxBudgetVO> dboxBudgets;
	
	//카테고리
	private String dcate_name;
	private String dcate_icon;
	
	//기부 총합
	private long total;
}