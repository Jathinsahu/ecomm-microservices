package com.jathinsahu.ecommerce.userservice.services;

import com.jathinsahu.ecommerce.userservice.dtos.ApiResponseDto;
import com.jathinsahu.ecommerce.userservice.exceptions.ServiceLogicException;
import com.jathinsahu.ecommerce.userservice.exceptions.UserNotFoundException;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;


@Service
public interface UserService {
    ResponseEntity<ApiResponseDto<?>> existsUserById(String userId) throws ServiceLogicException;

    ResponseEntity<ApiResponseDto<?>> getUserById(String id) throws ServiceLogicException, UserNotFoundException;
}
