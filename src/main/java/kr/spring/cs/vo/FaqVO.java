package kr.spring.cs.vo;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class FaqVO {
	private long faq_num;
	private int faq_category;
	private String faq_question;
	private String faq_answer;
	
    public FaqVO(int faq_category, String faq_question, String faq_answer) {
        this.faq_category = faq_category;
        this.faq_question = faq_question;
        this.faq_answer = faq_answer;
    }
    public FaqVO(long faq_num, String faq_question, String faq_answer) {
    	this.faq_num = faq_num;
    	this.faq_question = faq_question;
    	this.faq_answer = faq_answer;
    }
}
