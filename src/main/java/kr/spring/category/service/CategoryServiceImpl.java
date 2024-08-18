package kr.spring.category.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.spring.category.dao.CategoryMapper;
import kr.spring.category.vo.ChallengeCategoryVO;
import kr.spring.category.vo.DonationCategoryVO;

@Service
@Transactional
public class CategoryServiceImpl implements CategoryService {
	@Autowired
	CategoryMapper categoryMapper;

	@Override
	public void insertDonationCategory(DonationCategoryVO donationCategoryVO) {
		categoryMapper.insertDonationCategory(donationCategoryVO);
	}

	@Override
	public List<DonationCategoryVO> selectList() {
		return categoryMapper.selectList();
	}
	
	@Override
	public List<DonationCategoryVO> selectListNoPage() {
		return categoryMapper.selectListNoPage();
	}
	
	@Override
	public DonationCategoryVO selectDonationCategory(Long dcate_num) {
		return categoryMapper.selectDonationCategory(dcate_num);
	}

	@Override
	public void updateDonationCategory(DonationCategoryVO donationCategoryVO) {
		categoryMapper.updateDonationCategory(donationCategoryVO);
	}

	@Override
	public void deleteDonationCategory(Long dcate_num) {
		categoryMapper.deleteDonationCategory(dcate_num);
	}

	@Override
	public int getListCount(Map<String, Object> map) {
		return categoryMapper.getListCount(map);
	}

	@Override
	public void deleteFile(Long dcate_num) {
		categoryMapper.deleteFile(dcate_num);
	}

	@Override
	public void insertChallengeCategory(ChallengeCategoryVO challengeCategoryVO) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public int getChalCateCount(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public List<ChallengeCategoryVO> selectChalCateList() {
		return categoryMapper.selectChalCateList();
	}

	@Override
	public ChallengeCategoryVO selectChallengeCategory(Long ccate_num) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void updateChallengeCategory(ChallengeCategoryVO challengeCategoryVO) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteChallengeCategory(Long ccate_num) {
		// TODO Auto-generated method stub
		
	}

}
