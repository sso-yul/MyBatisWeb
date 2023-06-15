<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="loginId" value="${sessionScope.id }" />
<c:set var="loginout" value="${sessionScope.id == null ? 'Login' : 'id: '+=loginId }" />
<c:set var="loginoutlink" value="${sessionScope.id == null ? '/login/login' : '/login/logout' }" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
     	<meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/menu.css' />" /> 
    
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <title>게시글 조회</title>
    
    <style type="text/css">
    	
    	* {
    		font-family: 'Noto Sans KR', sans-serif;
    	}
    	
    	.container {
    		width: 50%;
    		margin: auto;
    	}

	    .btn {
	    	border: 1px solid #ab77e6;
	    	font-size: 15px;
	    	color: #ab77e6;
	  		background-color: transparent;
	  		padding: 3px;
	  		border-radius: 3px;
	  		cursor: pointer;
	    }
	    
	    .btn:hover {
	    	text-decoration: none;
	    	background-color: #ab77e6;
	    	color: white;
	    }
	    
	    .writing-header {
	    	position: relative;
	    	margin: 20px 0 0 0;
	    	padding: 10px;
	    	border-bottom: 3px solid #9780ff;
	    }
	    
	    .frm {
	    	width: 100%;
	    }
	    
	    input {
	    	width: 100%;
	    	height: 35px;
	    	margin:5px 0px 10px 0px;
	    	border: 1px solid #e9e8e8;
	    	padding: 8px;
	    	background: #f8f8f8;
	    	outline-color: #9780ff;
	    }
	    
	    textarea {
	    	width: 100%;
	    	background: #f8f8f8;
	    	margin: 5px 0px 10px 0px;
	    	border: 1px solid #e9e8e8;
	    	resize: none;
	    	padding: 8px;
	    	outline-color: #9780ff;
	    }
    
    </style>
    
    
</head>
<body>
	
	<div id="menu">
    <ul>
    	<li id="logo">earth</li>
    	<li><a href="<c:url value='/' />">Home</a></li>
    	<li><a href="<c:url value='/board/list' />">Board</a></li>
    	<li><a href="<c:url value='${loginoutlink }' />">${loginout }</a></li>
    	<li><a href="<c:url value='/register/add' />">SignUp</a></li>
    	<li><a href="#"><i class="fas fa-search" style="color : #fff;"></i></a></li>
    </ul>
    </div>
	
	<!-- ready 되었을 때 호출되는 콜백 : 자바로 치면 진입점.. 자바의 메인 함수와 같음(main())-->
	<script type="text/javascript">						//https://api.jquery.com/ 또는 https://developer.mozilla.org/ 여기서 함수 확인
		$(document).ready(function() {
			let bno = $("input[name=bno]").val()		//인풋 태그 안에 속성(네임)의 값(bno)의 value(.val())를 bno에 저장
			
//			$("#listBtn").on("click", function() {		//listBtn에 on(지금은 클릭) 이벤트가 발생했을 때 이런 펑션(함수)가 실행됨
//				alert("listBtn clicked")
//			})
			$("#listBtn").on("click", function() {
				location.href = "<c:url value='/board/list${searchItem.queryString}' />"		//해당 페이지(page= '요부분') 정보로 화면 전환됨
			})
			
			//게시글 삭제
			$("#removeBtn").on("click", function() {	//삭제 버튼 눌렀을 대 일어나는 이벤트 (기능) 함수
				if(!confirm("게시물이 삭제됩니다."))			
					return;						//false면 모달이 꺼지며 원래 화면 그냥 리턴됨
				
				let form = $("#form")					//
				form.attr("action", "<c:url value='/board/remove${searchItem.queryString}' />")			//form의 attribute속성(action)을 추가할 수 있음 참고: https://api.jquery.com/attr/#attr-attributeName-value
				form.attr("method", "post")		//post방식으로 전송
				form.submit()
			})
			
			//게시글 작성
			$("#writeBtn").on("click", function() {	//글작성 버튼 눌렀을 때 일어나는 기능 함수
				let form = $("#form")
				form.attr("action", "<c:url value='/board/write' />")
				form.attr("method", "post")
				
			//제목 또는 내용이 채워졌는지 확인해야함
				if(formCheck()) {
					form.submit()
				}
			})
			let formCheck = function() {
				let form = document.getElementById("form")
				
				//validation 체크(null 인지 아닌지)
				if(form.title.value == "") {
					alert("제목을 입력하세요")
					form.title.focus()
					return false
				}
				if(form.content.value == "") {
					alert("내용을 입력하세요")
					form.content.focus()
					return false
				}
				return true
			}
			
			//게시글 수정
			$("#modifyBtn").on("click", function() {	//수정버튼 눌렀을 때 일어나는 기능 함수
				//readonly 속성 제거
				let form = $("#form")
				let isReadonly = $("input[name=title]").attr('readonly')	//바꾸기 위해 readonly를 저장
				
				//읽기 상태이면 수정 상태로 변경해야 함
				if(isReadonly == 'readonly') {
					$(".writing-header").html("게시판 수정")						//.html 태그를 쓰면 문자열(게시판 수정)로 변경이 가능해짐
					$("input[name=title]").attr('readonly', false)				//input 속성의 값이 title인 것을 찾아 attribute 추가해서 readonly 상태를 false로 설정
					$("textarea").attr('readonly', false)						//textarea 속성의 attribute를 추가해서 readonly 상태를 false로 변경
					$("#modifyBtn").html("<i class='fa-light fa-pencil'></i> 수정하기")	//modifyBtn는 id니까 #이 붙음
					return;
				}
				//화면단에서 수정 했으니 이제 수정상태로 수정된 내용을 서버로 전송해야 함
				form.attr("action","<c:url value='/board/modify${searchItem.queryString}' />")
				form.attr("method", "post")
				if(formCheck()) {
					form.submit()
				}	//여기까지 오면 BoardController의 modify로 이동해서 처리됨
			})
			
			//댓글 보내기 기능
			$("#insertBtn").click(function() {				
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
			
			//해당 댓글 삭제 기능
			$("#commentList").on("click", ".delBtn", function() {
				//alert("삭제 버튼 클릭됨") 요건 작동하나 확인해보려고 넣은 거
				//아래는 하나 지정해서 해당 댓글만 삭제되게 하는 방법
				//cno로 구분할 수 있음 cno의 부모는 bno
				//부모bno태그로 접근해서 자식cno으로 가야 함
				//이 부모의 attribute
				let cno = $(this).parent().attr("data-cno")		//공통으로 리턴되어지는 건 <li> 태그. <li> 태르는 buttom의 부모격에 해당
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
			
			//게시글 들어갔을 때 댓글 바로 보이기
			let showList = function(bno) {
				//jQuery.ajax() -> $.ajax()
	    		//읽어오는 메서드(댓글 로드)
				$.ajax({
	    			type : 'GET',								//요청 메서드
	    			url : '/heart/comments?bno='+bno,			//요청 URI, http://localhost/heart/comments?bno=8
	    			success : function(result) {				//성공 시에 호출, 댓글 결과. 여기서 잘 ... 출력해주면 됨 위의 <div id="commentList"></div>여기다가
						$("#commentList").html(toHtml(result))	//result = 서버가 전송한 데이터. 나오는지 테스트 해봐야 한다
					},
					error : function() {alert("error")}			//정상실행 안 됐을 때 경고창으로 확인 가능하게 넣어야 함
		   		})
    		}
			
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
			
			//#modiBtn(MODIFY 버튼)에 대한 이벤트 처리
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
			
			//위의 toHtml쓰기 위해 test.jsp에서 가져옴
			let toHtml = function(comments) {
				//댓글 목록을 ul, li로 표현할 것이다
				let tmp = '<ul style="display: block;">'
				//li는 foreach문으로 작성해야 한다왜냐면... 반복 되잖아
				//파라미터는 일단 comment로 정의. 댓글 하나하나니까
				comments.forEach(function(comment) {
					//밖에서 큰따옴 썼으니까 안에서는 작은따옴쓴다
					//comment.cno -> 하나하나의 cno
					tmp += '<li style="background-color: #f9f9fa; border-bottom: 1px solid rgb(235, 236, 239); color: black; width: auto;" '
					tmp += ' data-cno='		+ comment.cno
					tmp += ' data-recmt='	+ comment.recmt
					tmp += ' data-bno='		+ comment.bno + '>'
					tmp += ' comment=<span class="comment">'		+ comment.comment + '</span>'
					tmp += ' commenter=<span class="commenter">'	+ comment.commenter + '</span>'
					tmp += ' <button class="delBtn">삭제</button>'
					tmp += ' <button class="modBtn">수정</button>'
					tmp += '</li>'
				})
				return tmp + "</ul>";
			}
			showList(bno)
		})
	</script>
	
	<script type="text/javascript">
	  var ws = new WebSocket("ws://localhost:/");
	
	  ws.onopen = function () {
	      console.log('Info: connection opened.');
	      setTimeout( function(){ connect(); }, 1000); // retry connection!!
	  };
	
	  ws.onmessage = function (event) {
	      console.log(event.data+'\n');
	  };
	
	  ws.onclose = function (event) { console.log('Info: connection closed.'); };
	  ws.onerror = function (err) { console.log('Info: Error:',err); };
	  
	  $('#insertBtn').on('click', function(evt) {
	 	evt.preventDefault();
		if (socket.readyState !== 1) return;
	  	  let msg = $('input#msg').val();
	  	  ws.send(msg);
	  });

	</script>
	
	<script type="text/javascript">
		//게시물 등록 실패
		let msg = "${msg}"
		if(msg == "WRITE_ERROR")
			alert("게시물 등록에 실패했습니다. 다시 시도해 주세요")
		if(msg == "MODE_ERROR")
			alert("게시물 수정에 실패했습니다. 다시 시도해 주세요")
	</script>
	
	<div class="container">
		<h2 class="writing-header">게시판 ${mode=="new" ? "작성" : "읽기"}</h2>
		<form action="" id="form" class="frm" method="post">
			<!-- 페이지페이지 전환 이런 거 할 때는 값을 받아오기 위해 name 속성을 쓴다 -->
			<input type="hidden" name="bno" value="${boardDTO.bno }" />
			<!-- 삼항 연산자 - new로 저장했을 때 참/ 거짓 .... 그리고 뒤에는 인풋 태그 안에 리드온니 속성에 리드온니 타입을 준 것 -->
			<input type="text" name="title" value="${boardDTO.title }" ${mode=="new" ? "" : "readonly = 'readonly'" } />
			<br />
			<textarea rows="20" name="content" ${mode=="new" ? "" : "readonly = 'readonly'" } >${boardDTO.content }</textarea>
			<br />
			
			<!-- mode의 값이 new이냐 아니냐 체크/new이면 수정(등록)이 가능하니 이 조건이 나오면 버튼 나오게 함 ne=not equal  eq = equal-->
			<c:if test="${mode eq 'new' }">
				<button type="button" id="writeBtn" class="btn btn-write"><i class="fas fa-pencil"></i>등록</button>
			</c:if>
			
			<c:if test="${mode ne 'new' }">
				<button type="button" id="writeNewBtn" class="btn btn-write"><i class="fas fa-pencil-alt"></i>작성</button>
			</c:if>
			
			<!-- 작성자와 로그인 아이디가 같을 때만 수정/삭제 가능한 버튼 뜨게 하기 -->
			<c:if test="${boardDTO.writer eq loginId }">
				<button type="button" id="modifyBtn" class="btn btn-write"><i class="fas fa-edit"></i>수정</button>
				<button type="button" id="removeBtn" class="btn btn-write"><i class="fas fa-trash"></i>삭제</button>
			</c:if>
			
			<button type="button" id="listBtn" class="btn btn-list"><i class="fas fa-bars"></i>목록</button>
		</form>
		
		<button type="button" id="sendBtn">SEND</button>
		<button type="button" id="modBtn">수정하기</button><br />
				
		comment: <input type="text" name="comment" />
		<button type="button" id="insertBtn">댓글 작성하기</button><br />
		<!-- 댓글 여기에 출력 -->
		<!-- 댓글 자체가 바로 츌력이 되게 해주면 되는데 이걸 test.jsp에서 showList로 정리 해놨음(이벤트 클릭 시 쇼 리스트) -->
		<!-- 근데 이건 클릭 시 이벤트 발생하는 거고(onclick) 여기서는 그냥 페이지 들어갔을 때 자동으로(ready) 보이는 거 -->
		<div id="commentList">
		
		</div>
		
		
		
	</div>
</body>
</html>