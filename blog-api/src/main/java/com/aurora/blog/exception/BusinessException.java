package com.aurora.blog.exception;

import com.aurora.blog.common.ResultCode;
import lombok.Getter;

/**
 * 业务异常
 *
 * @author aurora
 */
@Getter
public class BusinessException extends RuntimeException {

    private final long code;

    public BusinessException(String message) {
        super(message);
        this.code = ResultCode.FAILED.getCode();
    }

    public BusinessException(ResultCode resultCode) {
        super(resultCode.getMessage());
        this.code = resultCode.getCode();
    }

    public BusinessException(ResultCode resultCode, String message) {
        super(message);
        this.code = resultCode.getCode();
    }

    public BusinessException(long code, String message) {
        super(message);
        this.code = code;
    }
}
