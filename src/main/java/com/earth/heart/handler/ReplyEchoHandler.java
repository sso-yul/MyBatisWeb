package com.earth.heart.handler;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

public class ReplyEchoHandler extends TextWebSocketHandler {

	//클라이언트가 서버에 접속했을 때 
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.out.println("afterConnectionEstablished: " + session);
	}
	
	//소켓에 어떤 메세지를 보냈을 때
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		System.out.println("handleTextMessage: " + session + " : " + message);
	}
	
	//연결이 닫혔을 때
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception{
		System.out.println("afterConnectionClosed: " + session + " : " + status);
	}
}
