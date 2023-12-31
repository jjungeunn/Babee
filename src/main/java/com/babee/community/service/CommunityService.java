package com.babee.community.service;

import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.babee.community.vo.CommentVO;
import com.babee.community.vo.FreeboardVO;
import com.babee.community.vo.InfoVO;
import com.babee.community.vo.QnaVO;

public interface CommunityService {
	public List<FreeboardVO> selectFreeboard(String member_id) throws Exception;
	public void addFreeboard(Map freeboardMap) throws DataAccessException;
	public Map freeboardDetail(String articleNO) throws Exception;
	public void modFreeboard(Map freeboardMap) throws DataAccessException;
	
	

	public List selectComment(String articleNO) throws Exception;
	public void addComment(CommentVO commentVO)throws Exception;
	public void delFreeboard(Map freeboardMap) throws Exception;
	
	public void addQan(QnaVO qnaVO) throws Exception;
	public List<QnaVO> selectMyQnaList(String member_id) throws Exception;
	
	public void addInfo(Map infoMap) throws DataAccessException;
	public List<InfoVO> selectInfoboard(String member_id) throws Exception;
	public Map admininfoDetail(String articleNO) throws Exception;
	public List selectAllinfo()throws Exception;
	public void delInfoboard(String articleNO)throws Exception;
	public void modInfo(Map<String, Object> infoMap) throws Exception;
	
	public void adminDelFreeboard(String articleNO)throws Exception;
	
	public Map freeboardDetail2(String articleNO_)throws Exception;
	public List selectAllQnaList()throws Exception;
	public void addQnaAnswer(QnaVO qnaVO) throws Exception;



}
