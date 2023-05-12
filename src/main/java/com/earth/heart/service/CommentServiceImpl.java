package com.earth.heart.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.earth.heart.dao.BoardDao;
import com.earth.heart.dao.CommentDao;
import com.earth.heart.domain.CommentDTO;

//댓글 하나 작성 시 보드 테이블에 보면 코멘트 카운트가 +1, 사라지면 -1 이런식으로 동시에 영향이 가야 함 (write & remove)
//transaction 처리가 되어야 함. 그래서 서비스에 boarddaoimpl, commentdaoimpl이 둘 다 있어야 함
//두 개의 dao 주입을 해야한다.

@Service
public class CommentServiceImpl implements CommentService {

	//@Autowired
	BoardDao boardDao;
	//@Autowired
	CommentDao commentDao;
		
	//두 개의 dao가 모두 DI(의존성 주입)이 되어야 하는데 개별적으로 하면 miss가 생길 수 있으니 생성자 주입으로 해주면 안전하다
	//현재 생성자가 하나니 이 줄 바로 밑의 @Autowired 생략 가능하긴 함
	@Autowired
	public CommentServiceImpl(BoardDao boardDao, CommentDao commentDao) {
		super();
		this.boardDao = boardDao;
		this.commentDao = commentDao;
	}
	
	
	//댓글의 목록 읽어오기
	@Override
	public List<CommentDTO> getList(Integer bno) throws Exception {
		return commentDao.selectAll(bno);
		
		//예외 강제 발생 메서드
		//throw new Exception("Excption Test");
	}
	
	
	
	@Override
	@Transactional(rollbackFor = Exception.class)	//예외 발생하면 롤백이 되게끔
	public int remove(Integer cno, Integer bno, String commenter) throws Exception {
		//rowCnt 되었으니(이따 확인할것)
		int rowCnt = boardDao.updateCommentCnt(bno, -1);
		//댓글 자체도 삭제
		rowCnt = commentDao.delete(cno, commenter);
		return rowCnt;
	}

	
	
	@Override
	@Transactional(rollbackFor = Exception.class)	//예외가 발생되면 롤백이 되게끔 한다
	public int write(CommentDTO commentDTO) throws Exception {
		//댓글 하나 작성하면 코멘트 개수 1개 추가되는 기능 만들기(BoardDao에)
		boardDao.updateCommentCnt(commentDTO.getBno(), 1);
		//댓글 내용 자체도 추가. 이게 실행 되든지 안 되든지 둘 중에 하나다
		return commentDao.insert(commentDTO);
	}

	@Override
	public int modify(CommentDTO commentDTO) throws Exception {
		return commentDao.update(commentDTO);
	}

	
	
}
