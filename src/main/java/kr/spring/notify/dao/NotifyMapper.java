package kr.spring.notify.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import kr.spring.notify.vo.NotifyVO;

@Mapper
public interface NotifyMapper {
	/*---------------------------------------
				알림
	---------------------------------------*/
	//알림 log 찍기
	public void insertNotifyLog(NotifyVO notifyVO);
	//알림 목록(안 읽은 것, 최근 2주)
	public List<NotifyVO> selectNotListByMemNum(long mem_num);
	//안 읽은 알림 유무 검색
	@Select("SELECT COUNT(*) FROM notify_log WHERE not_read_datetime IS NULL AND mem_num=#{mem_num}")
	public int countUnreadNot(long mem_num);
	//알림 확인
	@Update("UPDATE notify_log SET not_read_datetime = SYSDATE WHERE not_num=#{not_num}")
	public void readNotifyLog(long not_num);
	//알림 템플릿 가져오기
	@Select("SELECT notify_template FROM db_notify_template WHERE notify_type=#{notify_type}")
	public String selectNotifyTemplate(int notify_type);
	public void insertNotifyLog(NotifyVO notifyVO, Map<String, String> dynamicValues);
}
