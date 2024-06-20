package com.example.hx.util;

import com.example.hx.model.message.ResultMessage;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/06/20/22:42
 * @Description:
 */
public class MessageUtil {
    public static String getMessage(boolean isSystemMessage, String fromName, Object message){
        ResultMessage resultMessage = new ResultMessage();
        resultMessage.setSystem(isSystemMessage);
        resultMessage.setMessage(message);
        if(fromName!=null) {  // 如果是系统消息，则不显示接受者名字
            resultMessage.setFromName(fromName);
        }
        // 将ResultMessage对象转换为json字符串返回
        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.writeValueAsString(resultMessage);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        return null;
    }
}
