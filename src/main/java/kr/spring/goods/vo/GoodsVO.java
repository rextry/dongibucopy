package kr.spring.goods.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import java.sql.Date;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotEmpty;

import org.springframework.web.multipart.MultipartFile;


@Getter
@Setter
@ToString
public class GoodsVO {
private Long item_status = 0L; // 기본 값을 0으로 설정
private long item_num; //상품번호
private Long dcate_num;	//카테고리 고유번호
@NotBlank
private String item_name;
private String item_photo;
@NotBlank
private String item_detail;
private Long item_price;
private Long item_stock;
private Date item_reg_date;
private Date item_mdate;
private MultipartFile upload;
}