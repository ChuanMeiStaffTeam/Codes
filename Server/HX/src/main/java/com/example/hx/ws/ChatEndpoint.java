package com.example.hx.ws;

import com.example.hx.util.MessageUtil;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpSession;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/20/23:04
 * @Description:
 */

@Component
@ServerEndpoint("/chat")
public class ChatEndpoint { // 定义websocket的路径

    // 用来存储每个客户端对应的chatEndpoint对象   线程安全的map
    private static Map<String, ChatEndpoint> onlineUsers = new ConcurrentHashMap<>();

    private Session session;  // 通过session来发送指定客户端消息

    private HttpSession httpSession;  // 通过httpSession来获取客户端的session信息


    // 连接建立时触发
    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {
        this.session = session;
        HttpSession httpSession = (HttpSession) config.getUserProperties().get(HttpSession.class.getName());
        this.httpSession = httpSession;
        // 从httpSession中用户名获取
        String username = (String) httpSession.getAttribute("username");
        // 将当前用户添加到在线用户列表
        onlineUsers.put(username, this);  //onlineUsers集合中的键就是当前在线用户的用户名

        // 向所有在线用户发送消息
        // 获取消息
        String message = MessageUtil.getMessage(true,null,getNames());
        // 调用方法 broadcastAllUsers() 向所有在线用户发送消息

        System.out.println("WebSocket opened");
    }



    // 接收到消息时触发
    @OnMessage
    public void OnMessage(Session session, String message) {
        System.out.println("WebSocket closed");
    }


    // 连接关闭时触发
    @OnClose
    public void onClose(Session session) {
        System.out.println("WebSocket message received");
    }

    private Set<String> getNames() {
        return onlineUsers.keySet();   // 返回所有在线用户的用户名 集合
    }


    private void broadcastAllUsers(String message) {
        // 向所有在线用户发送消息
        Set<String> strings = onlineUsers.keySet();
        for (String name : strings) {
            ChatEndpoint chatEndpoint = onlineUsers.get(name);  // 获取当前用户的chatEndpoint对象
            chatEndpoint.session.getAsyncRemote().sendText(message);  // 向当前用户发送消息
        }
    }


}
