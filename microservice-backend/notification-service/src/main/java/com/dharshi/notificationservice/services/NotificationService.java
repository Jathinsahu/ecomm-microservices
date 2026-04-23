package com.jathinsahu.ecommerce.notificationservice.services;

import com.jathinsahu.ecommerce.notificationservice.dtos.ApiResponseDto;
import com.jathinsahu.ecommerce.notificationservice.dtos.MailRequestDto;
import jakarta.mail.MessagingException;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;

@Service
public interface NotificationService {
    ResponseEntity<ApiResponseDto<?>> sendEmail(MailRequestDto requestDto);
}
