package com.ChuanMeiStaffTeam.hx.exception;


import com.ChuanMeiStaffTeam.hx.common.AppResult;
import com.ChuanMeiStaffTeam.hx.common.ResultCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * 全局异常处理类
 */
@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    @ResponseBody
    @ExceptionHandler(ApplicationException.class)   //表示要处理那种异常
    public AppResult applicationExceptionHandler(ApplicationException e) {
        //打印异常信息
        e.printStackTrace();  //上生产之前删除
        log.error(e.getMessage());

        if(e.getErrorResult() != null) {
            return e.getErrorResult();
        }

        //非空校验
        if(e.getMessage() == null || e.getMessage().equals("")) {
            return AppResult.failed(ResultCode.ERROR_SERVICES);
        }
        //返回具体异常信息
        return AppResult.failed(e.getMessage());
    }


    @ResponseBody
    @ExceptionHandler(Exception.class)
    public AppResult exceptionHandler(Exception e) {
        e.printStackTrace();  //上生产之前删除
        log.error(e.getMessage());
        //非空校验
        if(e.getMessage() == null || e.getMessage().equals("")) {
            return AppResult.failed(ResultCode.ERROR_SERVICES);
        }

        //返回具体异常信息
        return AppResult.failed(e.getMessage());
    }
}
