package kr.spring.member.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@NoArgsConstructor
@ToString
public class UserInfo {
	private String id;
	private String email;

	public UserInfo(String id, String email) {
		this.id = id;
		this.email = email;
	}
}
