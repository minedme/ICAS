package com.example.demo.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

/**
 * uniCloud云函数调用客户端
 * 使用RestTemplate调用云函数接口
 */
public class UniCloudFunctionClient {

    private static final Logger logger = LoggerFactory.getLogger(UniCloudFunctionClient.class);
    private final RestTemplate restTemplate;
    private final String baseUrl;

    /**
     * 构造函数
     * @param baseUrl 云函数基础URL
     */
    public UniCloudFunctionClient(String baseUrl) {
        this.restTemplate = new RestTemplate();
        this.baseUrl = baseUrl;
    }
    
    /**
     * 构造函数（使用外部提供的RestTemplate）
     * @param baseUrl 云函数基础URL
     * @param restTemplate RestTemplate实例
     */
    public UniCloudFunctionClient(String baseUrl, RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
        this.baseUrl = baseUrl;
    }

    /**
     * 调用云函数
     * @param functionName 云函数名称
     * @param params 请求参数
     * @return 云函数响应结果
     */
    public Map<String, Object> callFunction(String functionName, Map<String, Object> params) {
        // 构建请求URL
        String url = baseUrl + "/" + functionName;
        logger.info("调用云函数: {}, URL: {}, 参数: {}", functionName, url, params);

        // 设置请求头
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        // 尝试使用POST请求（推荐方式，适合传递复杂对象）
        try {
            logger.info("尝试使用POST请求调用云函数");
            // 直接传递params作为请求体
            ResponseEntity<Map> response = restTemplate.postForEntity(url, params, Map.class);

            // 返回响应结果
            logger.info("云函数调用成功: {}, 响应: {}", functionName, response.getBody());
            return response.getBody();
        } catch (Exception postException) {
            logger.error("POST请求调用云函数失败: {}，错误: {}", functionName, postException.getMessage());
            
            // 两种方法都失败，返回错误结果
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("code", -1);
            errorResult.put("message", "调用云函数失败: POST方法失败");
            errorResult.put("error", postException.getMessage());
            return errorResult;
        }
    }
    
    /**
     * 构建查询字符串
     * @param params 参数Map
     * @return 查询字符串
     */
    private String buildQueryString(Map<String, Object> params) {
        if (params == null || params.isEmpty()) {
            return "";
        }
        
        StringBuilder queryString = new StringBuilder();
        for (Map.Entry<String, Object> entry : params.entrySet()) {
            if (entry.getValue() != null) {
                if (queryString.length() > 0) {
                    queryString.append("&");
                }
                // 使用URL编码处理参数值
                String value = entry.getValue().toString();
                try {
                    value = java.net.URLEncoder.encode(value, "UTF-8");
                } catch (java.io.UnsupportedEncodingException e) {
                    logger.error("URL编码失败: {}", e.getMessage());
                }
                queryString.append(entry.getKey()).append("=").append(value);
            }
        }
        return queryString.toString();
    }

    /**
     * 调用云函数（无参数）
     * @param functionName 云函数名称
     * @return 云函数响应结果
     */
    public Map<String, Object> callFunction(String functionName) {
        return callFunction(functionName, new HashMap<>());
    }
}