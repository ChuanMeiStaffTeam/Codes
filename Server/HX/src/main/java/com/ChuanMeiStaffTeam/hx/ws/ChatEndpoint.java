package com.ChuanMeiStaffTeam.hx.ws;

import com.ChuanMeiStaffTeam.hx.model.message.Message;
import com.ChuanMeiStaffTeam.hx.util.MessageUtil;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpSession;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
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
@ServerEndpoint(value = "/chat", configurator = GetHttpSessionConfiguration.class)
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
        String message = MessageUtil.getMessage(true, null, getNames());
        // 调用方法
        broadcastAllUsers(message); //向所有在线用户   客户端发送消息

        System.out.println("WebSocket opened");
    }


    // 接收到消息时触发
    @OnMessage
    public void OnMessage(Session session, String message) {
        // 将message转换为Message对象
        ObjectMapper mapper = new ObjectMapper();
        try {
            Message mess = mapper.readValue(message, Message.class);
            // 获取要将数据发送给谁
            String toName = mess.getToName();
            // 获取消息内容
            String content = mess.getMessage();
            // 获取推动给指定用户的消息格式的数据
            // 获取当前登录的用户
            String username = (String) httpSession.getAttribute("user");
            String resultMessage = MessageUtil.getMessage(false, username, content);
            // 发送数据
            onlineUsers.get(toName).session.getBasicRemote().sendText(resultMessage);
        } catch (Exception e) {
            e.printStackTrace();
        }
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
            try {
                chatEndpoint.session.getBasicRemote().sendText(message);  // 向当前用户发送消息
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }


}
