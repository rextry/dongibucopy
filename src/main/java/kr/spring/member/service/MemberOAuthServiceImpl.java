package kr.spring.member.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.spring.member.vo.UserInfo;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class MemberOAuthServiceImpl implements MemberOAuthService {
	
	//카카오 로그인 API 정보
	@Value("${kakao.client_id}")
	private String k_client_id;
	@Value("${kakao.redirect_uri}")
	private String k_redirect_uri;
	@Value("${kakao.client_secret}")
	private String k_client_secret;
	
	//네이버 로그인 API 정보
	@Value("${naver.client_id}")
	private String n_client_id;
	@Value("${naver.redirect_uri}")
	private String n_redirect_uri;
	@Value("${naver.client_secret}")
	private String n_client_secret;

	//카카오 엑세스 토큰 받아오기
	@Override
	public String getKakaoAccessToken(String code) throws JsonMappingException, JsonProcessingException {
		// HTTP Header 생성
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        // HTTP Body 생성
        MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
        body.add("grant_type", "authorization_code");
        body.add("client_id", k_client_id);
        body.add("redirect_uri", k_redirect_uri);
        body.add("code", code);
        body.add("client_secret", k_client_secret);
        

        // HTTP 요청 보내기
        HttpEntity<MultiValueMap<String, String>> kakaoTokenRequest = new HttpEntity<>(body, headers);
        RestTemplate rt = new RestTemplate();
        ResponseEntity<String> response = rt.exchange(
                "https://kauth.kakao.com/oauth/token",
                HttpMethod.POST,
                kakaoTokenRequest,
                String.class
        );

        // HTTP 응답 (JSON) -> 액세스 토큰 파싱
        String responseBody = response.getBody();
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(responseBody);

        return jsonNode.get("access_token").asText();
	}

	@Override
	public UserInfo getKakaoInfo(String accessToken) throws JsonMappingException, JsonProcessingException {
        // HTTP Header 생성
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        // HTTP 요청 보내기
        HttpEntity<MultiValueMap<String, String>> kakaoUserInfoRequest = new HttpEntity<>(headers);
        RestTemplate rt = new RestTemplate();
        ResponseEntity<String> response = rt.exchange(
                "https://kapi.kakao.com/v2/user/me",
                HttpMethod.POST,
                kakaoUserInfoRequest,
                String.class
        );

        // responseBody에 있는 정보 꺼내기
        String responseBody = response.getBody();
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(responseBody);

        String id = jsonNode.get("id").asText();
        String email = jsonNode.get("kakao_account").get("email").asText();

        return new UserInfo(id, email);
	}

	@Override
	public void kakaoDisconnect(String accessToken) throws JsonMappingException, JsonProcessingException {
        // HTTP Header 생성
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);
        headers.add("Content-type", "application/x-www-form-urlencoded");

        // HTTP 요청 보내기
        HttpEntity<MultiValueMap<String, String>> kakaoLogoutRequest = new HttpEntity<>(headers);
        RestTemplate rt = new RestTemplate();
        ResponseEntity<String> response = rt.exchange(
                "https://kapi.kakao.com/v1/user/logout",
                HttpMethod.POST,
                kakaoLogoutRequest,
                String.class
        );

        // responseBody에 있는 정보를 꺼냄
        String responseBody = response.getBody();
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(responseBody);

        Long id = jsonNode.get("id").asLong();
        log.debug("<<반환된 로그아웃 id>> : "+id);
	}

	@Override
	public String getNaverAccessToken(String code, String state) throws JsonMappingException, JsonProcessingException {
	    String reqUrl = "https://nid.naver.com/oauth2.0/token";
	    RestTemplate restTemplate = new RestTemplate();
	    
	    // HttpHeader Object
	    HttpHeaders headers = new HttpHeaders();
	    
	    // HttpBody Object
	    MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
	    params.add("grant_type", "authorization_code");
	    params.add("client_id", n_client_id);
	    params.add("client_secret", n_client_secret);
	    params.add("code", code);
	    params.add("state", state);
	    
	    // http body params 와 http headers 를 가진 엔티티
	    HttpEntity<MultiValueMap<String, String>> naverTokenRequest = new HttpEntity<>(params, headers);
	    
	    // reqUrl로 Http 요청, POST 방식
	    ResponseEntity<String> response = restTemplate.exchange(reqUrl,
	                                              HttpMethod.POST,
	                                              naverTokenRequest,
	                                              String.class);
	    
	    String responseBody = response.getBody();
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(responseBody);
        String accessToken = jsonNode.get("access_token").asText();
	    
        return accessToken;
	}

	@Override
	public UserInfo getNaverInfo(String accessToken) throws JsonMappingException, JsonProcessingException {
	    String reqUrl = "https://openapi.naver.com/v1/nid/me";
	    
	    RestTemplate restTemplate = new RestTemplate();
	    
	    // HttpHeader 오브젝트
	    HttpHeaders headers = new HttpHeaders();
	    headers.add("Authorization", "Bearer " + accessToken);
	    
	    HttpEntity<MultiValueMap<String, String>> naverProfileRequest = new HttpEntity<>(headers);
	    
	    ResponseEntity<String> response = restTemplate.exchange(reqUrl,
	                                              HttpMethod.POST,
	                                              naverProfileRequest,
	                                              String.class);
	    
	    String responseBody = response.getBody();
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonNode = objectMapper.readTree(responseBody);
        JsonNode responseNode = jsonNode.path("response");
        String id = responseNode.path("id").asText();
        String email = responseNode.path("email").asText();

        return new UserInfo(id, email);
	}
}
