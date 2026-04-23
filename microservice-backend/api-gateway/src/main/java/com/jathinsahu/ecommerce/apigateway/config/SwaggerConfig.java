package com.jathinsahu.ecommerce.apigateway.config;

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
                        .title("API Gateway - JNexus Commerce")
                        .version("2.0.1-STABLE")
                        .description("API Gateway service for JNexus Commerce microservices platform. Routes all incoming client requests to the appropriate microservice.")
                        .contact(new Contact()
                                .name("Jathin Kumar Sahu")
                                .email("jathinsahu@gmail.com")));
    }
}
