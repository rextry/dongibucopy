package kr.spring.dbox.vo;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DboxDonationVO {
	private long dbox_do_num;
	private long dbox_num;
	private long mem_num;
	private long dbox_do_price;//기부액
	private int dbox_do_point;//사용포인트(기본:0)
	private String dbox_imp_uid;//포트원 결제id
	private String dbox_do_comment;//기부시 남길 코멘트(기본:'기부합니다.')
	private int dbox_do_status;//결제상태(0:결제완료,1:결제취소)
	private int dbox_do_annony;//익명기부(0:기명,1:익명)
	private Date dbox_do_reg_date;;//기부일
	
	private String mem_nick;
	private String mem_photo;
}