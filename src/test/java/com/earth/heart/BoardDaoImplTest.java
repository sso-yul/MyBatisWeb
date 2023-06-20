package com.earth.heart;

import static org.junit.Assert.assertTrue;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.earth.heart.dao.BoardDao;
import com.earth.heart.domain.BoardDTO;
import com.earth.heart.domain.SearchItem;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/**/root-context.xml")	//DB연동 관련된 정보
public class BoardDaoImplTest {
	
	@Autowired
	private BoardDao boardDao;
	
	//@Test
	public void countTest() throws Exception {
		boardDao.deleteAll();
		assertTrue(boardDao.count() == 0);
		
		BoardDTO boardDTO = new BoardDTO("Pioneering", "ReadyforAction", "earth");
		assertTrue(boardDao.insert(boardDTO) == 1);
		assertTrue(boardDao.count() == 1);
		
		assertTrue(boardDao.insert(boardDTO) == 1);
		assertTrue(boardDao.count() == 2);
	}
	
	//@Test
	public void insertTest() throws Exception {
		boardDao.deleteAll();
		BoardDTO boardDTO = new BoardDTO("Pioneering", "ReadyforAction", "earth");
		assertTrue(boardDao.insert(boardDTO) == 1);
		
		boardDTO = new BoardDTO("Pioneering", "ReadyforAction", "earth");
		assertTrue(boardDao.insert(boardDTO) == 1);
		assertTrue(boardDao.count() == 2);
		
		boardDao.deleteAll();
		boardDTO = new BoardDTO("Pioneering", "ReadyforAction", "earth");
		assertTrue(boardDao.insert(boardDTO) == 1);
		assertTrue(boardDao.count() == 1);
	}


	//@Test
	public void selectTest() throws Exception {
		assertTrue(boardDao != null);
		System.out.println("boardDao = " + boardDao);
		
		BoardDTO boardDTO = boardDao.select(6);
		System.out.println("boardDTO = " + boardDTO);
		assertTrue(boardDTO.getBno().equals(6));
		
		boardDao.deleteAll();
		
		boardDTO = new BoardDTO("Pioneering", "ReadyforAction", "earth");
		boardDao.insert(boardDTO);
		
		boardDTO = boardDao.select(7);
		System.out.println("boardDTO = " + boardDTO);
		assertTrue(boardDTO.getBno().equals(7));
	}
	
	//@Test
	public void selectAllTest() throws Exception {
		boardDao.deleteAll();
		assertTrue(boardDao.count() == 0);
		List<BoardDTO> list = boardDao.selectAll();
		assertTrue(list.size() == 0);
		
		BoardDTO boardDTO = new BoardDTO("Pioneering", "ReadyforAction", "earth");
		assertTrue(boardDao.insert(boardDTO) == 1);
		
		list = boardDao.selectAll();
		assertTrue(list.size() == 1);
		
		assertTrue(boardDao.insert(boardDTO) == 1);
		list = boardDao.selectAll();
		assertTrue(list.size() == 2);
	}
	
	//@Test
	public void deleteTest() throws Exception {
		boardDao.deleteAll();
		assertTrue(boardDao.count() == 0);
		
		BoardDTO boardDTO = new BoardDTO("Pioneering", "ReadyforAction", "earth");
		assertTrue(boardDao.insert(boardDTO) == 1);
		Integer bno = boardDao.selectAll().get(0).getBno();					//get을 써서 index 0번째
		
		assertTrue(boardDao.delete(bno, boardDTO.getWriter()) == 1);
		assertTrue(boardDao.count() == 0);									//bno 값이 뭐가 되었든 그 값을 파라미터로 넘겼기 때문에 지워짐
		
		//라이터가 일치(만족)하지 않음
		assertTrue(boardDao.insert(boardDTO) == 1);							//하나 삽입
		bno = boardDao.selectAll().get(0).getBno();							//새로 들어간 거에 셀렉트 올 해서 맨 위에 있는 것에 겟 비엔오해서 그 값을 획득
		assertTrue(boardDao.delete(bno, boardDTO.getWriter() + "earth") == 0);	//이 상태에서 라이터는 earthearth가 된다 그래서 두 조건을 만족하는 경우가 현재 없으니 0
		assertTrue(boardDao.count() == 1);
		
		assertTrue(boardDao.delete(bno, boardDTO.getWriter()) == 1);
		assertTrue(boardDao.count() == 0);									//삭제가 되었으니 0이 됨
		
		//조건에 만족하지 않아 하나 남아있을 거고 그래서 딜리트가 안 됐을 것
		assertTrue(boardDao.insert(boardDTO) == 1);
		bno = boardDao.selectAll().get(0).getBno();
		assertTrue(boardDao.delete(bno + 1, boardDTO.getWriter()) == 0);
		assertTrue(boardDao.count() == 1);
	}
	
	//@Test
	public void deleteAllTest() throws Exception {
		boardDao.deleteAll();
		
		assertTrue(boardDao.count() == 0);
		BoardDTO boardDTO = new BoardDTO("Pioneering", "ReadyforAction", "earth");
		assertTrue(boardDao.insert(boardDTO) == 1);
		assertTrue(boardDao.deleteAll() == 1);
		assertTrue(boardDao.count() == 0);
		
		boardDTO = new BoardDTO("Pioneering", "ReadyforAction", "earth");
		assertTrue(boardDao.insert(boardDTO) == 1);
		assertTrue(boardDao.insert(boardDTO) == 1);
		assertTrue(boardDao.deleteAll() == 2);
		assertTrue(boardDao.count() == 0);
	}
	
	//@Test
	public void updateTest() throws Exception {
		boardDao.deleteAll();
		BoardDTO boardDTO = new BoardDTO("Pioneering", "ReadyforAction", "earth");
		assertTrue(boardDao.insert(boardDTO) == 1);
		
		Integer bno = boardDao.selectAll().get(0).getBno();	//가장 첫 번째에 있는 인덱스에 가서 bno 값을 가져옴
		System.out.println("bno = " + bno);
		boardDTO.setBno(bno);
		boardDTO.setTitle("yes i can");
		assertTrue(boardDao.update(boardDTO) == 1);
		
		BoardDTO boardDTO2 = boardDao.select(bno);
		assertTrue(boardDTO.equals(boardDTO2));
		
	}
	
	//@Test
	public void insertDummyTestData() throws Exception {
		boardDao.deleteAll();
		
		for(int i = 1; i <= 250; i++) {
			BoardDTO boardDTO = new BoardDTO("Pioneering_"+i, "ReadyforAction", "earth");
			boardDao.insert(boardDTO);
		}
	}
	
	//검색하는 쿼리문 호출
	//@Test
	public void searchSelectPageTest() throws Exception {
		boardDao.deleteAll();
		
		for(int i = 1; i <= 20; i++) {
			BoardDTO boardDTO = new BoardDTO("Pioneering_" + i, "abcd 취업준비" + i, "earth");
			boardDao.insert(boardDTO);
		}
		
		SearchItem sc = new SearchItem(1, 10, "T", "Pioneering_2");
		List<BoardDTO> list = boardDao.searchSelectPage(sc);
		
		System.out.println("list = " + list);
		
		assertTrue(list.size() == 2);			//1~20, Pioneering_2, Pioneering_20
	}
	
	@Test
	public void searchResultCntTest() throws Exception {
		boardDao.deleteAll();
		
		for(int i = 1; i <= 20; i++) {
			BoardDTO boardDTO = new BoardDTO("Pioneering_" + i, "abcd 취업준비" + i, "earth");
			boardDao.insert(boardDTO);
		}
		
		SearchItem sc = new SearchItem(1, 10, "T", "Pioneering_2");			// %Pioneering_2%
		int cnt = boardDao.searchResultCnt(sc);
		
		assertTrue(cnt == 2);					//1~20, Pioneering_2, Pioneering_20
	}
	

}
