package com.earth.heart;

import static org.junit.Assert.assertTrue;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.earth.heart.dao.CommentDao;
import com.earth.heart.domain.CommentDTO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/**/root-context.xml")	//DB연동 관련된 정보
public class CommentDaoImplTest {

	@Autowired
	CommentDao commentDao;
	
	//특정 bno의 게시물 다 삭제.
	//따라서 지금은 0번의 게시물에 달린 댓글 전부 삭제
	//@Test
	public void count() throws Exception {
		commentDao.deleteAll(0);
		assertTrue(commentDao.count(0) == 0);
	}
	
	//댓글 작성자와 댓글 지우려는 자가 동일할 때 지울 수 있음	
	//@Test
	public void delete() throws Exception {
		//bno = 1
		commentDao.deleteAll(1);
		//생성자 활용해서 객체 생성함. 댓글 하나 작성( CommentDTO에서 가져옴. )
		//public CommentDTO(Integer bno, Integer recmt, String comment, String commenter) 요거.
		CommentDTO commentDTO = new CommentDTO(1,null, "힘내~", "earth");
		//전부 다 지우고 한 개 다시 생성했으니 삽입 1개가 되면 true
		assertTrue(commentDao.insert(commentDTO) == 1);
		//또한 전부 지우고 한 개만 넣었으니 카운트가 1일 경우 true
		assertTrue(commentDao.count(1) == 1);
	}
	
	//@Test
	public void insert() throws Exception {
		//bno = 1
		commentDao.deleteAll(1);
		//생성자 활용해서 객체 생성함. 댓글 하나 작성( CommentDTO에서 가져옴. )
		CommentDTO commentDTO = new CommentDTO(1,null, "힘내~ 힘내세여~", "earth");
		//현재 한 개 생성했으니 삽입 1개가 되면 true
		assertTrue(commentDao.insert(commentDTO) == 1);
		//또한 전부 지우고 한 개만 넣었으니 bno1의 카운트가 1일 경우 true
		assertTrue(commentDao.count(1) == 1);
		
		//DTO 하나 더 만들었음(댓글을 하나 더 달았음)
		commentDTO = new CommentDTO(1,null, "빠샤~", "moon");
		//한 개 다시 생성했으니 삽입 1개가 되면 true
		assertTrue(commentDao.insert(commentDTO) == 1);
		//또한 위의 댓글 삽입 후 한 개 더 넣었으니 bno1의 댓글 카운트가 2일 경우 true
		assertTrue(commentDao.count(1) == 2);		
	}
	
	//@Test
	public void selectAll() throws Exception {
		//bno1의 댓글 전부 삭제 후 한 개 생성
		commentDao.deleteAll(1);
		CommentDTO commentDTO = new CommentDTO(1,null, "힘내~ 힘내세여~", "earth");
		
		//현재 한 개 생성했으니 삽입 1개가 되면 true
		assertTrue(commentDao.insert(commentDTO) == 1);
		//또한 전부 지우고 한 개만 넣었으니 bno1의 카운트가 1일 경우 true
		assertTrue(commentDao.count(1) == 1);
		
		//bno1 에 달린 댓글 리스트니까 List<>로 받아줌
		//근데 이 list에는 댓글이 1개 밖에 없으니 size() == 1일 때 true
		List<CommentDTO> list = commentDao.selectAll(1);
		assertTrue(list.size() == 1);
		
		//댓글 1개 추가
		commentDTO = new CommentDTO(1,null, "빠샤~", "moon");
		//현재 한 개 생성했으니 삽입 1개가 되면 true
		assertTrue(commentDao.insert(commentDTO) == 1);
		assertTrue(commentDao.count(1) == 2);
		
		//bno1에 댓글이 2개 있다
		list = commentDao.selectAll(1);
		assertTrue(list.size() == 2);
	}
	
	//@Test
	public void select() throws Exception {
		commentDao.deleteAll(1);
		CommentDTO commentDTO = new CommentDTO(1,null, "힘내~ 힘내세여~", "earth");
		assertTrue(commentDao.insert(commentDTO) == 1);
		assertTrue(commentDao.count(1) == 1);
		
		//Dao쪽에 실행된 결과도 비교해서 실행
		List<CommentDTO> list = commentDao.selectAll(1);
		//댓글 받아봄
		String comment = list.get(0).getComment();
		//코멘터(작성자) 받아봄
		String commenter = list.get(0).getCommenter();
		//DTO에 있는 내용과 비교
		assertTrue(comment.equals(commentDTO.getComment()));
		assertTrue(commenter.equals(commentDTO.getCommenter()));
	}
	
	
	//수정 후 업데이트
	@Test
	public void update() throws	Exception {
		commentDao.deleteAll(1);
		CommentDTO commentDTO = new CommentDTO(1,null, "힘내~ 힘내세여~", "earth");
		assertTrue(commentDao.insert(commentDTO) == 1);
		assertTrue(commentDao.count(1) == 1);
		//현재 bno1에 댓글 1개 있음
		
		List<CommentDTO> list = commentDao.selectAll(1);
		//업데이트를 해보자
		//현재 list에 있는 get(0)번째 getCno()로 설정 
		commentDTO.setCno(list.get(0).getCno());
		commentDTO.setComment("힘을 열심히 내자");
		assertTrue(commentDao.update(commentDTO) == 1);
		
		//list 불러내서 다시 확인
		list = commentDao.selectAll(1);
		String comment = list.get(0).getComment();
		String commenter = list.get(0).getCommenter();
		
		//동일한 댓글, 작성자인지 확인
		assertTrue(comment.equals(commentDTO.getComment()));
		assertTrue(commenter.equals(commentDTO.getCommenter()));
	}
	
	
}
