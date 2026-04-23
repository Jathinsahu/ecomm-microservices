package com.jathinsahu.ecommerce.categoryservice.feigns;

import com.jathinsahu.ecommerce.categoryservice.dtos.ApiResponseDto;
import com.jathinsahu.ecommerce.categoryservice.security.UserDetails;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient("AUTH-SERVICE")
public interface AuthService {

    @GetMapping("/auth/isValidToken")
    ResponseEntity<ApiResponseDto<UserDetails>> validateToken(@RequestParam String token);

}
