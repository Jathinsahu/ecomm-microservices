package com.jathinsahu.ecommerce.orderservice.feigns;

import com.jathinsahu.ecommerce.orderservice.dtos.ApiResponseDto;
import com.jathinsahu.ecommerce.orderservice.security.UserDetails;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient("AUTH-SERVICE")
public interface AuthService {

    @GetMapping("/auth/isValidToken")
    ResponseEntity<ApiResponseDto<UserDetails>> validateToken(@RequestParam String token);

}
