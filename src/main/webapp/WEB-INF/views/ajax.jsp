<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
    <title>ajax</title>
</head>
<body>
	
	<!-- 화면단에서 요청함 -->
	<h2>{name : "earth", age : 10}</h2>
	<!-- 서버로 위의 h2부분 데이터 보내는 부분(SEND버튼)은 자바스크립트로 처리 -->
	<button id="sendBtn" type="button">SEND</button>
	
	<h2>Data from Server: </h2>
	<div id="data"></div>
	
	<!-- ajax.jsp가 로드 되면 밑의 자바 스크립트는 무조건 실행된다(ready함수니까) - 이벤트 -->
	<script type="text/javascript">
		$(document).ready(function() {
			//json 객체 생성->person. 이렇게 선언을 하면 key value형태로 브라우저 상에 만들어짐
			//http 통신 타야하기 때문에 문자열로 변환해서 보내야 한다
			let person = {name : "earth", age : 10}
			
			//서버로 부터 받는 부분
			let person2 = {}
			
			//click() 이벤트에 따른 처리 selector
			$("#sendBtn").click(function () {
				$.ajax({
					//{name : "earth", age : 10} 이게 보내져야 하니 controller에 메서드가 하나 더 추가 되어야함 post매핑으로
					//request URI. key 값은 URL로 표현
					url : '/heart/send',
					//type은 기본 Get 방식이니 Post로 바꿔줌
					//요청 메서드
					type : 'post',
					//서버를 보내는데 설정하는 것. 바디가 아닌 요청 헤더(f12 -> 네트워크 -> 헤더)에 들어감
					headers : {"content-type" : "application/json"},
					//서버로부터 전송받을 데이터 타입
					dataType : 'text',
					//http통신을 위해 데이터를 json문자열로 변환하여 보냄
					//서버로 전송할 데이터(괄호 안의 person)를 stringify()로 직렬화가 필요해서 실행함
					data : JSON.stringify(person),
					//위의 모든 것이 성공(정상작동) 시 나오는 함수
					//서버로부터 응답이 도착하면 호출될 함수
					success : function(result) {
						//person2에 저장되는데 js객체로 저장됨
						//result는 서버가 전송한 데이터
						person2 = JSON.parse(result)
						
						//잘 됐나 확인
						alert("received = " + result)
						//html로 문자열(객체)가 생성되어 텍스트가 화면에 출력됨
						$("#data").html("name = " + person2.name + ", age = " + person2.age)
					},
					//서버로부터 에러가 발생했을 때 호출되는 함수(콜백함수)
					error : function() {
						alert("error")
					}
				})
			})
		})
	
	</script>
	
	
</body>
</html>