package com.earth.heart;

import static org.junit.Assert.assertTrue;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.earth.heart.dao.BoardDao;
import com.earth.heart.dao.CommentDao;
import com.earth.heart.domain.BoardDTO;
import com.earth.heart.domain.CommentDTO;
import com.earth.heart.service.CommentService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/**/root-context.xml")	//DB연동 관련된 정보
public class CommentServiceImplTest {

	
	@Autowired
	CommentService commentService;
	
	@Autowired
	CommentDao commentDao;
	
	@Autowired
	BoardDao boardDao;
	
	
	//댓글 게시글 전부 생성
	@Test
	public void remove() throws Exception {
		boardDao.deleteAll();
		//BoardDTO 생성해봄
		// = 우선 게시글 하나를 생성해본다
		BoardDTO boardDTO = new BoardDTO("제목~~~~~~", "내용~~~~~", "earth");
		
		assertTrue(boardDao.insert(boardDTO) == 1);
		Integer bno = boardDao.selectAll().get(0).getBno();
		System.out.println("bno = " + bno);
		
		//댓글도 하나 생성해 본다
		//우선 삭제한 다음
		commentDao.deleteAll(bno);
		CommentDTO commentDTO = new CommentDTO(bno, 0, "댓글입니다~~~~", "moon");
		//해당 게시글 bno의 코멘트 카운트 는 현재 0
		assertTrue(boardDao.select(bno).getComment_cnt() == 0);
		//그러니까 이제 댓글 작성. 실제로 댓글이 작성된 곳은 이쪽
		//CommentServiceImpl 로 넘어가서 해당 메서드로 가 1이 추가 되는지 안 되는지 이제 확인해본다
		assertTrue(commentService.write(commentDTO) == 1);
		
		assertTrue(boardDao.select(bno).getComment_cnt() == 1);
		//위의 내용까지는 정상 실행 된 경우
		
		//댓글의 cno
		Integer cno = commentDao.selectAll(bno).get(0).getCno();
		
		
		//에러 뜸;;
		//remove도 여기서 해봄
		int rowCnt = commentService.remove(cno, bno, commentDTO.getCommenter());
		//잘 됐으면 rowCnt가 1이 나올 것
		assertTrue(rowCnt == 1);
		//하나 있다가 하나 지워졌으니 댓글 개수는 0이 되는 것이 맞다
		assertTrue(boardDao.select(bno).getComment_cnt() == 0);
	} 
	
	//@Test
	public void write() throws Exception {
		boardDao.deleteAll();
		BoardDTO boardDTO = new BoardDTO("제목~~~~~~", "내용~~~~~", "earth");
		assertTrue(boardDao.insert(boardDTO) == 1);
		Integer bno = boardDao.selectAll().get(0).getBno();
		//게시글 하나 만들어져 있고 댓글은 0일 것이고...
		
		commentDao.deleteAll(bno);
		CommentDTO commentDTO = new CommentDTO(bno, 0, "댓글입니당", "moon");
		//댓글 만들어놓기만 했고 없는 상태니 0
		assertTrue(boardDao.select(bno).getComment_cnt() == 0);
		//댓글 만들기 그러니까 여기는 1
		assertTrue(commentService.write(commentDTO) == 1);
		
		//댓글의 cno
		Integer cno = commentDao.selectAll(bno).get(0).getCno();
		assertTrue(boardDao.select(bno).getComment_cnt() == 1);
		
	}
	
	
	
	
}
