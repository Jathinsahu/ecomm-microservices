package com.jathinsahu.ecommerce.authservice.controllers;

import com.jathinsahu.ecommerce.authservice.dtos.ApiResponseDto;
import com.jathinsahu.ecommerce.authservice.dtos.SignInRequestDto;
import com.jathinsahu.ecommerce.authservice.dtos.SignUpRequestDto;
import com.jathinsahu.ecommerce.authservice.exceptions.ServiceLogicException;
import com.jathinsahu.ecommerce.authservice.exceptions.UserAlreadyExistsException;
import com.jathinsahu.ecommerce.authservice.exceptions.UserNotFoundException;
import com.jathinsahu.ecommerce.authservice.exceptions.UserVerificationFailedException;
import com.jathinsahu.ecommerce.authservice.services.AuthService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.UnsupportedEncodingException;


@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/signup")
    ResponseEntity<ApiResponseDto<?>> registerUser(@RequestBody @Valid SignUpRequestDto signUpRequestDto)
            throws UnsupportedEncodingException, UserAlreadyExistsException, ServiceLogicException{
        return authService.registerUser(signUpRequestDto);
    }

    @GetMapping("/signup/resend")
    ResponseEntity<ApiResponseDto<?>> resendVerificationCode(@RequestParam String email)
            throws UnsupportedEncodingException, UserNotFoundException, ServiceLogicException{
        return authService.resendVerificationCode(email);
    }

    @GetMapping("/signup/verify")
    ResponseEntity<ApiResponseDto<?>> verifyRegistrationVerification(@RequestParam String code)
            throws UserVerificationFailedException{
        return authService.verifyRegistrationVerification(code);
    }

    @PostMapping("/signin")
    ResponseEntity<ApiResponseDto<?>> authenticateUser(@RequestBody @Valid SignInRequestDto signInRequestDto){
        return authService.authenticateUser(signInRequestDto);
    }

    @GetMapping("/isValidToken")
    ResponseEntity<ApiResponseDto<?>> validateToken(@RequestParam String token){
        return authService.validateToken(token);
    }

}
