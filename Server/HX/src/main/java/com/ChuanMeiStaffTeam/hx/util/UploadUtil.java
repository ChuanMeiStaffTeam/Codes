package com.ChuanMeiStaffTeam.hx.util;

import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClient;
import com.aliyun.oss.OSSClientBuilder;
import com.aliyun.oss.model.CannedAccessControlList;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

/**
 * Created with IntelliJ IDEA.
 *
 * @Author: DongGuoZhen
 * @Date: 2024/07/02/10:51
 * @Description:
 */
@Component
public class UploadUtil {

    public static final String ALI_DOMAIN = "https://huanxi-project-image.oss-cn-shanghai.aliyuncs.com/";
    public static String uploadFile(MultipartFile file) {
        String originalFilename = file.getOriginalFilename(); // 文件名
        String ext = FilenameUtils.getExtension(originalFilename); // 文件扩展名
        String uuid = Uuid.UUID_32(); // 生成uuid
        String fileName = uuid + "." + ext; // 文件名
        String fullFileName = "img-main/Post-Image/" + fileName; // 文件路径
        // 地域节点
        String endpoint = "http://oss-cn-shanghai.aliyuncs.com";
        String accessKeyId = "";
        String accessKeySecret = "";
        // 创建OSSClient实例
        OSS OSSClient = new OSSClientBuilder().build(endpoint, accessKeyId, accessKeySecret);
        try {
            OSSClient.putObject("huanxi-project-image",
                    fullFileName,
                    file.getInputStream());
            // 将上传的文件设置为公共读
            OSSClient.setObjectAcl("huanxi-project-image", fullFileName, CannedAccessControlList.PublicRead);

        } catch (IOException e) {
            e.printStackTrace();
        }
        OSSClient.shutdown();
        return ALI_DOMAIN + fullFileName;
    }
}