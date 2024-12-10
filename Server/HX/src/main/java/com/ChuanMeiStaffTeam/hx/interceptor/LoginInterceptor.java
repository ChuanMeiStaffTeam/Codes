package com.ChuanMeiStaffTeam.hx.interceptor;



import com.ChuanMeiStaffTeam.hx.dao.UserMapper;
import com.ChuanMeiStaffTeam.hx.exception.ApplicationException;
import com.ChuanMeiStaffTeam.hx.model.User;
import com.ChuanMeiStaffTeam.hx.util.JwtUtil;
import com.auth0.jwt.exceptions.AlgorithmMismatchException;
import com.auth0.jwt.exceptions.SignatureVerificationException;
import com.auth0.jwt.exceptions.TokenExpiredException;
import com.auth0.jwt.interfaces.Claim;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.security.SignatureException;
import java.util.HashMap;
import java.util.Map;

/**
 * 登录拦截器
 */
@Slf4j
@Component
public class LoginInterceptor implements HandlerInterceptor {

    @Resource
    private UserMapper userMapper;



    /**
     * 前置处理 对请求的预处理
     * @throws Exception
     * @return true:继续流程  <br/> false: 流程终端
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        Map<String, Object> map = new HashMap<>();
        String uri = request.getRequestURI(); // 获取请求的URI
        if("/favicon.ico".equals(uri)) {
            return true;
        }
        // 获取 token
        String token = request.getHeader("token");
        // 验证 token
        try {
            JwtUtil.verifyToken(token);
            log.info("token验证成功");
            // 验证成功，放行
            // 校验用户是否被锁定 拉黑
            DecodedJWT tokenInfo = JwtUtil.getTokenInfo(token);
            String userid = tokenInfo.getClaim("userid").asString();
            User user = userMapper.selectByUserId(Integer.parseInt(userid));
            if(!user.getAccountLocked()) {
                return true;
            } else {
                map.put("code", 405);
                map.put("message", "用户被锁定");
                log.error("用户被锁定");
            }

        } catch (SignatureVerificationException e) {
            e.printStackTrace();
            map.put("code", 401);
            map.put("message", "无效签名");
            log.error("无效签名");
        } catch (TokenExpiredException e) {
            e.printStackTrace();
            map.put("code", 402);
            map.put("message", "token已过期");
            log.error("token已过期");
        } catch (AlgorithmMismatchException e) {
            e.printStackTrace();
            map.put("code", 403);
            map.put("message", "签名算法不匹配");
            log.error("签名算法不匹配");
        } catch (Exception e) {
            e.printStackTrace();
            map.put("code", 404);
            log.error("token验证失败");
            map.put("message", "token验证失败");
        }
        // 验证失败，返回错误信息
        String json = new ObjectMapper().writeValueAsString(map);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().println(json);
        return false;
    }
}
