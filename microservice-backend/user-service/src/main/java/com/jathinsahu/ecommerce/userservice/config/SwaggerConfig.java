package com.jathinsahu.ecommerce.userservice.config;

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
                        .title("User Service - JNexus Commerce")
                        .version("2.0.1-STABLE")
                        .description("User profile management service for JNexus Commerce. Handles user existence checks and profile retrieval for inter-service communication.")
                        .contact(new Contact()
                                .name("Jathin Kumar Sahu")
                                .email("jathinsahu@gmail.com")));
    }
}
