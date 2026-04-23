package com.jathinsahu.ecommerce.cartservice.config;

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
                        .title("Cart Service - JNexus Commerce")
                        .version("2.0.1-STABLE")
                        .description("Shopping Cart service for JNexus Commerce. Manages add, remove, clear, and retrieval of user cart items.")
                        .contact(new Contact()
                                .name("Jathin Kumar Sahu")
                                .email("jathinsahu@gmail.com")));
    }
}
