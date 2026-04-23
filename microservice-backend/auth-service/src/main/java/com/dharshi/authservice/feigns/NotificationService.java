package com.jathinsahu.ecommerce.authservice.feigns;


import com.jathinsahu.ecommerce.authservice.dtos.ApiResponseDto;
import com.jathinsahu.ecommerce.authservice.dtos.MailRequestDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@FeignClient("NOTIFICATION-SERVICE")
public interface NotificationService {

    @PostMapping("/notification/send")
    ResponseEntity<ApiResponseDto<?>> sendEmail(@RequestBody MailRequestDto requestDto);
}
