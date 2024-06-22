package com.ChuanMeiStaffTeam.hx.exception;


import com.ChuanMeiStaffTeam.hx.common.AppResult;

/**
 * 自定义异常类
 */
public class ApplicationException extends RuntimeException{

    //在异常中持有一个错误信息
    private AppResult errorResult;

    /**
     * 构造方法
     * @param errorResult
     */
    public ApplicationException (AppResult errorResult) {
        super(errorResult.getMessage());
        this.errorResult = errorResult;
    }

    public AppResult getErrorResult() {
        return errorResult;
    }

    public ApplicationException(String message) {
        super(message);
    }

    public ApplicationException(String message, Throwable cause) {
        super(message, cause);
    }

    public ApplicationException(Throwable cause) {
        super(cause);
    }
}
