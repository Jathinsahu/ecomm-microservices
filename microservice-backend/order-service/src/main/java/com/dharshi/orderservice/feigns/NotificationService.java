package com.jathinsahu.ecommerce.orderservice.feigns;


import com.jathinsahu.ecommerce.orderservice.dtos.ApiResponseDto;
import com.jathinsahu.ecommerce.orderservice.dtos.MailRequestDto;
import com.jathinsahu.ecommerce.orderservice.modals.Order;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient("NOTIFICATION-SERVICE")
public interface NotificationService {

    @PostMapping("/notification/send")
    ResponseEntity<ApiResponseDto<?>> sendEmail(@RequestBody MailRequestDto requestDto);
}
