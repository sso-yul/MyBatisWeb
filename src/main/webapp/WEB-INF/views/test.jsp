<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- jQuery 소스코드 삽입 -->
    <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
    <title>CommentTest</title>
</head>
<body>
    <h2>CommentTest</h2>
    <button id="sendBtn">SEND</button>
    <!-- 이곳에 출력이 된다 js로 출력해줘야함 -->
    <div id="commentList"></div>
    
    <script type="text/javascript">
    	//bno일단 지금 쓰고 있는 값으로 정의
    	let bno = 8
    	//파라미터로 bno를 넘길 것이다

    	//ready가 먼저 실행됨 
    	$(document).ready(function() {
			//클릭 이벤트는 버튼( <button id="sendBtn">SEND</button> )에 등록
			$("#sendBtn").click(function() {
				//그리고 위의 함수 호출. bno는 정의된 것으로 넘어간다
				showList(bno)
			})
		})



		//요걸 result에서 html로 호출할 것이다. 다이렉트로 안 되니까...
		//호출해서 쓰기 위해 객체 이름 저장
		let toHtml = function(comments) {
			//댓글 목록을 ul, li로 표현할 것이다
			let tmp = "<ul>"
			//li는 foreach문으로 작성해야 한다왜냐면... 반복 되잖아
			//파라미터는 일단 comment로 정의. 댓글 하나하나니까
			comments.forEach(function(comment) {
				//밖에서 큰따옴 썼으니까 안에서는 작은따옴쓴다
				//comment.cno -> 하나하나의 cno
				tmp += '<li data-cno='	+ comment.cno
				tmp += ' data-recmt='	+ comment.recmt
				tmp += ' data-bno='		+ comment.bno + '>'
				tmp += ' comment=<span class="comment">'		+ comment.comment + '</span>'
				tmp += ' commenter=<span class="commenter">'	+ comment.commenter + '</span>'					
				tmp += '</li>'
			})
			return tmp + "</ul>";
		}



		let showList = function(bno) {
			//jQuery.ajax() -> $.ajax()
    		//읽어오는 메서드(댓글 로드)
			$.ajax({
    			type : 'GET',								//요청 메서드
    			url : '/heart/comments?bno='+bno,			//요청 URI, http://localhost/heart/comments?bno=8
    			success : function(result) {				//성공 시에 호출, 댓글 결과. 여기서 잘 ... 출력해주면 됨 위의 <div id="commentList"></div>여기다가
					$("#commentList").html(toHtml(result))	//result = 서버가 전송한 데이터. 나오는지 테스트 해봐야 한다
				},
				error : function() {alert("error")}
	   		})
    	}

    </script>
</body>
</html>