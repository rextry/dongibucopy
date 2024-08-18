package kr.spring.member.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;

import kr.spring.member.vo.UserInfo;

public interface MemberOAuthService {
	public String getKakaoAccessToken(String code) throws JsonMappingException, JsonProcessingException;
	public UserInfo getKakaoInfo(String accessToken) throws JsonMappingException, JsonProcessingException;
	public void kakaoDisconnect(String accessToken) throws JsonMappingException, JsonProcessingException;
	
	public String getNaverAccessToken(String code, String state) throws JsonMappingException, JsonProcessingException;
	public UserInfo getNaverInfo(String accessToken) throws JsonMappingException, JsonProcessingException;
}
