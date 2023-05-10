package com.earth.heart.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.earth.heart.domain.BoardDTO;
import com.earth.heart.domain.SearchItem;

//boardMapper.xml이 해당 자바 일 덜어가줘서 코드 줄어듦

//bean 등록
@Repository
public class BoardDaoImpl implements BoardDao{
	
	//root-context의 등록된 빈(sqlSession) 연결함
	@Autowired
	private SqlSession session;
	private static String namespace = "com.earth.heart.dao.BoardMapper.";
	
	@Override
	public BoardDTO select(Integer bno) throws Exception {
		
		//namespace파라미터로 넘어가는 값이 com.earth.heart.dao.BoardMapper.로(xml파일) 넘어가 id값 select로 감(spring DAO 단)
		return session.selectOne(namespace + "select", bno);
		
	}

	@Override
	public int deleteAll() throws Exception {
		
		return session.delete(namespace + "deleteAll");
	}

	@Override
	public int insert(BoardDTO dto) throws Exception {
		
		return session.insert(namespace+"insert", dto);
	}

	@Override
	public int count() throws Exception {
		
		return session.selectOne(namespace + "count");		//count에 있는 것이 id로 사용됨
	}

	
	//하나 생길 때마다 쌓이는.. 고런... 네이버 카페 게시판 생각하면 됨
	@Override
	public List<BoardDTO> selectAll() throws Exception {
	
		return session.selectList(namespace + "selectAll");	//""안에는 id 값이 들어가야 하니 selectAll 넣음
	}
	
	
	//boardMappe.xml의 해당 파라미터 타입이 map이니까 map 방식으로 해야함
	@Override
	public int delete(Integer bno, String writer) throws Exception {
		Map map = new HashMap();
		map.put("bno", bno);
		map.put("writer", writer);
		
		//파라미터 타입은 맵으로 정의(타입 맞아야 문제 없음)
		return session.delete(namespace + "delete", map);
	}

	@Override
	public int update(BoardDTO boardDTO) throws Exception {		
		return session.update(namespace + "update", boardDTO);
	}

	@Override
	public List<BoardDTO> selectPage(Map map) throws Exception {		
		return session.selectList(namespace + "selectPage", map);
	}

	@Override
	public int increaseViewCnt(Integer bno) throws Exception {
		return session.update(namespace + "increaseViewCnt", bno);
	}

	@Override
	public int searchResultCnt(SearchItem sc) throws Exception {
		return session.selectOne(namespace + "searchResultCnt", sc);
	}

	@Override
	public List<BoardDTO> searchSelectPage(SearchItem sc) throws Exception {
		return session.selectList(namespace + "searchSelectPage", sc);
	}

}
