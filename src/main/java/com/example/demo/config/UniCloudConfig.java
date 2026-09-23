package com.example.demo.config;

import com.example.demo.utils.UniCloudFunctionClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class UniCloudConfig {

    @Value("${unicloud.base-url}")
    private String baseUrl;

    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
    
    @Bean
    public UniCloudFunctionClient uniCloudFunctionClient(RestTemplate restTemplate) {
        return new UniCloudFunctionClient(baseUrl, restTemplate);
    }
}
