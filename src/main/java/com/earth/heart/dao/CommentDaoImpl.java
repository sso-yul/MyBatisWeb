package com.earth.heart.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.earth.heart.domain.CommentDTO;


@Repository
public class CommentDaoImpl implements CommentDao{

	
	@Autowired
	private SqlSession session;
	private static String namespace = "com.earth.heart.dao.CommentMapper.";
	
	//파라미터 타입과 리턴 타입이 동일해야 에러가 안 남
	//session. 이후의 오는 것은 note > spring > Mybatis 파일 참고
	
	@Override
	public int count(Integer bno) throws Exception {
		return session.selectOne(namespace + "count", bno);
	}
	
	
	@Override
	public int deleteAll(Integer bno) throws Exception {
		return session.delete(namespace + "deleteAll", bno);
	}

	
	//이쪽 딜리트는 파라미터 타입을 map으로 정의 했음(commentMapper참고)
	@Override
	public int delete(Integer cno, String commenter) throws Exception {
		Map map = new HashMap();
		map.put("cno", cno);
		map.put("commenter", commenter);		
		return session.delete(namespace + "delete", map);
	}

	@Override
	public List<CommentDTO> selectAll(Integer bno) throws Exception {
		//selectAll이니 리스트로 출력
		return session.selectList(namespace + "selectAll", bno);
	}

	@Override
	public int insert(CommentDTO commentDTO) throws Exception {
		return session.insert(namespace + "insert", commentDTO);
	}

	@Override
	public int update(CommentDTO commentDTO) throws Exception {
		return session.update(namespace + "update", commentDTO);
	}

	

}
