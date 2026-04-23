package com.jathinsahu.ecommerce.notificationservice.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Notification Service - JNexus Commerce")
                        .version("2.0.1-STABLE")
                        .description("Email Notification service for JNexus Commerce. Sends transactional emails for registration verification and order confirmations.")
                        .contact(new Contact()
                                .name("Jathin Kumar Sahu")
                                .email("jathinsahu@gmail.com")));
    }
}
