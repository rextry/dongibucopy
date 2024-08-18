package kr.spring.notify.service;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.spring.notify.dao.NotifyMapper;
import kr.spring.notify.vo.NotifyVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class NotifyServiceImpl implements NotifyService {
	
	@Autowired
	NotifyMapper notifyMapper;

	@Override
	public void insertNotifyLog(NotifyVO notifyVO, Map<String, String> dynamicValues) {
		String notifyMessage = generateNotifyMessage(notifyVO, dynamicValues);
		notifyVO.setNot_message(notifyMessage);
		notifyMapper.insertNotifyLog(notifyVO);
	}

	@Override
	public List<NotifyVO> selectNotListByMemNum(long mem_num) {
		return notifyMapper.selectNotListByMemNum(mem_num);
	}
	
	@Override
	public int countUnreadNot(long mem_num) {
		return notifyMapper.countUnreadNot(mem_num);
	}

	@Override
	public void readNotifyLog(long not_num) {
		notifyMapper.readNotifyLog(not_num);
	}
	
	//알림 메시지 생성
	private String generateNotifyMessage(NotifyVO notifyVO, Map<String, String> dynamicValues) {
        // 알림 종류에 맞는 템플릿 조회
        String template = notifyMapper.selectNotifyTemplate(notifyVO.getNotify_type());
        
        log.debug("<<알림 템플릿>> : " + template);

        // 동적 변수 치환
        for (Map.Entry<String, String> entry : dynamicValues.entrySet()) {
        	log.debug("<<key>> : " + entry.getKey());
        	log.debug("<<value>> : " + entry.getValue());
            template = template.replace("{" + entry.getKey() + "}", entry.getValue());
        }

        return template;
    }

}
