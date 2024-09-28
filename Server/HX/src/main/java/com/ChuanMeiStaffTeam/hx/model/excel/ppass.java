package com.ChuanMeiStaffTeam.hx.model.excel;

import com.alibaba.excel.annotation.ExcelProperty;
import com.alibaba.excel.annotation.write.style.ColumnWidth;
import lombok.Data;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/09/28/13:02
 * @Description:
 */

@Data
public class ppass {

//    easyExcel 表头注解
    @ExcelProperty("姓名")
    @ColumnWidth(20) // 设置列宽
    private String name;
    @ExcelProperty("手机号")
    @ColumnWidth(20)
    private String phone;
    @ExcelProperty("邮箱")
    @ColumnWidth(30)
    private String email;
}
