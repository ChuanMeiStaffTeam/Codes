package com.hxapp.hxmanage.util;

import com.aliyun.oss.ClientBuilderConfiguration;
import com.aliyun.oss.OSS;
import com.aliyun.oss.OSSClient;
import com.aliyun.oss.OSSClientBuilder;
import com.aliyun.oss.common.auth.Credentials;
import com.aliyun.oss.common.auth.CredentialsProvider;
import com.aliyun.oss.common.auth.DefaultCredentials;
import com.aliyun.oss.common.comm.SignVersion;
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


    @Value("${aly.accessKeyId}")
    private String accessKeyId;

    @Value("${aly.accessKeySecret}")
    private String accessKeySecret;

    public  final String ALI_DOMAIN = "https://huanxi-project-image.oss-cn-shanghai.aliyuncs.com/";
    public  String uploadFile(MultipartFile file) {
        String originalFilename = file.getOriginalFilename(); // 文件名
        String ext = FilenameUtils.getExtension(originalFilename); // 文件扩展名
        String uuid = UUidUtil.UUID_32(); // 生成uuid
        String fileName = uuid + "." + ext; // 文件名
        String fullFileName = "img-main/Post-Image/" + fileName; // 文件路径
        String endpoint = "http://oss-cn-shanghai.aliyuncs.com";
        String re = "cn-shanghai"; // 区域
        // 创建OSSClient实例
//        OSS OSSClient = new OSSClientBuilder().build(endpoint, accessKeyId, accessKeySecret);

        CredentialsProvider provider = new CredentialsProvider() {
            @Override
            public void setCredentials(Credentials credentials) {

            }

            @Override
            public Credentials getCredentials() {
                return new DefaultCredentials(accessKeyId, accessKeySecret);
            }
        };
        ClientBuilderConfiguration conf = new ClientBuilderConfiguration();
        conf.setSignatureVersion(SignVersion.V4);
        OSS ossClient = OSSClientBuilder.create()
                .endpoint(endpoint)
                .credentialsProvider(provider)
                .clientConfiguration(conf)
                .region(re)
                .build();
        try {
            ossClient.putObject("huanxi-project-image",
                    fullFileName,
                    file.getInputStream());
            // 将上传的文件设置为公共读
            ossClient.setObjectAcl("huanxi-project-image", fullFileName, CannedAccessControlList.PublicRead);

        } catch (IOException e) {
            e.printStackTrace();
        }
        ossClient.shutdown();
        return ALI_DOMAIN + fullFileName;
    }
}