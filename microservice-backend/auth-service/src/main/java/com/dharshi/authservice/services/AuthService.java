package com.jathinsahu.ecommerce.authservice.services;

import com.jathinsahu.ecommerce.authservice.dtos.ApiResponseDto;
import com.jathinsahu.ecommerce.authservice.dtos.SignInRequestDto;
import com.jathinsahu.ecommerce.authservice.dtos.SignUpRequestDto;
import com.jathinsahu.ecommerce.authservice.exceptions.ServiceLogicException;
import com.jathinsahu.ecommerce.authservice.exceptions.UserAlreadyExistsException;
import com.jathinsahu.ecommerce.authservice.exceptions.UserNotFoundException;
import com.jathinsahu.ecommerce.authservice.exceptions.UserVerificationFailedException;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;

@Service
public interface AuthService {
    ResponseEntity<ApiResponseDto<?>> registerUser(SignUpRequestDto signUpRequestDto) throws UnsupportedEncodingException, UserAlreadyExistsException, ServiceLogicException;
    ResponseEntity<ApiResponseDto<?>> resendVerificationCode(String email) throws UnsupportedEncodingException, UserNotFoundException, ServiceLogicException;
    ResponseEntity<ApiResponseDto<?>> verifyRegistrationVerification(String code) throws UserVerificationFailedException;
    ResponseEntity<ApiResponseDto<?>> authenticateUser(SignInRequestDto signInRequestDto);
    ResponseEntity<ApiResponseDto<?>> validateToken(String token);
}
