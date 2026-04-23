package com.jathinsahu.ecommerce.serviceregistry.config;

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
                        .title("Service Registry - JNexus Commerce")
                        .version("2.0.1-STABLE")
                        .description("Eureka Service Registry for JNexus Commerce. Central hub for service discovery and dynamic registration of all microservices.")
                        .contact(new Contact()
                                .name("Jathin Kumar Sahu")
                                .email("jathinsahu@gmail.com")));
    }
}
