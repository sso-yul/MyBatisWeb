package com.earth.heart.service;
//비즈니스 로직이 들어감 이체 금액 송금 등등 따라서 DAO쪽 용어(삭제, 수정, 삽입)등은 쓰지 않는 게 좋음

import java.util.List;
import java.util.Map;

import com.earth.heart.domain.BoardDTO;
import com.earth.heart.domain.SearchItem;

public interface BoardService {

	List<BoardDTO> getPage(Map map) throws Exception;
	int getCount() throws Exception;
	BoardDTO read(Integer bno) throws Exception;				//특정 게시글에 대해 고름
	int remove(Integer bno, String writer) throws Exception;	//내가 게시한 글 삭제
	int write(BoardDTO boardDTO) throws Exception;
	int modify(BoardDTO boardDTO) throws Exception;
	int getSearchResultCnt(SearchItem sc) throws Exception;
	List<BoardDTO> getSelectPage(SearchItem sc) throws Exception;
}
