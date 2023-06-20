package com.earth.heart.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
	
	//2023-05-08
	//board.jsp 삭제 버튼과 연관 있음
	@PostMapping("/remove")
	public String remove(Integer bno, Integer page, Integer pageSize, RedirectAttributes rattr, HttpSession session){	//interface RedirectAttributes(모델 아님)를 추가한 이유는 어떤 곳에서든 쓰기 위해서(모델은 어디서든 사용 가능)
		//LoginController에서 session.setAttribute("id", id)로 저장한 id를 가져옴(get)
		String writer = (String)session.getAttribute("id");
		String msg = "DELETE_OK";
		
		//(Board)Service 단으로 요청이 들어가야 함. remove 호출
		//BoardService를 이용해 데이터베이스에 bno, writer 넘길 것
		try {	//remove의 리턴 값은 int. 삭제되는 게시물은 1개니까 반환 값은 항상 1이어야 한다.
			if(boardService.remove(bno, writer) != 1)
				throw new Exception("Delete failed.");
		} catch (Exception e) {
			e.printStackTrace();
			msg = "DELETE_ERROR";
		}
		
		//삭제 후 안내 메시지는 한 번만 나와야 함 
		//Model이 아닌 RedirectAttributes에 저장하면 메시지가 한 번만 나옴
		rattr.addAttribute("page", page);
		rattr.addAttribute("pageSize", pageSize);
		//addFlashAttribute: 한 번만 저장하고 정보 지움(세션에 잠시 저장함)
		rattr.addFlashAttribute("msg", msg);
		
		return "redirect:/board/list";
	}
	
	@GetMapping("/write")
	public String write(Model m) {
		m.addAttribute("mode", "new");					//board.jsp에서 mode==new 해당 줄 설정하고 있음
			
		return "board";			//board.jsp 읽기와 쓰기는 동일한 페이지. 글쓰기에 사용할 때는 mode key값의 value를 new로 정의함
	}
	
	//하나의 DTO(게시글)가 write 된다
	@PostMapping("/write")
	public String write(BoardDTO boardDTO, RedirectAttributes rattr, Model m, HttpSession session) {
		//id 가져옴
		String writer = (String)session.getAttribute("id");
		boardDTO.setWriter(writer);
		
		try {
			if(boardService.write(boardDTO) != 1) {
				//예외발생시킴
				throw new Exception("Write failed");
			}
			rattr.addFlashAttribute("msg", "WRITE_OK");
			return "redirect:/board/list";
			
		} catch (Exception e) {
			e.printStackTrace();
			//내가 가지고 있는 페이지 상에서는 현재 상태에 머물러 있게(내가 쓴 글이 남아있게끔) 만들기
			//따라서 model에 저장
			m.addAttribute("mode", "new");			//글쓰기 모드로 설정
			m.addAttribute("boardDTO", boardDTO);	//등록하려던 내용을 보여줘야하니 유지(keep)해둠
			m.addAttribute("msg", "WRITE_ERROR");
			return "board";
		}

	}
	
	@PostMapping("/modify")
	public String modify(BoardDTO boardDTO, Integer page, Integer pageSize, RedirectAttributes rattr, Model m, HttpSession session) {
		//id 가져옴
		String writer = (String)session.getAttribute("id");
		//writer를 동일하게 설정
		boardDTO.setWriter(writer);
		
		
		try {					//예외가 발생 안 하면 정상 처리 되는 부분
			if(boardService.modify(boardDTO) != 1) 
				throw new Exception("Modify failed");
			
			rattr.addAttribute("page", page);
			rattr.addAttribute("pageSize", pageSize);
			rattr.addFlashAttribute("msg", "MODE_OK");
			
			return "redirect:/board/list";
		} catch (Exception e) {	//예외가 발생하면 catch 부분으로 와 우선 정보를 계속 가지고 있음
			e.printStackTrace();
			//m.addAttribute("boardDTO", boardDTO); 키와 밸류의 이름이 같으니 아래처럼 생략 가능
			m.addAttribute("boardDTO");
			m.addAttribute("page", page);
			m.addAttribute("pageSize", pageSize);
			m.addAttribute("msg", "MODE_ERROR");
			return "board";		//수정 후 등록하려던 내용을 보존하고 있음
		}
	}
	

	private boolean loginCheck(HttpServletRequest request) {
		//1. 세션 얻어(false는 session이 없어도 새로 생성하지 않음->반환값은 null)
		HttpSession session = request.getSession(false);				//이미 로그인 했으면 세션 만들 필요 없으니 false해줌
		
		//2. 세션에 id가 있는지 확인, 있으면 true / 없으면 false 반환		
		return session != null && session.getAttribute("id") != null;	//세션이 있고 그 세선에 아이디가 있으면 반환
		
		//3.
		
		
	}
}
