package com.earth.heart.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.earth.heart.domain.BoardDTO;
import com.earth.heart.domain.PageResolver;
import com.earth.heart.domain.SearchItem;
import com.earth.heart.service.BoardService;

@Controller
@RequestMapping("/board")
public class BoardController {
	
	@Autowired
	BoardService boardService;
	
	
	@GetMapping("/list")
	public String list(SearchItem sc, Model m, HttpServletRequest request) {			//list요청을 하게 되면 게시글이 좌르륵 나와야함 SearchItem에 그 정보가 있음
		//로그인 체크(로그인 컨트롤러에 있음)
		if(!loginCheck(request)) {																//request의 저장소/파라미터로 넘김
			return "redirect:/login/login?toURL=" + request.getRequestURL();					//다시 로그인을 받게끔 리다이렉트를 함 -> 로그인 화면 갔다가 -> 로그인 되면 원래 가고자하는 URL로 이동시켜줌
		}
		
//		if(page == null) {
//			page == 1;
//		}
//		if(pageSize == null) {
//			pageSize == 10;
//		}
		
		try {
			int totalCnt = boardService.getSearchResultCnt(sc);
			//이걸 모델에 저장함. 왜냐면 화면에 보여줘야하기 때문에(MVC 모델 -> 뷰)
			m.addAttribute("totalCnt", totalCnt);
			
			PageResolver pageResolver = new PageResolver(totalCnt, sc);
			
			//우리가 알고자하는 데이터는 이 보드디티오의 리스트에 있음 (이 내용을 뷰에서 보여줌)
			List<BoardDTO> list = boardService.getSelectPage(sc);
			//이거 역시 모델에 저장함
			m.addAttribute("list", list);
			m.addAttribute("pr", pageResolver);
			
		} catch (Exception e) {e.printStackTrace();}
		
		return "boardList";			//로그인한 상태, 게시물 화면 목록으로 이동
	}
	
	//게시글을 읽을 때 요청할 것임(쿼리 스트링을 해 bno값이 넘어가고 이 하나의 글은 bno값이 된다)
	//하나의 게시글을 읽는 화면( 제목 눌렀을 때 나오는 게시글 내용 )
	@GetMapping("/read")
	public String read(Integer bno, SearchItem sc, Model m) {
		
		try {
			BoardDTO boardDTO = boardService.read(bno);
			//m.addAttribute("boardDTO", boardDTO); 아래와 같은 의미. 키값을 저장하는 키값을 생략해도 된다-알아서 되니까
			m.addAttribute(boardDTO);
		} catch (Exception e) {
			e.printStackTrace();
			return "redirect:/board/list";	//삭제된 게시물 클릭했을 때 리스트로 다시 돌아감
		}
		
		return "board";
	}
	
	

	private boolean loginCheck(HttpServletRequest request) {
		//1. 세션 얻어(false는 session이 없어도 새로 생성하지 않음->반환값은 null)
		HttpSession session = request.getSession(false);				//이미 로그인 했으면 세션 만들 필요 없으니 false해줌
		
		//2. 세션에 id가 있는지 확인, 있으면 true / 없으면 false 반환		
		return session != null && session.getAttribute("id") != null;	//세션이 있고 그 세선에 아이디가 있으면 반환
		
		//3.
		
		
	}
}
