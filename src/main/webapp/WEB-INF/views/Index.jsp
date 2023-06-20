<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- <c:set var="loginId" value="${sessionScope.id }" /> --%>
<c:set var="loginout" value="${sessionScope.id == null ? 'Login' : 'id: '+=loginId  }" />
<c:set var="loginoutlink" value="${sessionScope.id == null ? '/login/login' : '/login/logout' }" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.8.1/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/menu.css' />" /> 
    
    <title>earth</title>
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
    <div style="text-align: center;">
    
		<input type="text" id="msg" value="1234" />
		<button id="sendBtn">send message</button>
	
    </div>
    
    
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