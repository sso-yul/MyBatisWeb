<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>

<%@ include file="/inc/asset.jsp" %>

<style>
   
</style>

</head>
<body>
   	<!-- ex01.jsp -->
	<div class="container">
		<h1 class="page-header">WebSocket</h1>
		
		<fieldset>
			<input type="button" value="연결하기" id="btn1" class="btn btn-default" />
			<input type="button" value="말걸기" id="btn2" class="btn btn-default" />
			<input type="button" value="종료하기" id="btn3" class="btn btn-default" />
			<hr />
			<input type="text" class="form-control" id="txt" />
			<hr />
			
			<div id="output1" class="well"></div>
		</fieldset>      
   	</div>   
   
   	<script>
   	
   		// 나(현재페이지) <-> 요청, 응답 <-> 누군가(다른 사이트)
   		
   		// 아래 주소로 요청하면 (* echo: 돌려준다고 생각)
   		// var url = "ws://echo.websocket.org"; // 서버 죽음;;
   		let url = "ws://localhost:8090/spring/server";	
   	
   		let ws;
   		
   		$('#btn1').click(function() {
   			
   			// 소켓 통신 상황(ex.전화 하는 상황) -> 주체 ?
   			// - 전화를 거는 행동 	-> 내 의지
   			// - 전화를 받는 행동	-> 대기(***) -> 상대방 의지
   			// - 말을 하는 행동 	-> 내 의지
   			// - 말을 듣는 행동		-> 대기(***) -> 상대방 의지
   			
   			
   			// 웹 소켓 -> 서버와 통신
   			// 1. 소켓 생성
   			// 2. 서버 접속(연결)
   			// 3. 통신
   			// 4. 서버 접속 종료
   			
   			// 웹 소켓 생성 + 서버 접속
   			ws = new WebSocket(url);
   			
   			// 소켓 이벤트(상대방 의지로 발생하는 행동 > 이벤트 형식으로 구현)
   			ws.onopen = function (evt) {
   				print('서버와 연결되었습니다.');
   			};

   			ws.onmessage = function (evt) {
   				//return "(응답)" + msg;
   				print('응답 받은 데이터: ' + evt.data);
   			};
   			
   			ws.onclose = function (evt) {
   				
   			};
   			
   			ws.onerror = function (evt) {
   				
   			};
   			
   		});
   		
   		
   		function print(msg) {
   			$('#output1').append("<div>[" + new Date().toLocaleTimeString() + "] " + msg + "</div>");
   		}
   		
   		$('#btn3').click(function() {
   			// 연결 종료 요청을 보내기
   			ws.close();
   			print('서버와 연결이 종료되었습니다.');
   		});
   		
   		$('#btn2').click(function() {
   			// 서버에게 데이터 전송하기(말 걸기)
   			ws.send('안녕하세요.');
   		});
   		
   		// 이번에는 직접 입력한 데이터를 보내보기(채팅)
   		$('#txt').keyup(function() {
   			if (event.keyCode == 13) {
   				// 서버에게 데이터 전송하기
   				ws.send($(this).val());
   				
   				$(this).val('');
   				$(this).focus();
   			}
   		});
   		
	</script>
</body>
</html>