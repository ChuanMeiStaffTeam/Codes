package com.ChuanMeiStaffTeam.hx.interceptor;



import com.ChuanMeiStaffTeam.hx.util.JwtUtil;
import com.auth0.jwt.exceptions.AlgorithmMismatchException;
import com.auth0.jwt.exceptions.SignatureVerificationException;
import com.auth0.jwt.exceptions.TokenExpiredException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.security.SignatureException;
import java.util.HashMap;
import java.util.Map;

/**
 * 登录拦截器
 */
@Component
public class LoginInterceptor implements HandlerInterceptor {


    /**
     * 前置处理 对请求的预处理
     * @throws Exception
     * @return true:继续流程  <br/> false: 流程终端
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        Map<String, String> map = new HashMap<>();
        // 获取 token
        String token = request.getHeader("token");
        // 验证 token
        try {
            JwtUtil.verifyToken(token);
            // 验证成功，放行
            return true;
        } catch (SignatureVerificationException e) {
            e.printStackTrace();
            map.put("message", "无效签名");
        } catch (TokenExpiredException e) {
            e.printStackTrace();
            map.put("message", "token已过期");
        } catch (AlgorithmMismatchException e) {
            e.printStackTrace();
            map.put("message", "签名算法不匹配");
        } catch (Exception e) {
            e.printStackTrace();
            map.put("message", "token验证失败");
        }
        // 验证失败，返回错误信息
        String json = new ObjectMapper().writeValueAsString(map);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().println(json);
        return false;
    }
}
