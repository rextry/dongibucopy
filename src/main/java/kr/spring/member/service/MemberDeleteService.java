package kr.spring.member.service;

import java.io.IOException;

import com.siot.IamportRestClient.exception.IamportResponseException;

public interface MemberDeleteService {

	//회원 탈퇴
	public void deleteAccount(long mem_num) throws IamportResponseException, IOException;
}
