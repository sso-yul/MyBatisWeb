package com.earth.heart.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.earth.heart.dao.BoardDao;
import com.earth.heart.domain.BoardDTO;
import com.earth.heart.domain.SearchItem;

//요거하면 스케일링 해서 bean 등록됨
@Service
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	BoardDao boardDao;
	
	@Override
	public List<BoardDTO> getPage(Map map) throws Exception {
		return boardDao.selectPage(map);
	}

	@Override
	public int getCount() throws Exception {
		return boardDao.count();
	}

	@Override
	public BoardDTO read(Integer bno) throws Exception {	//특정 게시물 읽음
		BoardDTO boardDTO = boardDao.select(bno);
		//비즈니스 로직 추가 -> 조회수 증가
		boardDao.increaseViewCnt(bno);
		return boardDTO;
	
		//아래 한 줄 또는 위에 세 줄
//		return boardDao.select(bno);						//호출할 때(읽을 때) 조회수가 1이 증가해야함 따라서 조회수 1 증가하는 거 추가하겠어요(boardMapper.xml에서 추가함)
	}

	@Override
	public int remove(Integer bno, String writer) throws Exception {
		return boardDao.delete(bno, writer);				//자기가 쓴 글만 삭제
	}

	@Override
	public int write(BoardDTO boardDTO) throws Exception {
		return boardDao.insert(boardDTO);
	}

	@Override
	public int modify(BoardDTO boardDTO) throws Exception {
		return boardDao.update(boardDTO);
	}

	@Override
	public int getSearchResultCnt(SearchItem sc) throws Exception {	//Service니까 DAO 호출
		return boardDao.searchResultCnt(sc);
	}

	@Override
	public List<BoardDTO> getSelectPage(SearchItem sc) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.searchSelectPage(sc);
	}

}
