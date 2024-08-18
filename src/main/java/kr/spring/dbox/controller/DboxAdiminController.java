package kr.spring.dbox.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import com.google.gson.Gson;

import kr.spring.dbox.service.DboxService;
import kr.spring.dbox.vo.DboxBudgetVO;
import kr.spring.dbox.vo.DboxDonationVO;
import kr.spring.dbox.vo.DboxVO;
import kr.spring.member.service.MemberService;
import kr.spring.member.vo.MemberTotalVO;
import kr.spring.member.vo.MemberVO;
import kr.spring.notify.service.NotifyService;
import kr.spring.notify.vo.NotifyVO;
import kr.spring.point.vo.PointVO;
import kr.spring.refund.vo.RefundVO;
import kr.spring.subscription.service.SubscriptionService;
import kr.spring.subscription.vo.GetTokenVO;
import kr.spring.util.PagingUtil;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class DboxAdiminController {
	@Autowired
	private DboxService dboxService;
	@Autowired
	NotifyService notifyService;
	@Autowired
	SubscriptionService subscriptionService;
	@Autowired
	MemberService memberService;

    /*===================================
     * 		기부박스 관리
     *==================================*/
    @GetMapping("/admin/dboxAdmin")
    public String dboxAdmin(@RequestParam(defaultValue = "1") int pageNum,
							@RequestParam(defaultValue = "1") int order,
							@RequestParam(defaultValue = "") List<Integer> status,
							@RequestParam(required = false) String keyfield,
							@RequestParam(required = false) String keyword,
							HttpSession session,Model model) {
    	log.debug("<<관리자 페이지 - 기부박스 관리 진입>>");

		log.debug("<<관리자 목록 - pageNum : >>" + pageNum);
		log.debug("<<관리자 목록 - order : >>" + order);
		log.debug("<<관리자 목록 - status : >>" + status);
		log.debug("<<관리자 목록 - keyfield : >>" + keyfield);
		log.debug("<<관리자 목록 - keyword : >>" + keyword);
		
		Map<String, Object> map = new HashMap<String, Object>();
		if (keyword != null && keyword.equals("")) {
			keyword = null;
		}
		// StringBuilder를 사용하여 문자열을 구성
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < status.size(); i++) {
            sb.append(status.get(i));
            if (i < status.size() - 1) {
                sb.append(",");
            }
        }

        // StringBuilder의 내용을 String으로 변환
        String statusValue = sb.toString();
        log.debug("<<관리자 목록 - statusValue : >>" + statusValue);
		
		map.put("keyfield", keyfield);
		map.put("keyword", keyword);
		map.put("order", order);
		map.put("statusValue", statusValue);
		
		//전체, 검색 레코드수
		int count = dboxService.selectAdminListCount(map);

		//페이지 처리
		PagingUtil page = new PagingUtil(keyfield, keyword, pageNum, count, 10, 10, "dboxAdmin", "&order=" + order);

		List<DboxVO> list = null;
		if (count > 0) {
			map.put("start", page.getStartRow());
			map.put("end", page.getEndRow());

			list = dboxService.selectAdminList(map);
		}

		model.addAttribute("count", count);
		model.addAttribute("list", list);
		model.addAttribute("page", page.getPage());
    	
        return "dboxAdmin";
    }
    /*===================================
     * 		기부박스 상태 관리
     *==================================*/
    @GetMapping("/admin/dboxAdminStatus/{dboxNum}")
	public String statusAdmin(@PathVariable long dboxNum,Model model) {
		log.debug("<<관리자 기부박스 상태관리 - dbox_num>> : "+ dboxNum);
    	
    	//기부박스 및 모금계획 불러오기
    	DboxVO dbox = dboxService.selectDbox(dboxNum);
    	List<DboxBudgetVO> dboxBudget = dboxService.selectDboxBudgets(dboxNum);
    	
    	//멤버정보
    	MemberVO member = memberService.selectMemberDetail(dbox.getMem_num());
    	MemberTotalVO memberTotal = memberService.selectMemberTotal(member.getMem_num());
    	
    	log.debug("<<관리자 기부박스 상태관리 - Dbox>> : " + dbox);
    	log.debug("<<관리자 기부박스 상태관리 - DboxBudget>> : " + dboxBudget);
    	log.debug("<<관리자 기부박스 상태관리 - member>> : " + member);
		log.debug("<<관리자 기부박스 상태관리 - memberTotal>> : " + memberTotal);	

    	//뷰에 전달
    	model.addAttribute("member",member);
    	model.addAttribute("memberTotal", memberTotal);
    	model.addAttribute("dbox",dbox);
    	model.addAttribute("dboxTotal",dboxService.selecDoantionTotal(dboxNum));
    	model.addAttribute("dboxBudget",dboxBudget);
    	
    	return "dboxAdminStatus";
    }
    /*===================================
     * 		기부박스 상태 변경
     *==================================*/
    @GetMapping("/admin/dboxAdminStatus/Change")
    public String statusChange(long dbox_num,int dbox_status,String reject) {
    	log.debug("<<기부박스 상태 관리 - 기부박스 번호>> : " + dbox_num);
    	log.debug("<<기부박스 상태 관리 - 기부박스 변경상태>> : " + dbox_status);
    	log.debug("<<기부박스 상태 관리 - 반려/중단 사유>> : " + reject);
    	
    	DboxVO dbox = dboxService.selectDbox(dbox_num);
    	
    	dboxService.updateDboxStatus(dbox_num, dbox_status);
    	//알림
    	if(dbox_status <= 2) {//1 : 심사완료 / 2 : 신청반려
			NotifyVO notifyVO = new NotifyVO();
			notifyVO.setMem_num(dbox.getMem_num());
			notifyVO.setNotify_type(7); 
			notifyVO.setNot_url("/dbox/myPage/dboxMyPropose");
			
			Map<String, String> dynamicValues = new HashMap<String, String>();
			dynamicValues.put("dboxTitle", dbox.getDbox_title());
			
			notifyService.insertNotifyLog(notifyVO, dynamicValues);
    	}
    	
    	if(dbox_status == 3) {//진행중
    		NotifyVO notifyVO = new NotifyVO();
    		notifyVO.setMem_num(dbox.getMem_num());
    		notifyVO.setNotify_type(8); 
    		notifyVO.setNot_url("/dbox/" + dbox.getDbox_num() + "/content");
    		
    		Map<String, String> dynamicValues = new HashMap<String, String>();
    		dynamicValues.put("dboxTitle", dbox.getDbox_title());
    		
    		notifyService.insertNotifyLog(notifyVO, dynamicValues);
    	}
    	
    	if(dbox_status >= 4) {//4 : 진행완료 / 5 : 진행 중단
    		//알림
			NotifyVO notifyVO = new NotifyVO();
			notifyVO.setMem_num(dbox.getMem_num());
			notifyVO.setNotify_type(9); 
			notifyVO.setNot_url("/dbox/myPage/dboxMyPropose");
			
			Map<String, String> dynamicValues = new HashMap<String, String>();
			dynamicValues.put("dboxTitle", dbox.getDbox_title());
			
			notifyService.insertNotifyLog(notifyVO, dynamicValues);
    	}
    	
    	//신청반려 / 진행중단 사유 안내
    	if(dbox_status==2) {
    		dboxService.updateDboxAcomment(dbox_num, "신청하신 [" + dbox.getDbox_title() + "] 기부박스가 반려되었습니다. \n\n신청반려사유 : " + reject);
    		
    	}else if(dbox_status==5) {
    		List<DboxDonationVO> list = dboxService.getDboxDonationVODboxNum(dbox_num);
    		for(DboxDonationVO dboxdonationVO : list) {
    			if(dboxdonationVO.getDbox_do_point() == dboxdonationVO.getDbox_do_price()) {
    				PointVO pointVO = new PointVO();
    				//포인트 반환
    				pointVO.setMem_num(dboxdonationVO.getMem_num());
    				pointVO.setPevent_type(30);
    				pointVO.setPoint_amount(dboxdonationVO.getDbox_do_point());
    				memberService.updateMemPoint(pointVO);
    			}else {   			
    			//refund
    			RefundVO refundVO = new RefundVO();
    			refundVO.setMem_num(dboxdonationVO.getMem_num());
    			refundVO.setImp_uid(dboxdonationVO.getDbox_imp_uid());
    			refundVO.setPayment_type(1);
    			refundVO.setReason(4);
    			refundVO.setReturn_point(dboxdonationVO.getDbox_do_point());
    			refundVO.setAmount((int)dboxdonationVO.getDbox_do_price());
    			dboxService.refund(refundVO,dboxdonationVO);
    			//결제상태 변경
    			dboxService.updatePayStatus(dboxdonationVO.getDbox_do_num(), 2);   				
    			}
    		}
    		
    		dboxService.updateDboxAcomment(dbox_num, "[" + dbox.getDbox_title() + "] 기부박스가 진행중단되었습니다. \n\n진행중단사유 : " + reject);

    	}
    	
    	return "redirect:/admin/dboxAdminStatus/"+dbox_num;
    }
    /*===================================
     * 		기부박스 자동 업데이트
     *==================================*/   
    @Scheduled(cron = "0 0 0 * * ?")//0초 0분 0시 매일 매월 ?요일
    public void dboxUpdate() {
    	LocalDate today = LocalDate.now();
    	int dbox_status;
    	log.debug("기부박스 날짜 갱신 - 오늘 날짜 : " + today);
    	
    	List<DboxVO> list = null;		
		
    	//심사완료한 기부박스 진행중으로 변환
    	dbox_status = 1;
    	list = dboxService.selectStatusUpdateList(dbox_status);
    	
    	for(DboxVO dbox : list) {
            int year = Integer.parseInt(dbox.getDbox_sdate().split("-")[0]); // 연도
            int month = Integer.parseInt(dbox.getDbox_sdate().split("-")[1]); // 월
            int day = Integer.parseInt(dbox.getDbox_sdate().split("-")[2]); // 일
    		LocalDate targetDate = LocalDate.of(year,month,day);//형식 변경
    		log.debug("연,월,일 & targetDate: "+ dbox.getDbox_num() + " : " + year + "," + month + "," + day+ "&" + targetDate);
    
    		if(today.isEqual(targetDate))  {
    			dboxService.updateDboxStatus(dbox.getDbox_num(), 3);
    			log.debug("바뀐 dbox : 연,월,일 & targetDate: "+ dbox.getDbox_num() + " : " + year + "," + month + "," + day+ "&" + targetDate);
    			//알림
    			NotifyVO notifyVO = new NotifyVO();
    			notifyVO.setMem_num(dbox.getMem_num());
    			notifyVO.setNotify_type(8); 
    			notifyVO.setNot_url("/dbox/" + dbox.getDbox_num() + "/content");
    			
    			Map<String, String> dynamicValues = new HashMap<String, String>();
    			dynamicValues.put("dboxTitle", dbox.getDbox_title());
    			
    			notifyService.insertNotifyLog(notifyVO, dynamicValues);
    		}
    	}
    	//진행중인 기부박스 진행완료로 변환
    	dbox_status = 3;
    	list = dboxService.selectStatusUpdateList(dbox_status);
    	
    	for(DboxVO dbox : list) {
    		int year = Integer.parseInt(dbox.getDbox_edate().split("-")[0]); // 연도
    		int month = Integer.parseInt(dbox.getDbox_edate().split("-")[1]); // 월
    		int day = Integer.parseInt(dbox.getDbox_edate().split("-")[2]); // 일
    		LocalDate targetDate = LocalDate.of(year,month,day);//형식 변경
    		log.debug("연,월,일 & targetDate: "+ dbox.getDbox_num() + " : " + year + "," + month + "," + day+ "&" + targetDate);
    		
    		if(today.minusDays(1).isEqual(targetDate)) {//종료일 보정
    			log.debug("바뀐 dbox : 연,월,일 & targetDate: "+ dbox.getDbox_num() + " : " + year + "," + month + "," + day+ "&" + targetDate);
    			dboxService.updateDboxStatus(dbox.getDbox_num(), 4);
    			
    			//알림
    			NotifyVO notifyVO = new NotifyVO();
    			notifyVO.setMem_num(dbox.getMem_num());
    			notifyVO.setNotify_type(9); 
    			notifyVO.setNot_url("/dbox/" + dbox.getDbox_num() + "/content");
    			
    			Map<String, String> dynamicValues = new HashMap<String, String>();
    			dynamicValues.put("dboxTitle", dbox.getDbox_title());
    			
    			notifyService.insertNotifyLog(notifyVO, dynamicValues);
    		}
    	}
    }
}