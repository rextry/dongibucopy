package kr.spring.member.service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletContext;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import kr.spring.member.vo.EmailMessageVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmailService{

    private final JavaMailSender javaMailSender;
    
    public void sendMail(EmailMessageVO emailMessage, String type) {

        MimeMessage mimeMessage = javaMailSender.createMimeMessage();

        try {
            MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
            mimeMessageHelper.setTo(emailMessage.getTo()); // 메일 수신자
            mimeMessageHelper.setSubject(emailMessage.getSubject()); // 메일 제목
            mimeMessageHelper.setText(emailMessage.getMessage(), true); // true를 사용하여 HTML 형식으로 설정

            javaMailSender.send(mimeMessage);

            log.debug("<<메일 발송 success>>");


        } catch (MessagingException e) {
        	log.debug("<<메일 발송 fail>>");
            throw new RuntimeException(e);
        }
    }
    
}