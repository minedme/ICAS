package com.example.demo.test;

import com.example.demo.utils.UniCloudFunctionClient;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ConfigurableApplicationContext;

import java.util.HashMap;
import java.util.Map;

/**
 * uniCloud云函数调用测试类
 */
@SpringBootApplication(scanBasePackages = "com.example.demo")
public class UniCloudTest {

    public static void main(String[] args) {
        // 启动Spring Boot应用
        ConfigurableApplicationContext context = SpringApplication.run(UniCloudTest.class, args);
        
        // 获取云函数客户端
        UniCloudFunctionClient functionClient = context.getBean(UniCloudFunctionClient.class);
        
        try {
            // 测试调用getUserList云函数
            System.out.println("测试调用getUserList云函数...");
            Map<String, Object> result = functionClient.callFunction("getUserList");
            
            System.out.println("云函数调用结果：");
            if (result != null) {
                System.out.println("- code: " + result.get("code"));
                System.out.println("- message: " + result.get("message"));
                System.out.println("- data: " + result.get("data"));
            } else {
                System.out.println("- 调用失败，返回结果为空");
            }
        } catch (Exception e) {
            System.out.println("调用云函数时发生异常：" + e.getMessage());
            e.printStackTrace();
        } finally {
            // 关闭应用
            context.close();
        }
    }
}