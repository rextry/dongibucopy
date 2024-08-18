package kr.spring.category.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import kr.spring.category.vo.ChallengeCategoryVO;
import kr.spring.category.vo.DonationCategoryVO;

@Mapper
public interface CategoryMapper {
	// 기부 카테고리 등록
	public void insertDonationCategory(DonationCategoryVO donationCategoryVO);
	// 기부 카테고리 개수
	@Select("SELECT COUNT(*) FROM dona_category")
	public int getListCount(Map<String,Object> map);
	// 기부 카테고리 목록
	public List<DonationCategoryVO> selectList();
	// 기부 카테고리 목록(페이지처리x)
	@Select("SELECT * FROM dona_category")
	public List<DonationCategoryVO> selectListNoPage();
	// 기부 카테고리 상세
	@Select("SELECT * FROM dona_category WHERE dcate_num=#{dcate_num}")
	public DonationCategoryVO selectDonationCategory(Long dcate_num);
	// 기부 카테고리 수정
	public void updateDonationCategory(DonationCategoryVO donationCategoryVO);
	// 기부 카테고리 삭제
	@Delete("DELETE FROM dona_category WHERE dcate_num =#{dcate_num}")
	public void deleteDonationCategory(Long dcate_num);
	// 기부 카테고리 수정시 파일 삭제
	@Update("UPDATE dona_category SET dcate_icon='' WHERE dcate_num=#{dcate_num}")
	public void deleteFile(Long dcate_num);
	//
	
	//Q. 챌린지 카테고리 페이징 처리가 있는지?
	//챌린지 카테고리 등록
	public void insertChallengeCategory(ChallengeCategoryVO challengeCategoryVO);
	//챌린지 카테고리 수
	public int getChalCateCount(Map<String,Object> map);
	//챌린지 카테고리 목록
	@Select("SELECT * FROM chal_category")
	public List<ChallengeCategoryVO> selectChalCateList();
	//챌린지 카테고리 상세
	public ChallengeCategoryVO selectChallengeCategory(Long ccate_num);
	//챌린지 카테고리 수정 
	public void updateChallengeCategory(ChallengeCategoryVO challengeCategoryVO);
	//챌린지 카테고리 삭제
	public void deleteChallengeCategory(Long ccate_num);
}
