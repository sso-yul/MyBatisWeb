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
    <!-- 댓글 작성란(인풋태그에 입력받은 값 보내기) -->
    comment: <input type="text" name="comment" />
    
    <!-- 이 글에 있는 댓글들 불러오기 -->
    <button id="sendBtn">SEND</button>
    <button id="modBtn">MODIFY</button>
    <!-- 이곳에 출력이 된다 js로 출력해줘야함 -->
    <div id="commentList"></div>
    
    <script type="text/javascript">
    	//bno일단 지금 쓰고 있는 값으로 정의
    	let bno = 800
    	//파라미터로 bno를 넘길 것이다
    	
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

    	//ready가 먼저 실행됨 
    	$(document).ready(function() {
    		//클릭 이벤트는 버튼( <button id="sendBtn">SEND</button> )에 등록
			showList(bno)
			
			$("#sendBtn").click(function() {
				let cno = $(this).attr("data-cno")
				
				//댓글 작성란에 입력받은 값(댓글)
				let comment = $("input[name=comment]").val()
				//댓글작성란 null 체크(trim()-> 공백 삭제 함수)
				if(comment.trim() == '') {
					alert("댓글을 입력해주세요")
					$("input[name=comment]").focus()
					return
				}
				$.ajax({
					type: 'post',
					url: '/heart/comments?bno=' + bno,
					//헤더 값에 mime 타입 포함시킴 그래야 인식할 수 있으니까
					headers: {"content-type" : "application/json"},		//요청 헤더
					data: JSON.stringify({bno:bno, comment:comment}),	//서버로 전송할 데이터를 JSON의 타입의 문자열로(직렬화해서) 보냄
					success: function(result) {							//서버로부터 응답이 도착하면 보여줄 함수
						alert(result)
						//변경된 거 다시 보여줌(showList)
						showList(bno)
					},
					error: function(error) {alert("error")}				//에러 발생 시 호출될 함수
				})
				
			})
			
			//댓글 삭제 이벤트
//			$(".delBtn").click(function() {	//화면 실행해봅면 [send] 버튼클릭하고 나서 [삭제]버튼 보임 -> 이벤트 비활성화, 위치 잘 받아야 한다 여기 있으면 안 돼... send가 있는 곳에 있어야 함. commentList로 들어가야 한당
			$("#commentList").on("click", ".delBtn", function() {
				//alert("삭제 버튼 클릭됨") 요건 작동하나 확인해보려고 넣은 거
				//아래는 하나 지정해서 해당 댓글만 삭제되게 하는 방법
				//cno로 구분할 수 있음 cno의 부모는 bno
				//부모bno태그로 접근해서 자식cno으로 가야 함
				//이 부모의 attribute
				let cno = $(this).parent().attr("data-cno")		//공통으로 리턴되어지는 건 <li> 태그. <li> 태그는 buttom의 부모격에 해당
				let bno = $(this).parent().attr("data-bno")		
				
				//비동기 처리
				$.ajax({	//요청 메서드
					type: 'DELETE',
					url: '/heart/comments/' + cno + '?bno=' + bno,	//여기까지가 restFul API적용됨 bno를 겟요청하고 뭐리스트링으로 넘겨주고 요청 uri가 됨
					success: function(result) {	//성공 시
						//서버로부터 응답이 도착하면 호출될 함수
						//result는 서버가 전송한 데이터이다
						alert(result)
						//지우고나면 나머지 댓글도 다시 읽어야 함 아래 참고
						showList(bno)
					},
					error: function() {alert("error")}	//에러 발생 시 호출 함수
				})				
			})
			
			//댓글 수정 이벤트 버튼
			//수정 시 원래 내용을 댓글 작성란에 넣음 -> comment 가져옴 -> 얘는 아래 toHtml의 comment.comment 에 있음
			$("#commentList").on("click", ".modBtn", function() {
				//alert("댓글수정버튼클릭")
				let cno = $(this).parent().attr("data-cno")		//공통으로 리턴되어지는 건 <li> 태그. <li> 태그는 buttom의 부모격에 해당
				//tmp += ' comment=<span class="comment">'		+ comment.comment 	+ '</span>' 이쪽에 있는 거 가져옴
				//여기서 this는 수정 버튼
				//획득한 text 저장 (let comment)
				let comment = $("span.comment", $(this).parent()).text()		//클릭 된 수정 버튼의 부모는 <li>. <li>의 <span>의 텍스트만 가져오기 위해서 이렇게 함
				
				//comment의 내용을 수정하기 위해 input 태그에 출력을 먼저 해줘야 함
				//val.(comment)의 comment는 위의 let comment에 저장된 comment내용
				$("input[name=comment]").val(comment)
				//근데 이제 뭔 번호의 댓글인지 구분하기 위해 cno를 전달해야 함
				//여기서 cno는 위에 저장된 let cno 이부분임
				$("#modBtn").attr("data-cno", cno)
			})
			
			//#modBtn(MODIFY 버튼)에 대한 이벤트 처리
			$("#modBtn").click(function() {
				//this -> 수정하기 자기자신
				let cno = $(this).attr("data-cno")
				//인풋 박스에서 수정된 값을 넘겨야 함
				let comment = $("input[name=comment]").val()
				
				if(comment.trim() == '') {
					alert("댓글을 입력해주세요")
					$("input[name=comment]").focus()
					return
				}
				
				$.ajax({
					type: 'PATCH',					//요청 메서드
					url: '/heart/comments/'+cno,	//요청  URI
					headers: { "content-type" : "application/json" },  //요청헤더
					data : JSON.stringify({cno:cno, comment:comment}),  //서버로 전송할 데이터, stringify()로 직렬화 필요
					success : function(result) {		//서버로부터 응답이 도착하면 성공했을때, 호출될 함수
						alert(result)
						showList(bno)
					},
					error : function() { alert("error")	}  //에러가 발생했을 때, 호출될 함수
				})
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
				tmp += ' comment=<span class="comment">'		+ comment.comment 	+ '</span>'
				tmp += ' commenter=<span class="commenter">'	+ comment.commenter + '</span>'
				tmp += ' <button class="modBtn">수정</button>'
				tmp += ' <button class="delBtn">삭제</button>'
				tmp += '</li>'
			})
			return tmp + "</ul>";
		}

    </script>
    
    <script type="text/javascript">

	$(document).ready(function() {
		$('#sendBtn').on('click', function(evt) {
		 	evt.preventDefault();
			if (socket.readyState !== 1) return;
		  	  let msg = $('input#msg').val();
		  	  socket.send(msg);
	    });
		connect();
	})
	
	var socket = null;
	function connect() {
		var ws = new WebSocket("ws://localhost/ottt/replyEcho");
		//var ws = new WebSocket("ws://localhost:80/ottt/replyEcho");
		socket = ws;
		 
		ws.onopen = function () {
		    console.log('Info: connection opened.');
		};
		
		ws.onmessage = function (event) {
		    console.log(event.data+'\n');
		};
		
		ws.onclose = function (event) {
			console.log('Info: connection closed.');
			//setTimeout( function(){ connect(); }, 1000); // 연결이 끊겼다면 retry connection!!
		};
		ws.onerror = function (err) { console.log('Info: Error:',err); };
	}
	

</script>
</body>
</html>