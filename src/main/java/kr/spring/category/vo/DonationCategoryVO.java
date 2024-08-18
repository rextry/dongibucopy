package kr.spring.category.vo;

import javax.validation.constraints.NotBlank;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DonationCategoryVO {
    private long dcate_num;
    
    @NotBlank
    private String dcate_name;
    
    @NotBlank
    private String dcate_charity;
    
    private String dcate_icon;
    
    @NotBlank
    private String dcate_content;
    
    private String dcate_banner;
    
    private MultipartFile iconUpload;    // 아이콘 파일
    private MultipartFile bannerUpload;  // 배너 파일
}
